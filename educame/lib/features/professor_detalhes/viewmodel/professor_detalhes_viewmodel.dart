import 'package:flutter/foundation.dart';

import '../../../data/models/avaliacao.dart';
import '../../../data/models/disponibilidade.dart';
import '../../../data/models/professor.dart';
import '../../../data/repositories/avaliacao_repository.dart';
import '../../../data/repositories/disponibilidade_repository.dart';
import '../../../data/repositories/professor_repository.dart';

class ProfessorDetalhesViewModel extends ChangeNotifier {
  final ProfessorRepository _professorRepository;
  final AvaliacaoRepository _avaliacaoRepository;
  final DisponibilidadeRepository _disponibilidadeRepository;

  ProfessorDetalhesViewModel({
    required ProfessorRepository professorRepository,
    required AvaliacaoRepository avaliacaoRepository,
    required DisponibilidadeRepository disponibilidadeRepository,
  }) : _professorRepository = professorRepository,
       _avaliacaoRepository = avaliacaoRepository,
       _disponibilidadeRepository = disponibilidadeRepository;

  Professor? _professor;
  List<Avaliacao> _avaliacoes = const [];
  List<Disponibilidade> _disponibilidades = const [];
  int? _professorId;
  bool _carregando = false;
  String? _erro;
  int _consultaAtual = 0;
  bool _disposed = false;

  Professor? get professor => _professor;
  List<Avaliacao> get avaliacoes => _avaliacoes;
  List<Disponibilidade> get disponibilidades => _disponibilidades;
  bool get carregando => _carregando;
  String? get erro => _erro;
  bool get encontrado => _professor != null;
  bool get semAvaliacoes => !_carregando && _avaliacoes.isEmpty;
  bool get semDisponibilidade => !_carregando && _disponibilidades.isEmpty;

  Map<DateTime, List<Disponibilidade>> get disponibilidadesPorDia {
    final result = <DateTime, List<Disponibilidade>>{};
    for (final disponibilidade in _disponibilidades) {
      final inicio = disponibilidade.inicio;
      final day = DateTime(inicio.year, inicio.month, inicio.day);
      result.putIfAbsent(day, () => []).add(disponibilidade);
    }

    return Map<DateTime, List<Disponibilidade>>.unmodifiable(
      result.map(
        (day, items) =>
            MapEntry(day, List<Disponibilidade>.unmodifiable(items)),
      ),
    );
  }

  Future<void> carregar(int professorId) async {
    final consulta = ++_consultaAtual;
    _professorId = professorId;
    _carregando = true;
    _erro = null;
    _notificar();

    try {
      final result = await Future.wait<Object?>([
        _professorRepository.buscarPorId(professorId),
        _avaliacaoRepository.listarPorProfessor(professorId),
        _disponibilidadeRepository.listarPorProfessor(professorId),
      ]);
      final professor = result[0] as Professor?;
      final avaliacoes = result[1] as List<Avaliacao>;
      final disponibilidades = result[2] as List<Disponibilidade>;

      if (!_consultaValida(consulta)) {
        return;
      }

      if (professor == null) {
        _professor = null;
        _avaliacoes = const [];
        _disponibilidades = const [];
        _erro = 'Professor não encontrado.';
        return;
      }

      _professor = professor;
      _avaliacoes = List.unmodifiable(avaliacoes);
      _disponibilidades = List.unmodifiable(disponibilidades);
    } catch (_) {
      if (!_consultaValida(consulta)) {
        return;
      }
      _professor = null;
      _avaliacoes = const [];
      _disponibilidades = const [];
      _erro = 'Não foi possível carregar os detalhes do professor.';
    } finally {
      if (_consultaValida(consulta)) {
        _carregando = false;
        _notificar();
      }
    }
  }

  Future<void> tentarNovamente() async {
    final professorId = _professorId;
    if (professorId != null) {
      await carregar(professorId);
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
    super.dispose();
  }
}
