import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_router.dart';
import '../../../data/models/avaliacao.dart';
import '../../../data/models/disponibilidade.dart';
import '../../../data/models/professor.dart';
import '../viewmodel/professor_detalhes_viewmodel.dart';

class ProfessorDetalhesPage extends StatelessWidget {
  final int professorId;

  const ProfessorDetalhesPage({super.key, required this.professorId});

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
          tooltip: 'Voltar',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.professores);
            }
          },
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
        ),
        title: const Text(
          'Perfil do professor',
          style: TextStyle(color: darkBlue, fontWeight: FontWeight.w800),
        ),
      ),
      body: Consumer<ProfessorDetalhesViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.carregando && viewModel.professor == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.erro != null && viewModel.professor == null) {
            return _DetailsError(
              message: viewModel.erro!,
              onRetry: viewModel.tentarNovamente,
            );
          }

          final professor = viewModel.professor;
          if (professor == null) {
            return const SizedBox.shrink();
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.carregar(professorId),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 36),
              children: [
                _ProfessorHeader(professor: professor),
                const SizedBox(height: 24),
                _InfoSummary(professor: professor),
                const SizedBox(height: 30),
                const _SectionTitle(title: 'Especialidades'),
                const SizedBox(height: 13),
                Wrap(
                  spacing: 9,
                  runSpacing: 9,
                  children: professor.especialidades
                      .map(
                        (item) => Chip(
                          label: Text(item.nome),
                          backgroundColor: lightBlue,
                          side: BorderSide.none,
                          labelStyle: const TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 30),
                const _SectionTitle(title: 'Sobre o professor'),
                const SizedBox(height: 12),
                Text(
                  professor.bio ?? 'Biografia não informada.',
                  style: const TextStyle(
                    color: textGray,
                    fontSize: 16,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 30),
                const _SectionTitle(title: 'Avaliações dos alunos'),
                const SizedBox(height: 14),
                if (viewModel.semAvaliacoes)
                  const _EmptySection(
                    icon: Icons.rate_review_outlined,
                    message: 'Este professor ainda não possui avaliações.',
                  )
                else
                  ...viewModel.avaliacoes.map(
                    (avaliacao) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _EvaluationCard(avaliacao: avaliacao),
                    ),
                  ),
                const SizedBox(height: 18),
                const _SectionTitle(title: 'Horários disponíveis'),
                const SizedBox(height: 7),
                const Text(
                  'Consulte os horários livres. A reserva é realizada em outro módulo.',
                  style: TextStyle(color: textGray, height: 1.4),
                ),
                const SizedBox(height: 14),
                if (viewModel.semDisponibilidade)
                  const _EmptySection(
                    icon: Icons.event_busy_outlined,
                    message: 'Nenhum horário disponível no momento.',
                  )
                else
                  ...viewModel.disponibilidadesPorDia.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AvailabilityDay(
                        date: entry.key,
                        items: entry.value,
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

class _ProfessorHeader extends StatelessWidget {
  final Professor professor;

  const _ProfessorHeader({required this.professor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: ProfessorDetalhesPage.lightBlue,
          foregroundColor: ProfessorDetalhesPage.primaryBlue,
          backgroundImage: professor.pessoa.fotoPerfil == null
              ? null
              : professor.pessoa.fotoPerfil!.startsWith('http')
                  ? NetworkImage(professor.pessoa.fotoPerfil!)
                  : FileImage(File(professor.pessoa.fotoPerfil!))
                      as ImageProvider,
          child: professor.pessoa.fotoPerfil == null
              ? Text(
                  professor.iniciais,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                professor.nomeCompleto,
                style: const TextStyle(
                  color: ProfessorDetalhesPage.darkBlue,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                professor.diploma ?? 'Formação não informada',
                style: const TextStyle(
                  color: ProfessorDetalhesPage.textGray,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFF5B301),
                    size: 22,
                  ),
                  Text(
                    professor.mediaAvaliacoes.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    ' (${professor.totalAvaliacoes} avaliações)',
                    style: const TextStyle(
                      color: ProfessorDetalhesPage.textGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoSummary extends StatelessWidget {
  final Professor professor;

  const _InfoSummary({required this.professor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ProfessorDetalhesPage.lightBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            foregroundColor: ProfessorDetalhesPage.primaryBlue,
            child: Icon(Icons.payments_outlined),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Valor por hora',
              style: TextStyle(
                color: ProfessorDetalhesPage.textGray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            _formatCurrency(professor.valorHoraAula),
            style: const TextStyle(
              color: ProfessorDetalhesPage.primaryBlue,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: ProfessorDetalhesPage.darkBlue,
        fontSize: 19,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _EvaluationCard extends StatelessWidget {
  final Avaliacao avaliacao;

  const _EvaluationCard({required this.avaliacao});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: ProfessorDetalhesPage.borderGray),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: ProfessorDetalhesPage.lightBlue,
                foregroundColor: ProfessorDetalhesPage.primaryBlue,
                child: Text(
                  avaliacao.autorInicial,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  avaliacao.autorNome,
                  style: const TextStyle(
                    color: ProfessorDetalhesPage.darkBlue,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (avaliacao.dataAvaliacao != null)
                Text(
                  _shortDate(avaliacao.dataAvaliacao!),
                  style: const TextStyle(
                    color: ProfessorDetalhesPage.textGray,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ...List.generate(
                5,
                (index) => Icon(
                  index < avaliacao.nota.round()
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: const Color(0xFFF5B301),
                  size: 19,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                avaliacao.nota.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          if (avaliacao.comentario?.isNotEmpty ?? false) ...[
            const SizedBox(height: 10),
            Text(
              avaliacao.comentario!,
              style: const TextStyle(
                color: ProfessorDetalhesPage.textGray,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AvailabilityDay extends StatelessWidget {
  final DateTime date;
  final List<Disponibilidade> items;

  const _AvailabilityDay({required this.date, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: ProfessorDetalhesPage.borderGray),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _longDate(date),
            style: const TextStyle(
              color: ProfessorDetalhesPage.darkBlue,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: items
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: ProfessorDetalhesPage.lightBlue,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: ProfessorDetalhesPage.primaryBlue,
                          size: 17,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${_time(item.inicio)} - ${_time(item.fim)}',
                          style: const TextStyle(
                            color: ProfessorDetalhesPage.primaryBlue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptySection({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: ProfessorDetalhesPage.textGray, size: 34),
          const SizedBox(height: 9),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: ProfessorDetalhesPage.textGray),
          ),
        ],
      ),
    );
  }
}

class _DetailsError extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _DetailsError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_off_outlined,
              size: 58,
              color: ProfessorDetalhesPage.textGray,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ProfessorDetalhesPage.darkBlue,
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

String _formatCurrency(double value) {
  return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
}

String _time(DateTime date) {
  return '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}

String _shortDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String _longDate(DateTime date) {
  const weekdays = [
    'segunda-feira',
    'terça-feira',
    'quarta-feira',
    'quinta-feira',
    'sexta-feira',
    'sábado',
    'domingo',
  ];
  const months = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ];
  final weekday = weekdays[date.weekday - 1];
  final month = months[date.month - 1];
  return '${weekday[0].toUpperCase()}${weekday.substring(1)}, '
      '${date.day} de $month';
}
