import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_router.dart';
import '../../../data/models/disponibilidade.dart';
import '../../../data/models/professor.dart';
import '../viewmodels/agendamento_viewmodel.dart';

class ConfirmarAgendamentoPage extends StatefulWidget {
  final int professorId;
  final int disponibilidadeId;

  static const primaryBlue = Color(0xFF006DFF);
  static const darkBlue = Color(0xFF08295A);
  static const textGray = Color(0xFF657491);
  static const borderGray = Color(0xFFE4E9F2);
  static const lightBlue = Color(0xFFEAF2FF);
  static const green = Color(0xFF0D9F4C);
  static const red = Color(0xFFE43D3D);

  const ConfirmarAgendamentoPage({
    super.key,
    required this.professorId,
    required this.disponibilidadeId,
  });

  @override
  State<ConfirmarAgendamentoPage> createState() =>
      _ConfirmarAgendamentoPageState();
}

class _ConfirmarAgendamentoPageState extends State<ConfirmarAgendamentoPage> {
  late final TextEditingController _observacaoController;

  @override
  void initState() {
    super.initState();
    _observacaoController = TextEditingController();
  }

  @override
  void dispose() {
    _observacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: ConfirmarAgendamentoPage.primaryBlue,
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
          'Confirmar agendamento',
          style: TextStyle(
            color: ConfirmarAgendamentoPage.darkBlue,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Consumer<AgendamentoViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.carregando && viewModel.professor == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.erro != null && viewModel.professor == null) {
            return _FeedbackState(
              message: viewModel.erro!,
              buttonLabel: 'Tentar novamente',
              onPressed: () => context.read<AgendamentoViewModel>().carregar(
                professorId: widget.professorId,
                disponibilidadeId: widget.disponibilidadeId,
              ),
            );
          }

          final professor = viewModel.professor;
          final disponibilidade = viewModel.disponibilidade;
          if (professor == null || disponibilidade == null) {
            return const SizedBox.shrink();
          }

          if (viewModel.aulaConfirmada != null) {
            return _SuccessState(
              professorNome: professor.nomeCompleto,
              disciplinaNome:
                  viewModel.disciplinaSelecionada?.nome ?? 'Disciplina',
              onVerDetalhes: () {
                final aulaId = viewModel.aulaConfirmada!.id;
                if (aulaId != null) {
                  context.push(AppRoutes.detalhesAula(aulaId));
                }
              },
              onVoltar: () => context.go(AppRoutes.aulasFuturas),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
            children: [
              _TeacherCard(professor: professor),
              const SizedBox(height: 18),
              _SlotCard(disponibilidade: disponibilidade),
              const SizedBox(height: 22),
              const Text(
                'Escolha a disciplina',
                style: TextStyle(
                  color: ConfirmarAgendamentoPage.darkBlue,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              if (professor.especialidades.isEmpty)
                const _EmptyHint(
                  message: 'Este professor não possui disciplinas associadas.',
                )
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: professor.especialidades
                      .map(
                        (disciplina) => ChoiceChip(
                          label: Text(disciplina.nome),
                          selected:
                              viewModel.disciplinaSelecionada?.id ==
                              disciplina.id,
                          selectedColor: ConfirmarAgendamentoPage.lightBlue,
                          side: BorderSide(
                            color:
                                viewModel.disciplinaSelecionada?.id ==
                                    disciplina.id
                                ? ConfirmarAgendamentoPage.primaryBlue
                                : ConfirmarAgendamentoPage.borderGray,
                          ),
                          labelStyle: TextStyle(
                            color:
                                viewModel.disciplinaSelecionada?.id ==
                                    disciplina.id
                                ? ConfirmarAgendamentoPage.primaryBlue
                                : ConfirmarAgendamentoPage.darkBlue,
                            fontWeight: FontWeight.w600,
                          ),
                          onSelected: (_) => context
                              .read<AgendamentoViewModel>()
                              .selecionarDisciplina(disciplina),
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 22),
              const Text(
                'Observações',
                style: TextStyle(
                  color: ConfirmarAgendamentoPage.darkBlue,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _observacaoController,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'Ex.: Quero revisar exercícios da lista 2',
                  hintStyle: const TextStyle(
                    color: ConfirmarAgendamentoPage.textGray,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFD),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: ConfirmarAgendamentoPage.borderGray,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: ConfirmarAgendamentoPage.borderGray,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: ConfirmarAgendamentoPage.primaryBlue,
                      width: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              _PaymentPreviewCard(
                valor: professor.valorHoraAula,
                vencimento: disponibilidade.inicio.subtract(
                  const Duration(days: 1),
                ),
              ),
              if (viewModel.erro != null) ...[
                const SizedBox(height: 14),
                Text(
                  viewModel.erro!,
                  style: const TextStyle(
                    color: ConfirmarAgendamentoPage.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 22),
              FilledButton(
                onPressed: viewModel.salvando || !viewModel.podeConfirmar
                    ? null
                    : () async {
                        await context.read<AgendamentoViewModel>().confirmar(
                          observacao: _observacaoController.text.trim().isEmpty
                              ? null
                              : _observacaoController.text.trim(),
                        );
                      },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                ),
                child: Text(
                  viewModel.salvando
                      ? 'Confirmando...'
                      : 'Confirmar agendamento',
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Voltar'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TeacherCard extends StatelessWidget {
  final Professor professor;

  const _TeacherCard({required this.professor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ConfirmarAgendamentoPage.borderGray),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: ConfirmarAgendamentoPage.lightBlue,
            foregroundColor: ConfirmarAgendamentoPage.primaryBlue,
            child: Text(
              professor.iniciais,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  professor.nomeCompleto,
                  style: const TextStyle(
                    color: ConfirmarAgendamentoPage.darkBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  professor.especialidades.isEmpty
                      ? 'Professor'
                      : professor.especialidades.first.nome,
                  style: const TextStyle(
                    color: ConfirmarAgendamentoPage.textGray,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'R\$ ${professor.valorHoraAula.toStringAsFixed(2).replaceAll('.', ',')}/h',
            style: const TextStyle(
              color: ConfirmarAgendamentoPage.primaryBlue,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  final Disponibilidade disponibilidade;

  const _SlotCard({required this.disponibilidade});

  @override
  Widget build(BuildContext context) {
    final inicio = disponibilidade.inicio;
    final fim = disponibilidade.fim;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ConfirmarAgendamentoPage.lightBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Horário selecionado',
            style: TextStyle(
              color: ConfirmarAgendamentoPage.darkBlue,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _dateLabel(inicio),
            style: const TextStyle(
              color: ConfirmarAgendamentoPage.textGray,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${_time(inicio)} - ${_time(fim)}',
            style: const TextStyle(
              color: ConfirmarAgendamentoPage.primaryBlue,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentPreviewCard extends StatelessWidget {
  final double valor;
  final DateTime vencimento;

  const _PaymentPreviewCard({required this.valor, required this.vencimento});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ConfirmarAgendamentoPage.borderGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pagamento estimado',
            style: TextStyle(
              color: ConfirmarAgendamentoPage.darkBlue,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Valor: R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}',
            style: const TextStyle(
              color: ConfirmarAgendamentoPage.textGray,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Vencimento: ${_dateLabel(vencimento)}',
            style: const TextStyle(
              color: ConfirmarAgendamentoPage.textGray,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  final String professorNome;
  final String disciplinaNome;
  final VoidCallback onVerDetalhes;
  final VoidCallback onVoltar;

  const _SuccessState({
    required this.professorNome,
    required this.disciplinaNome,
    required this.onVerDetalhes,
    required this.onVoltar,
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
              Icons.check_circle_outline,
              size: 72,
              color: ConfirmarAgendamentoPage.green,
            ),
            const SizedBox(height: 18),
            const Text(
              'Agendamento confirmado',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ConfirmarAgendamentoPage.darkBlue,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sua aula de $disciplinaNome com $professorNome foi reservada com sucesso.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: ConfirmarAgendamentoPage.textGray),
            ),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: onVerDetalhes,
              child: const Text('Ver detalhes da aula'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onVoltar,
              child: const Text('Ir para meus agendamentos'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackState extends StatelessWidget {
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;

  const _FeedbackState({
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
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
              color: ConfirmarAgendamentoPage.textGray,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ConfirmarAgendamentoPage.darkBlue,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(onPressed: onPressed, child: Text(buttonLabel)),
          ],
        ),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String message;

  const _EmptyHint({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        message,
        style: const TextStyle(color: ConfirmarAgendamentoPage.textGray),
      ),
    );
  }
}

String _dateLabel(DateTime date) {
  const weekdays = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'];
  final weekday = weekdays[date.weekday - 1];
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$weekday, $day/$month/${date.year}';
}

String _time(DateTime date) {
  return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
