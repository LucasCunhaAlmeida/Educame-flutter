import 'package:flutter/foundation.dart';

import '../../../core/session/session_manager.dart';
import '../../../data/models/aula.dart';
import '../../../data/models/pagamento.dart';
import '../../../data/repositories/aula_repository.dart';
import '../../../data/repositories/pagamento_repository.dart';

class HistoricoViewModel extends ChangeNotifier {
  final AulaRepository _aulaRepository;
  final PagamentoRepository _pagamentoRepository;

  HistoricoViewModel({
    required AulaRepository aulaRepository,
    required PagamentoRepository pagamentoRepository,
  })  : _aulaRepository = aulaRepository,
        _pagamentoRepository = pagamentoRepository;

  List<AulaDetalhada> _proximasAulas = const [];
  List<AulaDetalhada> _historico = const [];
  AulaDetalhada? _aulaSelecionada;
  Pagamento? _pagamentoSelecionado;
  int? _alunoId;

  bool _carregando = false;
  String? _erro;
  int _consultaAtual = 0;
  bool _disposed = false;

  List<AulaDetalhada> get proximasAulas => _proximasAulas;
  List<AulaDetalhada> get historico => _historico;
  AulaDetalhada? get aulaSelecionada => _aulaSelecionada;
  Pagamento? get pagamentoSelecionado => _pagamentoSelecionado;
  int? get alunoId => _alunoId;
  bool get carregando => _carregando;
  String? get erro => _erro;

  int get totalAulasConcluidas =>
      _historico.where((aula) => aula.aula.status.toLowerCase() == 'concluida').length;

  int get totalAulasCanceladas =>
      _historico.where((aula) => aula.aula.status.toLowerCase() == 'cancelada').length;

  bool get possuiHistorico => _historico.isNotEmpty;

  bool get semResultados =>
      !_carregando && _erro == null && _proximasAulas.isEmpty && _historico.isEmpty;

  Future<void> carregar() async {
    final pessoaId = SessionManager.usuarioAtual?.id;
    if (pessoaId == null) {
      _erro = 'Faça login novamente para ver seus agendamentos.';
      _notificar();
      return;
    }

    final alunoId = await _aulaRepository.buscarAlunoIdPorPessoaId(pessoaId);
    if (alunoId == null) {
      _erro = 'Não foi possível identificar o aluno logado.';
      _notificar();
      return;
    }

    await carregarHistorico(alunoId);
  }

  Future<void> carregarHistorico(int alunoId) async {
    final consulta = ++_consultaAtual;

    _carregando = true;
    _erro = null;
    _alunoId = alunoId;
    _notificar();

    try {
      final proximas = await _aulaRepository.listarProximasDetalhadas(alunoId);
      final historico = await _aulaRepository.listarHistoricoDetalhado(alunoId);

      if (!_consultaValida(consulta)) {
        return;
      }

      _proximasAulas = List.unmodifiable(proximas);
      _historico = List.unmodifiable(historico);
      _aulaSelecionada = null;
      _pagamentoSelecionado = null;
    } catch (_) {
      if (!_consultaValida(consulta)) {
        return;
      }

      _proximasAulas = const [];
      _historico = const [];
      _aulaSelecionada = null;
      _pagamentoSelecionado = null;
      _erro = 'Não foi possível carregar o histórico.';
    } finally {
      if (_consultaValida(consulta)) {
        _carregando = false;
        _notificar();
      }
    }
  }

  Future<void> selecionarAula(int aulaId) async {
    final consulta = ++_consultaAtual;

    _carregando = true;
    _erro = null;
    _notificar();

    try {
      final aula = await _aulaRepository.buscarDetalhadaPorId(aulaId);
      final pagamento = await _pagamentoRepository.buscarPorAulaId(aulaId);

      if (!_consultaValida(consulta)) {
        return;
      }

      if (aula == null) {
        throw StateError('Aula não encontrada.');
      }

      _aulaSelecionada = aula;
      _pagamentoSelecionado = pagamento;
    } catch (_) {
      if (!_consultaValida(consulta)) {
        return;
      }

      _aulaSelecionada = null;
      _pagamentoSelecionado = null;
      _erro = 'Não foi possível carregar os detalhes da aula.';
    } finally {
      if (_consultaValida(consulta)) {
        _carregando = false;
        _notificar();
      }
    }
  }

  Future<void> cancelarAula(int aulaId) async {
    final consulta = ++_consultaAtual;

    _carregando = true;
    _erro = null;
    _notificar();

    try {
      await _aulaRepository.cancelar(aulaId);
      await _pagamentoRepository.cancelarPorAula(aulaId);

      final alunoId = _alunoId ?? await _resolverAlunoIdAtual();
      if (alunoId != null) {
        final proximas = await _aulaRepository.listarProximasDetalhadas(alunoId);
        final historico = await _aulaRepository.listarHistoricoDetalhado(alunoId);

        if (!_consultaValida(consulta)) {
          return;
        }

        _proximasAulas = List.unmodifiable(proximas);
        _historico = List.unmodifiable(historico);
        _alunoId = alunoId;
      }

      if (!_consultaValida(consulta)) {
        return;
      }

      await selecionarAula(aulaId);
      return;
    } catch (_) {
      if (_consultaValida(consulta)) {
        _erro = 'Não foi possível cancelar o agendamento.';
      }
    } finally {
      if (_consultaValida(consulta)) {
        _carregando = false;
        _notificar();
      }
    }
  }

  Future<void> atualizarHistorico(int alunoId) async {
    await carregarHistorico(alunoId);
  }

  Future<void> tentarNovamente() async {
    if (_alunoId != null) {
      await carregarHistorico(_alunoId!);
      return;
    }

    await carregar();
  }

  Future<int?> _resolverAlunoIdAtual() async {
    final pessoaId = SessionManager.usuarioAtual?.id;
    if (pessoaId == null) {
      return null;
    }

    return _aulaRepository.buscarAlunoIdPorPessoaId(pessoaId);
  }

  bool _consultaValida(int consulta) {
    return !_disposed && consulta == _consultaAtual;
  }

  void _notificar() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _consultaAtual++;
    super.dispose();
  }
}
