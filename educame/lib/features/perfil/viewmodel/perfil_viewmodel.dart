import 'package:flutter/foundation.dart';

import '../../../core/session/session_manager.dart';

class PerfilViewModel extends ChangeNotifier {
  String get nomeUsuario {
    final nome = SessionManager.usuarioAtual?.nomeCompletoFormatado;
    return nome == null || nome.isEmpty ? 'Aluno' : nome;
  }

  String get emailUsuario {
    final email = SessionManager.usuarioAtual?.email.trim();
    return email == null || email.isEmpty ? 'E-mail não informado' : email;
  }
}
