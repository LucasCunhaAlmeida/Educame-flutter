import '../../core/security/password_hasher.dart';
import '../app_database.dart';
import '../models/pessoa.dart';
import '../../core/session/session_manager.dart';

class AuthRepository {
  Future<void> cadastrar(Pessoa pessoa) async {
    final database = await AppDatabase.database;

    final senhaHash = PasswordHasher.hash(pessoa.senha);

    final pessoaComSenhaHash = Pessoa(
      nome: pessoa.nome,
      sobrenome: pessoa.sobrenome,
      dataNascimento: pessoa.dataNascimento,
      genero: pessoa.genero,
      cpf: pessoa.cpf,
      fotoPerfil: pessoa.fotoPerfil,
      enderecoId: pessoa.enderecoId,
      email: pessoa.email,
      senha: senhaHash,
    );

    await database.transaction((transaction) async {
      final pessoaId = await transaction.insert(
        'pessoa',
        pessoaComSenhaHash.toMap(),
      );

      await transaction.insert('aluno', {'pessoa_id': pessoaId});

      await transaction.insert('professor', {
        'pessoa_id': pessoaId,
        'valor_hora_aula': 0,
        'ativo': 1,
      });
    });
  }

  Future<Pessoa?> login({required String email, required String senha}) async {
    final database = await AppDatabase.database;

    final resultado = await database.query(
      'pessoa',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (resultado.isEmpty) {
      return null;
    }

    final pessoa = Pessoa.fromMap(resultado.first);

    final senhaValida = PasswordHasher.verify(
      password: senha,
      hashedPassword: pessoa.senha,
    );

    if (!senhaValida) {
      return null;
    }

    return pessoa;
  }

  Future<void> logout() async {
    SessionManager.encerrarSessao();
  }
}
