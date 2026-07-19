import '../models/disciplina.dart';
import '../models/pessoa.dart';
import '../models/professor.dart';
import 'database_provider.dart';

class ProfessorRepository {
  final DatabaseProvider _databaseProvider;

  ProfessorRepository({DatabaseProvider? databaseProvider})
    : _databaseProvider = databaseProvider ?? appDatabaseProvider;

  Future<List<Professor>> listar({
    String? nome,
    int? disciplinaId,
    int? limite,
  }) async {
    if (disciplinaId != null && disciplinaId <= 0) {
      throw ArgumentError.value(
        disciplinaId,
        'disciplinaId',
        'O ID da disciplina deve ser maior que zero.',
      );
    }
    if (limite != null && limite <= 0) {
      throw ArgumentError.value(
        limite,
        'limite',
        'O limite deve ser maior que zero.',
      );
    }

    return _consultar(nome: nome, disciplinaId: disciplinaId, limite: limite);
  }

  Future<Professor?> buscarPorId(int professorId) async {
    if (professorId <= 0) {
      throw ArgumentError.value(
        professorId,
        'professorId',
        'O ID do professor deve ser maior que zero.',
      );
    }

    final result = await _consultar(professorId: professorId, limite: 1);
    return result.isEmpty ? null : result.single;
  }

  Future<List<Professor>> _consultar({
    String? nome,
    int? disciplinaId,
    int? professorId,
    int? limite,
  }) async {
    final database = await _databaseProvider();
    final conditions = <String>[
      'professor.ativo = 1',
      '''
        EXISTS (
          SELECT 1
          FROM professor_disciplina especialidade
          INNER JOIN disciplina disciplina_ativa
            ON disciplina_ativa.id = especialidade.disciplina_id
          WHERE especialidade.professor_id = professor.id
            AND disciplina_ativa.ativo = 1
        )
      ''',
    ];
    final arguments = <Object?>[];
    final normalizedName = nome?.trim();

    if (normalizedName != null && normalizedName.isNotEmpty) {
      conditions.add('''
        TRIM(pessoa.nome || ' ' || pessoa.sobrenome)
          LIKE ? COLLATE NOCASE
      ''');
      arguments.add('%$normalizedName%');
    }

    if (disciplinaId != null) {
      conditions.add('''
        EXISTS (
          SELECT 1
          FROM professor_disciplina filtro_disciplina
          WHERE filtro_disciplina.professor_id = professor.id
            AND filtro_disciplina.disciplina_id = ?
        )
      ''');
      arguments.add(disciplinaId);
    }

    if (professorId != null) {
      conditions.add('professor.id = ?');
      arguments.add(professorId);
    }

    final limitClause = limite == null ? '' : 'LIMIT ?';
    if (limite != null) {
      arguments.add(limite);
    }

    final rows = await database.rawQuery('''
        SELECT
          professor.id AS id,
          professor.bio,
          professor.diploma,
          professor.valor_hora_aula,
          professor.ativo,
          pessoa.id AS pessoa_id,
          pessoa.nome,
          pessoa.sobrenome,
          pessoa.data_nascimento,
          pessoa.genero,
          pessoa.cpf,
          pessoa.foto_perfil,
          pessoa.endereco_id,
          pessoa.email,
          pessoa.senha,
          COALESCE(AVG(avaliacao.nota), 0) AS media_avaliacoes,
          COUNT(avaliacao.id) AS total_avaliacoes
        FROM professor
        INNER JOIN pessoa
          ON pessoa.id = professor.pessoa_id
        LEFT JOIN avaliacao
          ON avaliacao.professor_id = professor.id
        WHERE ${conditions.join(' AND ')}
        GROUP BY professor.id, pessoa.id
        ORDER BY
          media_avaliacoes DESC,
          total_avaliacoes DESC,
          pessoa.nome COLLATE NOCASE ASC,
          pessoa.sobrenome COLLATE NOCASE ASC
        $limitClause
      ''', arguments);

    if (rows.isEmpty) {
      return const [];
    }

    final professorIds = rows.map((row) => row['id'] as int).toList();
    final disciplinesByProfessor = await _buscarEspecialidades(professorIds);

    return rows
        .map((row) {
          final id = row['id'] as int;
          return Professor.fromMap(
            row,
            pessoa: _mapPessoa(row),
            especialidades: disciplinesByProfessor[id] ?? const [],
          );
        })
        .toList(growable: false);
  }

  Future<Map<int, List<Disciplina>>> _buscarEspecialidades(
    List<int> professorIds,
  ) async {
    final database = await _databaseProvider();
    final placeholders = List.filled(professorIds.length, '?').join(', ');
    final rows = await database.rawQuery('''
        SELECT
          professor_disciplina.professor_id,
          disciplina.id,
          disciplina.nome,
          disciplina.descricao,
          disciplina.ativo
        FROM professor_disciplina
        INNER JOIN disciplina
          ON disciplina.id = professor_disciplina.disciplina_id
        WHERE professor_disciplina.professor_id IN ($placeholders)
          AND disciplina.ativo = 1
        ORDER BY disciplina.nome COLLATE NOCASE ASC
      ''', professorIds);

    final result = <int, List<Disciplina>>{};
    for (final row in rows) {
      final professorId = row['professor_id'] as int;
      result.putIfAbsent(professorId, () => []).add(Disciplina.fromMap(row));
    }

    return result;
  }

  Pessoa _mapPessoa(Map<String, Object?> row) {
    return Pessoa.fromMap({
      'id': row['pessoa_id'],
      'nome': row['nome'],
      'sobrenome': row['sobrenome'],
      'data_nascimento': row['data_nascimento'],
      'genero': row['genero'],
      'cpf': row['cpf'],
      'foto_perfil': row['foto_perfil'],
      'endereco_id': row['endereco_id'],
      'email': row['email'],
      'senha': row['senha'],
    });
  }
}
