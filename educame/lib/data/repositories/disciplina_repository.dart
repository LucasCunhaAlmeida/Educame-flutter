import '../models/disciplina.dart';
import 'database_provider.dart';

class DisciplinaRepository {
  final DatabaseProvider _databaseProvider;

  DisciplinaRepository({DatabaseProvider? databaseProvider})
    : _databaseProvider = databaseProvider ?? appDatabaseProvider;

  Future<List<Disciplina>> listarAtivas() async {
    final database = await _databaseProvider();
    final result = await database.query(
      'disciplina',
      where: 'ativo = ?',
      whereArgs: const [1],
      orderBy: 'nome COLLATE NOCASE ASC',
    );

    return result.map(Disciplina.fromMap).toList(growable: false);
  }
}
