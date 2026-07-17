import 'package:flutter/foundation.dart';

import '../../data/models/professor.dart';
import '../../data/repositories/professor_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final ProfessorRepository _professorRepository;

  HomeViewModel({required ProfessorRepository professorRepository})
    : _professorRepository = professorRepository;

  List<Professor> _professoresDestaque = const [];
  bool _carregando = false;
  String? _erro;
  bool _disposed = false;

  List<Professor> get professoresDestaque => _professoresDestaque;
  bool get carregando => _carregando;
  String? get erro => _erro;
  bool get semDestaques =>
      !_carregando && _erro == null && _professoresDestaque.isEmpty;

  Future<void> carregar() async {
    if (_carregando) {
      return;
    }

    _carregando = true;
    _erro = null;
    _notificar();

    try {
      final professores = await _professorRepository.listar(limite: 4);
      if (_disposed) {
        return;
      }
      _professoresDestaque = List.unmodifiable(professores);
    } catch (_) {
      if (_disposed) {
        return;
      }
      _professoresDestaque = const [];
      _erro = 'Não foi possível carregar os professores em destaque.';
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
