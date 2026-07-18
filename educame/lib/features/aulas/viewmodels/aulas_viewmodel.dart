import 'package:flutter/foundation.dart';

import '../../../data/models/aula.dart';
import '../../../data/repositories/aula_repository.dart';

class AulasViewModel extends ChangeNotifier {
  final AulaRepository _aulaRepository;

  AulasViewModel({required AulaRepository aulaRepository})
    : _aulaRepository = aulaRepository;

  List<Aula> _proximasAulas = const [];
  Aula? _aulaSelecionada;

  bool _carregando = false;
  String? _erro;

  int _consultaAtual = 0;
  bool _disposed = false;

  List<Aula> get proximasAulas => _proximasAulas;

  Aula? get aulaSelecionada => _aulaSelecionada;

  bool get carregando => _carregando;

  String? get erro => _erro;

  bool get possuiAgendamentos => _proximasAulas.isNotEmpty;

  bool get semResultados =>
      !_carregando && _erro == null && _proximasAulas.isEmpty;

  Future<void> carregarProximasAulas(int alunoId) async {
    final consulta = ++_consultaAtual;

    _carregando = true;
    _erro = null;
    _notificar();

    try {
      final aulas = await _aulaRepository.listarProximas(alunoId);

      if (!_consultaValida(consulta)) {
        return;
      }

      _proximasAulas = List.unmodifiable(aulas);
    } catch (_) {
      if (!_consultaValida(consulta)) {
        return;
      }

      _proximasAulas = const [];
      _erro = 'Não foi possível carregar os agendamentos.';
    } finally {
      if (_consultaValida(consulta)) {
        _carregando = false;
        _notificar();
      }
    }
  }

  Future<void> buscarAula(int aulaId) async {
    final consulta = ++_consultaAtual;

    _carregando = true;
    _erro = null;
    _notificar();

    try {
      final aula = await _aulaRepository.buscarPorId(aulaId);

      if (!_consultaValida(consulta)) {
        return;
      }

      _aulaSelecionada = aula;
    } catch (_) {
      if (!_consultaValida(consulta)) {
        return;
      }

      _erro = 'Não foi possível carregar os detalhes da aula.';
    } finally {
      if (_consultaValida(consulta)) {
        _carregando = false;
        _notificar();
      }
    }
  }

  Future<void> cancelarAula(int aulaId, int alunoId) async {
    final consulta = ++_consultaAtual;

    _carregando = true;
    _erro = null;
    _notificar();

    try {
      await _aulaRepository.cancelar(aulaId);

      if (!_consultaValida(consulta)) {
        return;
      }

      final aulas = await _aulaRepository.listarProximas(alunoId);

      if (!_consultaValida(consulta)) {
        return;
      }

      _proximasAulas = List.unmodifiable(aulas);

      if (_aulaSelecionada?.id == aulaId) {
        _aulaSelecionada = await _aulaRepository.buscarPorId(aulaId);
      }
    } catch (_) {
      if (!_consultaValida(consulta)) {
        return;
      }

      _erro = 'Não foi possível cancelar a aula.';
    } finally {
      if (_consultaValida(consulta)) {
        _carregando = false;
        _notificar();
      }
    }
  }

  Future<void> concluirAula(int aulaId, int alunoId) async {
    final consulta = ++_consultaAtual;

    _carregando = true;
    _erro = null;
    _notificar();

    try {
      await _aulaRepository.concluir(aulaId);

      if (!_consultaValida(consulta)) {
        return;
      }

      _proximasAulas = List.unmodifiable(
        await _aulaRepository.listarProximas(alunoId),
      );

      if (_aulaSelecionada?.id == aulaId) {
        _aulaSelecionada = await _aulaRepository.buscarPorId(aulaId);
      }
    } catch (_) {
      if (!_consultaValida(consulta)) {
        return;
      }

      _erro = 'Não foi possível concluir a aula.';
    } finally {
      if (_consultaValida(consulta)) {
        _carregando = false;
        _notificar();
      }
    }
  }

  Future<void> atualizarAula(Aula aula, int alunoId) async {
    final consulta = ++_consultaAtual;

    _carregando = true;
    _erro = null;
    _notificar();

    try {
      await _aulaRepository.atualizar(aula);

      if (!_consultaValida(consulta)) {
        return;
      }

      _proximasAulas = List.unmodifiable(
        await _aulaRepository.listarProximas(alunoId),
      );

      _aulaSelecionada = await _aulaRepository.buscarPorId(aula.id!);
    } catch (_) {
      if (!_consultaValida(consulta)) {
        return;
      }

      _erro = 'Não foi possível atualizar a aula.';
    } finally {
      if (_consultaValida(consulta)) {
        _carregando = false;
        _notificar();
      }
    }
  }

  Future<void> atualizarLista(int alunoId) async {
    await carregarProximasAulas(alunoId);
  }

  void limparSelecao() {
    _aulaSelecionada = null;
    _notificar();
  }

  Future<void> tentarNovamente(int alunoId) async {
    await carregarProximasAulas(alunoId);
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
