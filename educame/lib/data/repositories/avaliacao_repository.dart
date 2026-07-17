import '../models/avaliacao.dart';
import 'database_provider.dart';

class AvaliacaoRepository {
  final DatabaseProvider _databaseProvider;

  AvaliacaoRepository({DatabaseProvider? databaseProvider})
    : _databaseProvider = databaseProvider ?? appDatabaseProvider;

  Future<List<Avaliacao>> listarPorProfessor(int professorId) async {
    _validarProfessorId(professorId);

    final database = await _databaseProvider();
    final result = await database.rawQuery(
      '''
        SELECT
          avaliacao.*,
          TRIM(pessoa.nome || ' ' || pessoa.sobrenome) AS autor_nome,
          pessoa.foto_perfil AS autor_foto_perfil
        FROM avaliacao
        INNER JOIN aluno
          ON aluno.id = avaliacao.aluno_id
        INNER JOIN pessoa
          ON pessoa.id = aluno.pessoa_id
        WHERE avaliacao.professor_id = ?
        ORDER BY avaliacao.data_avaliacao DESC, avaliacao.id DESC
      ''',
      [professorId],
    );

    return result.map(Avaliacao.fromMap).toList(growable: false);
  }

  Future<({double media, int total})> obterResumo(int professorId) async {
    _validarProfessorId(professorId);

    final database = await _databaseProvider();
    final result = await database.rawQuery(
      '''
        SELECT
          COALESCE(AVG(nota), 0) AS media,
          COUNT(*) AS total
        FROM avaliacao
        WHERE professor_id = ?
      ''',
      [professorId],
    );
    final row = result.single;

    return (
      media: (row['media'] as num).toDouble(),
      total: (row['total'] as num).toInt(),
    );
  }

  void _validarProfessorId(int professorId) {
    if (professorId <= 0) {
      throw ArgumentError.value(
        professorId,
        'professorId',
        'O ID do professor deve ser maior que zero.',
      );
    }
  }
}
