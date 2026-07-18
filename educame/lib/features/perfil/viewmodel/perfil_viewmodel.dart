import 'package:flutter/foundation.dart';

import '../../../core/session/session_manager.dart';
import '../../../data/models/endereco.dart';
import '../../../data/models/pessoa.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/perfil_repository.dart';

class PerfilViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final PerfilRepository _perfilRepository;

  Pessoa? _usuario;
  Endereco? _endereco;

  bool _carregando = false;

  PerfilViewModel({
    required AuthRepository authRepository,
    required PerfilRepository perfilRepository,
  })  : _authRepository = authRepository,
        _perfilRepository = perfilRepository;

  Pessoa? get usuario => _usuario;

  Endereco? get endereco => _endereco;

  bool get carregando => _carregando;

  String get nomeUsuario {
    final nome = _usuario?.nomeCompletoFormatado;

    return nome == null || nome.isEmpty ? 'Aluno' : nome;
  }

  String get emailUsuario {
    final email = _usuario?.email.trim();

    return email == null || email.isEmpty ? 'E-mail nao informado' : email;
  }

  Future<void> carregarDadosPessoais() async {
    final usuarioSessao = SessionManager.usuarioAtual;

    if (usuarioSessao == null || usuarioSessao.id == null) {
      return;
    }

    _carregando = true;
    notifyListeners();

    try {
      final pessoa = await _perfilRepository.buscarPessoaPorId(
        usuarioSessao.id!,
      );

      _usuario = pessoa;
      if (pessoa != null) {
        SessionManager.iniciarSessao(pessoa);
      }

      if (pessoa != null && pessoa.enderecoId != null) {
        _endereco = await _perfilRepository.buscarEnderecoPorId(
          pessoa.enderecoId!,
        );
      } else {
        _endereco = null;
      }
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> salvarEndereco({
    required String rua,
    required String numero,
    String? complemento,
    required String bairro,
    required String cidade,
    required String estado,
    required String cep,
    required String pais,
  }) async {
    final usuario = _usuario ?? SessionManager.usuarioAtual;

    if (usuario == null) {
      throw Exception('Usuario nao autenticado.');
    }

    if (usuario.id == null) {
      throw Exception('Usuario invalido.');
    }

    if (usuario.enderecoId == null) {
      final enderecoId = await _perfilRepository.criarEndereco(
        rua: rua,
        numero: numero,
        complemento: complemento,
        bairro: bairro,
        cidade: cidade,
        estado: estado,
        cep: cep,
        pais: pais,
      );

      await _perfilRepository.associarEnderecoPessoa(
        pessoaId: usuario.id!,
        enderecoId: enderecoId,
      );
    } else {
      await _perfilRepository.atualizarEndereco(
        enderecoId: usuario.enderecoId!,
        rua: rua,
        numero: numero,
        complemento: complemento,
        bairro: bairro,
        cidade: cidade,
        estado: estado,
        cep: cep,
        pais: pais,
      );
    }

    await carregarDadosPessoais();
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }
}
