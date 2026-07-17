import '../../data/models/pessoa.dart';

class SessionManager {
  static Pessoa? usuarioAtual;

  static bool get estaAutenticado {
    return usuarioAtual != null;
  }

  static void iniciarSessao(Pessoa pessoa) {
    usuarioAtual = pessoa;
  }

  static void encerrarSessao() {
    usuarioAtual = null;
  }
}