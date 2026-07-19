import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_router.dart';

import 'data/repositories/auth_repository.dart';
import 'data/repositories/aula_repository.dart';
import 'data/repositories/avaliacao_repository.dart';
import 'data/repositories/disciplina_repository.dart';
import 'data/repositories/disponibilidade_repository.dart';
import 'data/repositories/pagamento_repository.dart';
import 'data/repositories/perfil_repository.dart';
import 'data/repositories/professor_repository.dart';

import 'features/home/viewmodel/home_viewmodel.dart';
import 'features/perfil/viewmodel/perfil_viewmodel.dart';
import 'features/professores/viewmodel/professor_viewmodel.dart';

class EducameApp extends StatefulWidget {
  final ProfessorRepository? professorRepository;
  final DisciplinaRepository? disciplinaRepository;
  final DisponibilidadeRepository? disponibilidadeRepository;
  final AvaliacaoRepository? avaliacaoRepository;
  final AulaRepository? aulaRepository;

  const EducameApp({
    super.key,
    this.professorRepository,
    this.disciplinaRepository,
    this.disponibilidadeRepository,
    this.avaliacaoRepository,
    this.aulaRepository,
  });

  @override
  State<EducameApp> createState() => _EducameAppState();
}

class _EducameAppState extends State<EducameApp> {
  late final AuthRepository _authRepository;
  late final PerfilRepository _perfilRepository;

  late final ProfessorRepository _professorRepository;
  late final DisciplinaRepository _disciplinaRepository;
  late final DisponibilidadeRepository _disponibilidadeRepository;
  late final AvaliacaoRepository _avaliacaoRepository;
  late final AulaRepository _aulaRepository;
  late final PagamentoRepository _pagamentoRepository;

  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    _authRepository = AuthRepository();
    _perfilRepository = PerfilRepository();

    _professorRepository =
        widget.professorRepository ?? ProfessorRepository();

    _disciplinaRepository =
        widget.disciplinaRepository ?? DisciplinaRepository();

    _disponibilidadeRepository =
        widget.disponibilidadeRepository ??
        DisponibilidadeRepository();

    _avaliacaoRepository =
        widget.avaliacaoRepository ?? AvaliacaoRepository();

    _aulaRepository = widget.aulaRepository ?? AulaRepository();

    _pagamentoRepository = PagamentoRepository();

    _router = createAppRouter(
      professorRepository: _professorRepository,
      avaliacaoRepository: _avaliacaoRepository,
      disponibilidadeRepository: _disponibilidadeRepository,
      aulaRepository: _aulaRepository,
      pagamentoRepository: _pagamentoRepository,
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(
          value: _authRepository,
        ),

        Provider.value(
          value: _perfilRepository,
        ),

        Provider.value(
          value: _professorRepository,
        ),

        Provider.value(
          value: _disciplinaRepository,
        ),

        Provider.value(
          value: _disponibilidadeRepository,
        ),

        Provider.value(
          value: _avaliacaoRepository,
        ),

        Provider.value(
          value: _aulaRepository,
        ),

        Provider.value(
          value: _pagamentoRepository,
        ),

        ChangeNotifierProvider(
          create: (_) =>
              HomeViewModel(
                professorRepository: _professorRepository,
                aulaRepository: _aulaRepository,
              )..carregar(),
        ),

        ChangeNotifierProvider(
          create: (_) => PerfilViewModel(
            authRepository: _authRepository,
            perfilRepository: _perfilRepository,
          ),
        ),

        ChangeNotifierProvider(
          create: (_) =>
              ProfessorViewModel(
                professorRepository: _professorRepository,
                disciplinaRepository: _disciplinaRepository,
              )..inicializar(),
        ),
      ],

      child: MaterialApp.router(
        title: 'Educame',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF006DFF),
          ),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),

        routerConfig: _router,
      ),
    );
  }
}
