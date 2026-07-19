import 'package:flutter/foundation.dart';

import '../../../core/session/session_manager.dart';
import '../../../data/models/professor.dart';
import '../../../data/repositories/aula_repository.dart';
import '../../../data/repositories/professor_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final ProfessorRepository _professorRepository;
  final AulaRepository _aulaRepository;

  HomeViewModel({
    required ProfessorRepository professorRepository,
    required AulaRepository aulaRepository,
  }) : _professorRepository = professorRepository,
       _aulaRepository = aulaRepository;

  List<Professor> _professoresDestaque = const [];
  List<AulaDetalhada> _proximasAulas = const [];
  List<AulaDetalhada> _historicoRecente = const [];
  int? _alunoId;
  bool _carregando = false;
  String? _erro;
  bool _disposed = false;

  List<Professor> get professoresDestaque => _professoresDestaque;
  List<AulaDetalhada> get proximasAulas => _proximasAulas;
  List<AulaDetalhada> get historicoRecente => _historicoRecente;
  int? get alunoId => _alunoId;
  bool get carregando => _carregando;
  String? get erro => _erro;

  String get nomeUsuario {
    final nome = SessionManager.usuarioAtual?.nomeFormatado;
    return nome == null || nome.isEmpty ? 'Aluno' : nome;
  }

  String? get fotoPerfilUsuario {
    final fotoPerfil = SessionManager.usuarioAtual?.fotoPerfil?.trim();
    return fotoPerfil == null || fotoPerfil.isEmpty ? null : fotoPerfil;
  }

  bool get semDestaques =>
      !_carregando && _erro == null && _professoresDestaque.isEmpty;

  bool get semProximasAulas =>
      !_carregando && _erro == null && _proximasAulas.isEmpty;

  bool get semHistoricoRecente =>
      !_carregando && _erro == null && _historicoRecente.isEmpty;

  Future<void> carregar() async {
    if (_carregando) {
      return;
    }

    _carregando = true;
    _erro = null;
    _notificar();

    try {
      final pessoaId = SessionManager.usuarioAtual?.id;
      final alunoId = pessoaId == null
          ? null
          : await _aulaRepository.buscarAlunoIdPorPessoaId(pessoaId);
      final professores = await _professorRepository.listar(limite: 4);
      final proximasAulas = alunoId == null
          ? const <AulaDetalhada>[]
          : await _aulaRepository.listarProximasDetalhadas(alunoId, limite: 3);
      final historicoRecente = alunoId == null
          ? const <AulaDetalhada>[]
          : await _aulaRepository.listarHistoricoDetalhado(alunoId, limite: 2);

      if (_disposed) {
        return;
      }

      _alunoId = alunoId;
      _professoresDestaque = List.unmodifiable(professores);
      _proximasAulas = List.unmodifiable(proximasAulas);
      _historicoRecente = List.unmodifiable(historicoRecente);
    } catch (_) {
      if (_disposed) {
        return;
      }

      _professoresDestaque = const [];
      _proximasAulas = const [];
      _historicoRecente = const [];
      _erro = 'Não foi possível carregar os dados da home.';
    } finally {
      if (!_disposed) {
        _carregando = false;
        _notificar();
      }
    }
  }

  void _notificar() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
