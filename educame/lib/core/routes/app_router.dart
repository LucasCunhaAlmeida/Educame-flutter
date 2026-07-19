import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/aula_repository.dart';
import '../../data/repositories/avaliacao_repository.dart';
import '../../data/repositories/disponibilidade_repository.dart';
import '../../data/repositories/pagamento_repository.dart';
import '../../data/repositories/professor_repository.dart';
import '../../features/aulas/view/aulas_lista_page.dart';
import '../../features/aulas/view/detalhes_aula_page.dart';
import '../../features/agendamento/view/confirmar_agendamento_page.dart';
import '../../features/home/view/home_page.dart';
import '../../features/login/view/login_page.dart';
import '../../features/mensagens/mensagens_page.dart';
import '../../features/historico/view/historico_page.dart';
import '../../features/historico/viewmodels/historico_viewmodel.dart';
import '../../features/perfil/view/perfil_page.dart';
import '../../features/professor_detalhes/view/professor_detalhes_page.dart';
import '../../features/professor_detalhes/viewmodel/professor_detalhes_viewmodel.dart';
import '../../features/professores/view/professores_page.dart';
import '../../features/agendamento/viewmodels/agendamento_viewmodel.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const professores = '/professores';
  static const mensagens = '/mensagens';
  static const perfil = '/perfil';
  static const aulasFuturas = '/aulas-futuras';
  static const historicoAulas = '/historico-aulas';
  static const confirmarAgendamentoBase = '/agendamentos/confirmar';
  static const detalhesAulaBase = '/aulas/detalhes';

  static String professorDetalhes(int professorId) {
    return '$professores/$professorId';
  }

  static String confirmarAgendamento({
    required int professorId,
    required int disponibilidadeId,
  }) {
    return '$confirmarAgendamentoBase/$professorId/$disponibilidadeId';
  }

  static String detalhesAula(int aulaId) {
    return '$detalhesAulaBase/$aulaId';
  }
}

GoRouter createAppRouter({
  required ProfessorRepository professorRepository,
  required AvaliacaoRepository avaliacaoRepository,
  required DisponibilidadeRepository disponibilidadeRepository,
  required AulaRepository aulaRepository,
  required PagamentoRepository pagamentoRepository,
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
        path: AppRoutes.aulasFuturas,
        builder: (context, state) => AulasListaPage(
          aulaRepository: aulaRepository,
          historico: false,
        ),
      ),
      GoRoute(
        path: AppRoutes.historicoAulas,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => HistoricoViewModel(
            aulaRepository: aulaRepository,
            pagamentoRepository: pagamentoRepository,
          )..carregar(),
          child: const HistoricoPage(),
        ),
      ),
      GoRoute(
        path: '${AppRoutes.confirmarAgendamentoBase}/:professorId/:disponibilidadeId',
        builder: (context, state) {
          final professorId = int.tryParse(
            state.pathParameters['professorId'] ?? '',
          );
          final disponibilidadeId = int.tryParse(
            state.pathParameters['disponibilidadeId'] ?? '',
          );

          if (professorId == null ||
              professorId <= 0 ||
              disponibilidadeId == null ||
              disponibilidadeId <= 0) {
            return const _InvalidRoutePage(message: 'Agendamento inválido.');
          }

          return ChangeNotifierProvider(
            create: (_) => AgendamentoViewModel(
              professorRepository: professorRepository,
              disponibilidadeRepository: disponibilidadeRepository,
              aulaRepository: aulaRepository,
            )..carregar(
                professorId: professorId,
                disponibilidadeId: disponibilidadeId,
              ),
            child: ConfirmarAgendamentoPage(
              professorId: professorId,
              disponibilidadeId: disponibilidadeId,
            ),
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.detalhesAulaBase}/:id',
        builder: (context, state) {
          final aulaId = int.tryParse(state.pathParameters['id'] ?? '');
          if (aulaId == null || aulaId <= 0) {
            return const _InvalidRoutePage(message: 'Aula inválida.');
          }

          return ChangeNotifierProvider(
            create: (_) => HistoricoViewModel(
              aulaRepository: aulaRepository,
              pagamentoRepository: pagamentoRepository,
            )
              ..selecionarAula(aulaId),
            child: DetalhesAulaPage(aulaId: aulaId),
          );
        },
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

class _InvalidRoutePage extends StatelessWidget {
  final String message;

  const _InvalidRoutePage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_outlined, size: 56),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }
}
