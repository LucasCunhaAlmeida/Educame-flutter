import '../models/disponibilidade.dart';
import 'database_provider.dart';

class DisponibilidadeRepository {
  final DatabaseProvider _databaseProvider;

  DisponibilidadeRepository({DatabaseProvider? databaseProvider})
    : _databaseProvider = databaseProvider ?? appDatabaseProvider;

  Future<List<Disponibilidade>> listarPorProfessor(int professorId) async {
    _validarProfessorId(professorId);

    final database = await _databaseProvider();
    final result = await database.query(
      'disponibilidade',
      where: 'professor_id = ? AND status = ?',
      whereArgs: [professorId, 'disponivel'],
      orderBy: 'inicio ASC',
    );

    return result.map(Disponibilidade.fromMap).toList(growable: false);
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
