import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_router.dart';
import '../../../data/repositories/aula_repository.dart';
import '../viewmodels/historico_viewmodel.dart';

class HistoricoPage extends StatelessWidget {
  const HistoricoPage({super.key});

  static const primaryBlue = Color(0xFF006DFF);
  static const darkBlue = Color(0xFF08295A);
  static const textGray = Color(0xFF657491);
  static const borderGray = Color(0xFFE4E9F2);
  static const lightBlue = Color(0xFFEAF2FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          tooltip: 'Voltar',
        ),
        title: const Text(
          'Histórico',
          style: TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Consumer<HistoricoViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.carregando &&
              viewModel.proximasAulas.isEmpty &&
              viewModel.historico.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.erro != null &&
              viewModel.proximasAulas.isEmpty &&
              viewModel.historico.isEmpty) {
            return _ErrorState(
              message: viewModel.erro!,
              onRetry: viewModel.tentarNovamente,
            );
          }

          return RefreshIndicator(
            onRefresh: viewModel.tentarNovamente,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
              children: [
                _SummaryCard(
                  proximas: viewModel.proximasAulas.length,
                  concluidas: viewModel.totalAulasConcluidas,
                  canceladas: viewModel.totalAulasCanceladas,
                ),
                const SizedBox(height: 22),
                _SectionHeader(
                  title: 'Próximas aulas',
                  subtitle: 'Agendamentos que ainda vão acontecer.',
                ),
                const SizedBox(height: 12),
                if (viewModel.proximasAulas.isEmpty)
                  const _EmptyMessage(
                    message: 'Você ainda não tem aulas futuras.',
                  )
                else
                  ...viewModel.proximasAulas.map(
                    (aula) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _LessonCard(
                        aula: aula,
                        onTap: () {
                          final aulaId = aula.aula.id;
                          if (aulaId != null) {
                            context.push(AppRoutes.detalhesAula(aulaId));
                          }
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 22),
                _SectionHeader(
                  title: 'Histórico completo',
                  subtitle: 'Aulas concluídas e canceladas.',
                ),
                const SizedBox(height: 12),
                if (viewModel.historico.isEmpty)
                  const _EmptyMessage(
                    message: 'Ainda não há registros no histórico.',
                  )
                else
                  ...viewModel.historico.map(
                    (aula) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _LessonCard(
                        aula: aula,
                        onTap: () {
                          final aulaId = aula.aula.id;
                          if (aulaId != null) {
                            context.push(AppRoutes.detalhesAula(aulaId));
                          }
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int proximas;
  final int concluidas;
  final int canceladas;

  const _SummaryCard({
    required this.proximas,
    required this.concluidas,
    required this.canceladas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: HistoricoPage.lightBlue,
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              number: proximas.toString(),
              label: 'próximas',
              icon: Icons.calendar_today_outlined,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SummaryItem(
              number: concluidas.toString(),
              label: 'concluídas',
              icon: Icons.check_circle_outline,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SummaryItem(
              number: canceladas.toString(),
              label: 'canceladas',
              icon: Icons.cancel_outlined,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String number;
  final String label;
  final IconData icon;

  const _SummaryItem({
    required this.number,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: HistoricoPage.primaryBlue, size: 24),
          const SizedBox(height: 10),
          Text(
            number,
            style: const TextStyle(
              color: HistoricoPage.darkBlue,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: HistoricoPage.textGray,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: HistoricoPage.darkBlue,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(color: HistoricoPage.textGray),
        ),
      ],
    );
  }
}

class _LessonCard extends StatelessWidget {
  final AulaDetalhada aula;
  final VoidCallback onTap;

  const _LessonCard({
    required this.aula,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final inicio = aula.aula.inicio;
    final fim = aula.aula.fim;
    final status = aula.aula.status;

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: HistoricoPage.borderGray),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: HistoricoPage.lightBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.menu_book_outlined,
                  color: HistoricoPage.primaryBlue,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      aula.disciplina,
                      style: const TextStyle(
                        color: HistoricoPage.darkBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      aula.professor,
                      style: const TextStyle(color: HistoricoPage.textGray),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_dateLabel(inicio)} • ${_time(inicio)} - ${_time(fim)}',
                      style: const TextStyle(
                        color: HistoricoPage.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusChip(status: status),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final background = switch (normalized) {
      'agendada' => HistoricoPage.lightBlue,
      'concluida' => const Color(0xFFE1F8EA),
      'cancelada' => const Color(0xFFFFE1E1),
      _ => const Color(0xFFF1F4F9),
    };
    final color = switch (normalized) {
      'agendada' => HistoricoPage.primaryBlue,
      'concluida' => const Color(0xFF0D9F4C),
      'cancelada' => const Color(0xFFE43D3D),
      _ => HistoricoPage.darkBlue,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          status,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  final String message;

  const _EmptyMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: HistoricoPage.textGray),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 58,
              color: HistoricoPage.textGray,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: HistoricoPage.darkBlue,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

String _dateLabel(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month';
}

String _time(DateTime date) {
  return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
