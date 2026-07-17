import '../../../data/repositories/auth_repository.dart';

class PerfilViewModel {
  final AuthRepository _authRepository;

  PerfilViewModel({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Future<void> logout() async {
    await _authRepository.logout();
  }
}