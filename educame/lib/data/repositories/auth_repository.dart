import '../app_database.dart';
import '../models/pessoa.dart';

class AuthRepository {
  Future<void> cadastrar(Pessoa pessoa) async {
    final database = await AppDatabase.database;

    await database.transaction(
      (transaction) async {
        final pessoaId = await transaction.insert(
          'pessoa',
          pessoa.toMap(),
        );

        await transaction.insert(
          'aluno',
          {
            'pessoa_id': pessoaId,
          },
        );

        await transaction.insert(
          'professor',
          {
            'pessoa_id': pessoaId,
            'valor_hora_aula': 0,
            'ativo': 1,
          },
        );
      },
    );
  }
}