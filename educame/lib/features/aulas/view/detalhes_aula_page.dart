import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_router.dart';
import '../../../data/models/pagamento.dart';
import '../../historico/viewmodels/historico_viewmodel.dart';

class DetalhesAulaPage extends StatelessWidget {
  final int aulaId;

  const DetalhesAulaPage({super.key, required this.aulaId});

  static const primaryBlue = Color(0xFF006DFF);
  static const darkBlue = Color(0xFF08295A);
  static const textGray = Color(0xFF657491);
  static const borderGray = Color(0xFFE4E9F2);
  static const lightBlue = Color(0xFFEAF2FF);
  static const green = Color(0xFF0D9F4C);
  static const red = Color(0xFFE43D3D);

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
          'Detalhes da aula',
          style: TextStyle(color: darkBlue, fontWeight: FontWeight.w800),
        ),
      ),
      body: Consumer<HistoricoViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.carregando && viewModel.aulaSelecionada == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.erro != null && viewModel.aulaSelecionada == null) {
            return _ErrorState(
              message: viewModel.erro!,
              onRetry: () =>
                  context.read<HistoricoViewModel>().selecionarAula(aulaId),
            );
          }

          final aula = viewModel.aulaSelecionada;
          if (aula == null) {
            return const SizedBox.shrink();
          }

          final pagamento = viewModel.pagamentoSelecionado;
          final status = aula.aula.status.toLowerCase();
          final podeCancelar =
              status == 'agendada' && aula.aula.inicio.isAfter(DateTime.now());

          return RefreshIndicator(
            onRefresh: () =>
                context.read<HistoricoViewModel>().selecionarAula(aulaId),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
              children: [
                _ClassHeader(
                  disciplina: aula.disciplina,
                  professor: aula.professor,
                  status: aula.aula.status,
                ),
                const SizedBox(height: 18),
                _InfoCard(
                  icon: Icons.calendar_today_outlined,
                  title: 'Data e horário',
                  child: Text(
                    '${_dateLabel(aula.aula.inicio)} às ${_time(aula.aula.inicio)}',
                    style: const TextStyle(
                      color: DetalhesAulaPage.darkBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  icon: Icons.schedule_outlined,
                  title: 'Duração',
                  child: Text(
                    '${_time(aula.aula.inicio)} - ${_time(aula.aula.fim)}',
                    style: const TextStyle(
                      color: DetalhesAulaPage.darkBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  icon: Icons.location_on_outlined,
                  title: 'Modalidade',
                  child: Text(
                    aula.aula.modalidade.toLowerCase() == 'online'
                        ? 'Aula online'
                        : aula.aula.modalidade,
                    style: const TextStyle(
                      color: DetalhesAulaPage.darkBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  icon: Icons.info_outline,
                  title: 'Status',
                  child: _StatusChip(status: aula.aula.status),
                ),
                if ((aula.aula.observacao ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _InfoCard(
                    icon: Icons.notes_outlined,
                    title: 'Observações',
                    child: Text(
                      aula.aula.observacao!.trim(),
                      style: const TextStyle(color: DetalhesAulaPage.textGray),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                _PaymentCard(pagamento: pagamento),
                if (podeCancelar) ...[
                  const SizedBox(height: 18),
                  FilledButton.tonalIcon(
                    onPressed: viewModel.carregando
                        ? null
                        : () => context.read<HistoricoViewModel>().cancelarAula(
                            aulaId,
                          ),
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Cancelar agendamento'),
                  ),
                ],
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Voltar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ClassHeader extends StatelessWidget {
  final String disciplina;
  final String professor;
  final String status;

  const _ClassHeader({
    required this.disciplina,
    required this.professor,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: DetalhesAulaPage.lightBlue,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            foregroundColor: DetalhesAulaPage.primaryBlue,
            child: Icon(Icons.menu_book_outlined),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  disciplina,
                  style: const TextStyle(
                    color: DetalhesAulaPage.darkBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  professor,
                  style: const TextStyle(color: DetalhesAulaPage.textGray),
                ),
              ],
            ),
          ),
          _StatusChip(status: status),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: DetalhesAulaPage.borderGray),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: DetalhesAulaPage.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: DetalhesAulaPage.primaryBlue, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: DetalhesAulaPage.darkBlue,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final Pagamento? pagamento;

  const _PaymentCard({required this.pagamento});

  @override
  Widget build(BuildContext context) {
    final pagamento = this.pagamento;
    if (pagamento == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'Nenhuma informação de pagamento disponível para esta aula.',
          style: TextStyle(color: DetalhesAulaPage.textGray),
        ),
      );
    }

    final status = pagamento.status;
    final valor = pagamento.valor;
    final dataVencimento = pagamento.dataVencimento;
    final dataPagamento = pagamento.dataPagamento;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: DetalhesAulaPage.borderGray),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pagamento',
            style: TextStyle(
              color: DetalhesAulaPage.darkBlue,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Valor: R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}',
            style: const TextStyle(
              color: DetalhesAulaPage.textGray,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Vencimento: ${_dateLabel(dataVencimento)}',
            style: const TextStyle(color: DetalhesAulaPage.textGray),
          ),
          const SizedBox(height: 6),
          Text(
            dataPagamento == null
                ? 'Pagamento ainda não registrado.'
                : 'Pago em ${_dateLabel(dataPagamento)}',
            style: const TextStyle(color: DetalhesAulaPage.textGray),
          ),
          const SizedBox(height: 10),
          _StatusChip(status: status),
        ],
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
      'agendada' => DetalhesAulaPage.lightBlue,
      'concluida' => const Color(0xFFE1F8EA),
      'cancelada' => const Color(0xFFFFE1E1),
      'pendente' => const Color(0xFFFFF2D9),
      _ => const Color(0xFFF1F4F9),
    };
    final color = switch (normalized) {
      'agendada' => DetalhesAulaPage.primaryBlue,
      'concluida' => DetalhesAulaPage.green,
      'cancelada' => DetalhesAulaPage.red,
      'pendente' => const Color(0xFFCC8400),
      _ => DetalhesAulaPage.darkBlue,
    };
    final label = switch (normalized) {
      'agendada' => 'Agendada',
      'confirmada' => 'Confirmada',
      'concluida' => 'Concluída',
      'cancelada' => 'Cancelada',
      'pendente' => 'Pendente',
      'pago' => 'Pago',
      'cancelado' => 'Cancelado',
      _ => status,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

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
              color: DetalhesAulaPage.textGray,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: DetalhesAulaPage.darkBlue,
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
  return '$day/$month/${date.year}';
}

String _time(DateTime date) {
  return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
