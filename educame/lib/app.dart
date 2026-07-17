import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_router.dart';
import 'data/repositories/avaliacao_repository.dart';
import 'data/repositories/disciplina_repository.dart';
import 'data/repositories/disponibilidade_repository.dart';
import 'data/repositories/professor_repository.dart';
import 'features/home/viewmodel/home_viewmodel.dart';
import 'features/perfil/viewmodel/perfil_viewmodel.dart';
import 'features/professores/viewmodel/professor_viewmodel.dart';

class EducameApp extends StatefulWidget {
  final ProfessorRepository? professorRepository;
  final DisciplinaRepository? disciplinaRepository;
  final DisponibilidadeRepository? disponibilidadeRepository;
  final AvaliacaoRepository? avaliacaoRepository;

  const EducameApp({
    super.key,
    this.professorRepository,
    this.disciplinaRepository,
    this.disponibilidadeRepository,
    this.avaliacaoRepository,
  });

  @override
  State<EducameApp> createState() => _EducameAppState();
}

class _EducameAppState extends State<EducameApp> {
  late final ProfessorRepository _professorRepository;
  late final DisciplinaRepository _disciplinaRepository;
  late final DisponibilidadeRepository _disponibilidadeRepository;
  late final AvaliacaoRepository _avaliacaoRepository;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _professorRepository = widget.professorRepository ?? ProfessorRepository();
    _disciplinaRepository =
        widget.disciplinaRepository ?? DisciplinaRepository();
    _disponibilidadeRepository =
        widget.disponibilidadeRepository ?? DisponibilidadeRepository();
    _avaliacaoRepository = widget.avaliacaoRepository ?? AvaliacaoRepository();
    _router = createAppRouter(
      professorRepository: _professorRepository,
      avaliacaoRepository: _avaliacaoRepository,
      disponibilidadeRepository: _disponibilidadeRepository,
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
        Provider.value(value: _professorRepository),
        Provider.value(value: _disciplinaRepository),
        Provider.value(value: _disponibilidadeRepository),
        Provider.value(value: _avaliacaoRepository),
        ChangeNotifierProvider(
          create: (_) =>
              HomeViewModel(professorRepository: _professorRepository)
                ..carregar(),
        ),
        ChangeNotifierProvider(create: (_) => PerfilViewModel()),
        ChangeNotifierProvider(
          create: (_) => ProfessorViewModel(
            professorRepository: _professorRepository,
            disciplinaRepository: _disciplinaRepository,
          )..inicializar(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Educame',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006DFF)),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}
