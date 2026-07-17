import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/avaliacao_repository.dart';
import '../../data/repositories/disponibilidade_repository.dart';
import '../../data/repositories/professor_repository.dart';
import '../../features/home/view/home_page.dart';
import '../../features/login/view/login_page.dart';
import '../../features/mensagens/mensagens_page.dart';
import '../../features/perfil/view/perfil_page.dart';
import '../../features/professor_detalhes/professor_detalhes_page.dart';
import '../../features/professor_detalhes/professor_detalhes_viewmodel.dart';
import '../../features/professores/professores_page.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const professores = '/professores';
  static const mensagens = '/mensagens';
  static const perfil = '/perfil';

  static String professorDetalhes(int professorId) {
    return '$professores/$professorId';
  }
}

GoRouter createAppRouter({
  required ProfessorRepository professorRepository,
  required AvaliacaoRepository avaliacaoRepository,
  required DisponibilidadeRepository disponibilidadeRepository,
}) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.professores,
        builder: (context, state) => const ProfessoresPage(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final professorId = int.tryParse(
                state.pathParameters['id'] ?? '',
              );
              if (professorId == null || professorId <= 0) {
                return const _InvalidProfessorPage();
              }

              return ChangeNotifierProvider(
                create: (_) => ProfessorDetalhesViewModel(
                  professorRepository: professorRepository,
                  avaliacaoRepository: avaliacaoRepository,
                  disponibilidadeRepository: disponibilidadeRepository,
                )..carregar(professorId),
                child: ProfessorDetalhesPage(professorId: professorId),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.mensagens,
        builder: (context, state) => const MensagensPage(),
      ),
      GoRoute(
        path: AppRoutes.perfil,
        builder: (context, state) => const PerfilPage(),
      ),
    ],
  );
}

class _InvalidProfessorPage extends StatelessWidget {
  const _InvalidProfessorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_off_outlined, size: 56),
            const SizedBox(height: 16),
            const Text('Professor inválido.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(AppRoutes.professores),
              child: const Text('Voltar para professores'),
            ),
          ],
        ),
      ),
    );
  }
}
