import '../../../data/models/pessoa.dart';
import '../../../data/repositories/auth_repository.dart';

class CadastroViewModel {
  final AuthRepository _authRepository;

  CadastroViewModel({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Future<void> cadastrar({
    required String nome,
    required String sobrenome,
    required DateTime dataNascimento,
    required String email,
    required String senha,
  }) async {
    _validarNome(nome);
    _validarSobrenome(sobrenome);
    _validarEmail(email);
    _validarSenha(senha);

    final pessoa = Pessoa(
      nome: nome.trim(),
      sobrenome: sobrenome.trim(),
      dataNascimento: dataNascimento,
      email: email.trim().toLowerCase(),
      senha: senha,
    );

    await _authRepository.cadastrar(pessoa);
  }

  void _validarNome(String nome) {
    if (nome.trim().isEmpty) {
      throw Exception('O nome é obrigatório.');
    }
  }

  void _validarSobrenome(String sobrenome) {
    if (sobrenome.trim().isEmpty) {
      throw Exception('O sobrenome é obrigatório.');
    }
  }

  void _validarEmail(String email) {
    final emailNormalizado = email.trim().toLowerCase();

    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(emailNormalizado)) {
      throw Exception(
        'Informe um endereço de e-mail válido.',
      );
    }
  }

  void _validarSenha(String senha) {
    if (senha.length < 6) {
      throw Exception(
        'A senha deve ter pelo menos 6 caracteres.',
      );
    }
  }
}