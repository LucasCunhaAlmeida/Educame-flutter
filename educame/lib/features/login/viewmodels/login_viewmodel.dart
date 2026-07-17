import '../../../data/models/pessoa.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../core/session/session_manager.dart';

class LoginViewModel {
  final AuthRepository _authRepository;

  Pessoa? usuarioAutenticado;

  LoginViewModel({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Future<void> login({
    required String email,
    required String senha,
  }) async {
    if (email.trim().isEmpty) {
      throw Exception('Informe o e-mail.');
    }

    if (senha.isEmpty) {
      throw Exception('Informe a senha.');
    }

    final pessoa = await _authRepository.login(
      email: email.trim(),
      senha: senha,
    );

    if (pessoa == null) {
      throw Exception(
        'E-mail ou senha inválidos.',
      );
    }

    SessionManager.iniciarSessao(pessoa);
  }
}