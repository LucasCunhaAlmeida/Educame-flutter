import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/models/disciplina.dart';
import '../../data/models/professor.dart';
import '../../data/repositories/disciplina_repository.dart';
import '../../data/repositories/professor_repository.dart';

class ProfessorViewModel extends ChangeNotifier {
  final ProfessorRepository _professorRepository;
  final DisciplinaRepository _disciplinaRepository;

  ProfessorViewModel({
    required ProfessorRepository professorRepository,
    required DisciplinaRepository disciplinaRepository,
  }) : _professorRepository = professorRepository,
       _disciplinaRepository = disciplinaRepository;

  List<Professor> _professores = const [];
  List<Disciplina> _disciplinas = const [];
  Disciplina? _disciplinaSelecionada;
  String _termoBusca = '';
  bool _carregando = false;
  String? _erro;
  Timer? _buscaDebounce;
  int _consultaAtual = 0;
  bool _disposed = false;

  List<Professor> get professores => _professores;
  List<Disciplina> get disciplinas => _disciplinas;
  Disciplina? get disciplinaSelecionada => _disciplinaSelecionada;
  String get termoBusca => _termoBusca;
  bool get carregando => _carregando;
  String? get erro => _erro;
  bool get possuiFiltros =>
      _termoBusca.isNotEmpty || _disciplinaSelecionada != null;
  bool get semResultados =>
      !_carregando && _erro == null && _professores.isEmpty;

  Future<void> inicializar() async {
    if (_carregando) {
      return;
    }

    final consulta = ++_consultaAtual;
    _carregando = true;
    _erro = null;
    _notificar();

    try {
      final result = await Future.wait<Object>([
        _disciplinaRepository.listarAtivas(),
        _professorRepository.listar(),
      ]);
      final disciplinas = result[0] as List<Disciplina>;
      final professores = result[1] as List<Professor>;

      if (!_consultaValida(consulta)) {
        return;
      }

      _disciplinas = List.unmodifiable(disciplinas);
      _professores = List.unmodifiable(professores);
    } catch (_) {
      if (!_consultaValida(consulta)) {
        return;
      }
      _professores = const [];
      _erro = 'Não foi possível carregar os professores.';
    } finally {
      if (_consultaValida(consulta)) {
        _carregando = false;
        _notificar();
      }
    }
  }

  void atualizarBusca(String termo) {
    _termoBusca = termo.trim();
    _buscaDebounce?.cancel();
    _notificar();

    _buscaDebounce = Timer(const Duration(milliseconds: 350), () {
      unawaited(_consultarProfessores());
    });
  }

  Future<void> buscar(String termo) async {
    _buscaDebounce?.cancel();
    _termoBusca = termo.trim();
    await _consultarProfessores();
  }

  Future<void> selecionarDisciplina(Disciplina? disciplina) async {
    if (_disciplinaSelecionada?.id == disciplina?.id) {
      return;
    }

    _buscaDebounce?.cancel();
    _disciplinaSelecionada = disciplina;
    await _consultarProfessores();
  }

  Future<void> limparFiltros() async {
    _buscaDebounce?.cancel();
    _termoBusca = '';
    _disciplinaSelecionada = null;
    await _consultarProfessores();
  }

  Future<void> tentarNovamente() async {
    if (_disciplinas.isEmpty) {
      await inicializar();
      return;
    }
    await _consultarProfessores();
  }

  Future<void> _consultarProfessores() async {
    final consulta = ++_consultaAtual;
    _carregando = true;
    _erro = null;
    _notificar();

    try {
      final professores = await _professorRepository.listar(
        nome: _termoBusca.isEmpty ? null : _termoBusca,
        disciplinaId: _disciplinaSelecionada?.id,
      );

      if (!_consultaValida(consulta)) {
        return;
      }
      _professores = List.unmodifiable(professores);
    } catch (_) {
      if (!_consultaValida(consulta)) {
        return;
      }
      _professores = const [];
      _erro = 'Não foi possível buscar os professores.';
    } finally {
      if (_consultaValida(consulta)) {
        _carregando = false;
        _notificar();
      }
    }
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
    _buscaDebounce?.cancel();
    super.dispose();
  }
}
