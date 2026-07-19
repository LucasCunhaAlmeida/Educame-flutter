import 'package:flutter/foundation.dart';

import '../../../core/session/session_manager.dart';
import '../../../data/models/aula.dart';
import '../../../data/models/disciplina.dart';
import '../../../data/models/disponibilidade.dart';
import '../../../data/models/professor.dart';
import '../../../data/repositories/aula_repository.dart';
import '../../../data/repositories/disponibilidade_repository.dart';
import '../../../data/repositories/professor_repository.dart';

class AgendamentoViewModel extends ChangeNotifier {
  final ProfessorRepository _professorRepository;
  final DisponibilidadeRepository _disponibilidadeRepository;
  final AulaRepository _aulaRepository;

  AgendamentoViewModel({
    required ProfessorRepository professorRepository,
    required DisponibilidadeRepository disponibilidadeRepository,
    required AulaRepository aulaRepository,
  })  : _professorRepository = professorRepository,
        _disponibilidadeRepository = disponibilidadeRepository,
        _aulaRepository = aulaRepository;

  Professor? _professor;
  Disponibilidade? _disponibilidade;
  Disciplina? _disciplinaSelecionada;
  Aula? _aulaConfirmada;

  bool _carregando = false;
  bool _salvando = false;
  String? _erro;
  int _consultaAtual = 0;
  bool _disposed = false;

  Professor? get professor => _professor;
  Disponibilidade? get disponibilidade => _disponibilidade;
  Disciplina? get disciplinaSelecionada => _disciplinaSelecionada;
  Aula? get aulaConfirmada => _aulaConfirmada;
  bool get carregando => _carregando;
  bool get salvando => _salvando;
  String? get erro => _erro;
  bool get podeConfirmar =>
      _professor != null &&
      _disponibilidade != null &&
      _disciplinaSelecionada != null &&
      !_carregando &&
      !_salvando;

  Future<void> carregar({
    required int professorId,
    required int disponibilidadeId,
  }) async {
    final consulta = ++_consultaAtual;

    _carregando = true;
    _salvando = false;
    _erro = null;
    _aulaConfirmada = null;
    _professor = null;
    _disponibilidade = null;
    _disciplinaSelecionada = null;
    _notificar();

    try {
      final professor = await _professorRepository.buscarPorId(professorId);
      final disponibilidade =
          await _disponibilidadeRepository.buscarPorId(disponibilidadeId);

      if (!_consultaValida(consulta)) {
        return;
      }

      if (professor == null) {
        throw StateError('Professor não encontrado.');
      }

      if (disponibilidade == null) {
        throw StateError('Disponibilidade não encontrada.');
      }

      if (disponibilidade.professorId != professorId) {
        throw StateError('A disponibilidade não pertence ao professor.');
      }

      _professor = professor;
      _disponibilidade = disponibilidade;
      _disciplinaSelecionada = professor.especialidades.isNotEmpty
          ? professor.especialidades.first
          : null;
    } catch (_) {
      if (!_consultaValida(consulta)) {
        return;
      }

      _erro = 'Não foi possível carregar os dados do agendamento.';
    } finally {
      if (_consultaValida(consulta)) {
        _carregando = false;
        _notificar();
      }
    }
  }

  void selecionarDisciplina(Disciplina disciplina) {
    _disciplinaSelecionada = disciplina;
    _erro = null;
    _notificar();
  }

  Future<void> confirmar({String? observacao}) async {
    final professor = _professor;
    final disponibilidade = _disponibilidade;
    final disciplina = _disciplinaSelecionada;

    if (professor == null || disponibilidade == null || disciplina == null) {
      _erro = 'Selecione uma disciplina para continuar.';
      _notificar();
      return;
    }

    final pessoaId = SessionManager.usuarioAtual?.id;
    if (pessoaId == null) {
      _erro = 'Faça login novamente para concluir o agendamento.';
      _notificar();
      return;
    }

    final alunoId = await _aulaRepository.buscarAlunoIdPorPessoaId(pessoaId);
    if (alunoId == null) {
      _erro = 'Não foi possível identificar o aluno logado.';
      _notificar();
      return;
    }

    final consulta = ++_consultaAtual;
    _salvando = true;
    _erro = null;
    _notificar();

    try {
      final professorId = professor.id;
      final disciplinaId = disciplina.id;

      if (professorId == null || disciplinaId == null) {
        throw StateError('Dados inválidos para confirmar o agendamento.');
      }

      final aula = Aula(
        alunoId: alunoId,
        professorId: professorId,
        disciplinaId: disciplinaId,
        inicio: disponibilidade.inicio,
        fim: disponibilidade.fim,
        status: 'agendada',
        modalidade: 'online',
        observacao: observacao,
      );

      final aulaId = await _aulaRepository.agendar(aula);

      if (!_consultaValida(consulta)) {
        return;
      }

      _aulaConfirmada = Aula(
        id: aulaId,
        alunoId: aula.alunoId,
        professorId: aula.professorId,
        disciplinaId: aula.disciplinaId,
        inicio: aula.inicio,
        fim: aula.fim,
        status: aula.status,
        modalidade: aula.modalidade,
        observacao: aula.observacao,
      );
    } catch (_) {
      if (_consultaValida(consulta)) {
        _erro = 'Não foi possível confirmar o agendamento.';
      }
    } finally {
      if (_consultaValida(consulta)) {
        _salvando = false;
        _notificar();
      }
    }
  }

  Future<bool> agendar(Aula aula) async {
    final consulta = ++_consultaAtual;

    _carregando = true;
    _erro = null;
    _notificar();

    try {
      await _aulaRepository.agendar(aula);

      if (!_consultaValida(consulta)) {
        return false;
      }

      return true;
    } catch (_) {
      if (_consultaValida(consulta)) {
        _erro = 'Não foi possível realizar o agendamento.';
      }
      return false;
    } finally {
      if (_consultaValida(consulta)) {
        _carregando = false;
        _notificar();
      }
    }
  }

  Future<bool> confirmarAgendamento(int aulaId) async {
    final consulta = ++_consultaAtual;

    _carregando = true;
    _erro = null;
    _notificar();

    try {
      await _aulaRepository.confirmar(aulaId);

      if (!_consultaValida(consulta)) {
        return false;
      }

      return true;
    } catch (_) {
      if (_consultaValida(consulta)) {
        _erro = 'Não foi possível confirmar o agendamento.';
      }
      return false;
    } finally {
      if (_consultaValida(consulta)) {
        _carregando = false;
        _notificar();
      }
    }
  }

  Future<Aula?> buscarAula(int aulaId) async {
    final consulta = ++_consultaAtual;

    _carregando = true;
    _erro = null;
    _notificar();

    try {
      final aula = await _aulaRepository.buscarPorId(aulaId);

      if (!_consultaValida(consulta)) {
        return null;
      }

      return aula;
    } catch (_) {
      if (_consultaValida(consulta)) {
        _erro = 'Não foi possível carregar a aula.';
      }
      return null;
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
    super.dispose();
  }
}
