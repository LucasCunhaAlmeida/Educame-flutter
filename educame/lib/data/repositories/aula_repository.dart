import 'package:sqflite/sqflite.dart';

import '../models/aula.dart';
import 'database_provider.dart';

class AulaDetalhada {
  final Aula aula;
  final String disciplina;
  final String professor;

  const AulaDetalhada({
    required this.aula,
    required this.disciplina,
    required this.professor,
  });

  factory AulaDetalhada.fromMap(Map<String, Object?> map) {
    return AulaDetalhada(
      aula: Aula.fromMap(map),
      disciplina: map['disciplina_nome'] as String? ?? 'Disciplina',
      professor: map['professor_nome'] as String? ?? 'Professor',
    );
  }
}

class AulaRepository {
  final DatabaseProvider _databaseProvider;

  AulaRepository({DatabaseProvider databaseProvider = appDatabaseProvider})
    : _databaseProvider = databaseProvider;

  Future<int?> buscarAlunoIdPorPessoaId(int pessoaId) async {
    final database = await _databaseProvider();
    final rows = await database.query(
      'aluno',
      columns: ['id'],
      where: 'pessoa_id = ?',
      whereArgs: [pessoaId],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return rows.first['id'] as int;
  }

  Future<List<AulaDetalhada>> listarProximasDetalhadas(
    int alunoId, {
    int? limite,
    DateTime? agora,
  }) async {
    final database = await _databaseProvider();
    final rows = await database.rawQuery('''
      SELECT
        aula.*,
        disciplina.nome AS disciplina_nome,
        pessoa.nome || ' ' || pessoa.sobrenome AS professor_nome
      FROM aula
      INNER JOIN disciplina
        ON disciplina.id = aula.disciplina_id
      INNER JOIN professor
        ON professor.id = aula.professor_id
      INNER JOIN pessoa
        ON pessoa.id = professor.pessoa_id
      WHERE aula.aluno_id = ?
        AND aula.inicio > ?
        AND aula.status NOT IN ('cancelada', 'concluida')
      ORDER BY aula.inicio ASC
      ${limite == null ? '' : 'LIMIT ?'}
    ''', [
      alunoId,
      (agora ?? DateTime.now()).toIso8601String(),
      if (limite != null) limite,
    ]);

    return rows.map(AulaDetalhada.fromMap).toList(growable: false);
  }

  Future<List<AulaDetalhada>> listarHistoricoDetalhado(
    int alunoId, {
    DateTime? agora,
  }) async {
    final database = await _databaseProvider();
    final rows = await database.rawQuery('''
      SELECT
        aula.*,
        disciplina.nome AS disciplina_nome,
        pessoa.nome || ' ' || pessoa.sobrenome AS professor_nome
      FROM aula
      INNER JOIN disciplina
        ON disciplina.id = aula.disciplina_id
      INNER JOIN professor
        ON professor.id = aula.professor_id
      INNER JOIN pessoa
        ON pessoa.id = professor.pessoa_id
      WHERE aula.aluno_id = ?
        AND (
          aula.fim <= ?
          OR aula.status IN ('concluida', 'cancelada')
        )
      ORDER BY aula.inicio DESC
    ''', [
      alunoId,
      (agora ?? DateTime.now()).toIso8601String(),
    ]);

    return rows.map(AulaDetalhada.fromMap).toList(growable: false);
  }

  Future<List<Aula>> listarProximas(int alunoId) async {
    final aulas = await listarProximasDetalhadas(alunoId);
    return aulas.map((item) => item.aula).toList(growable: false);
  }

  Future<Aula?> buscarPorId(int aulaId) async {
    final database = await _databaseProvider();
    final rows = await database.query(
      'aula',
      where: 'id = ?',
      whereArgs: [aulaId],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return Aula.fromMap(rows.first);
  }

  Future<void> atualizar(Aula aula) async {
    final id = aula.id;
    if (id == null) {
      throw ArgumentError.value(id, 'aula.id', 'A aula precisa ter ID.');
    }

    final database = await _databaseProvider();
    await database.update(
      'aula',
      aula.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> cancelar(int aulaId) async {
    await _alterarStatus(aulaId, 'cancelada');
  }

  Future<void> concluir(int aulaId) async {
    await _alterarStatus(aulaId, 'concluida');
  }

  Future<void> _alterarStatus(int aulaId, String status) async {
    final database = await _databaseProvider();
    await database.update(
      'aula',
      {'status': status},
      where: 'id = ?',
      whereArgs: [aulaId],
    );
  }
}
