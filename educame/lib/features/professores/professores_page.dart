import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_router.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';
import '../../data/models/disciplina.dart';
import '../../data/models/professor.dart';
import 'professor_viewmodel.dart';

class ProfessoresPage extends StatefulWidget {
  const ProfessoresPage({super.key});

  @override
  State<ProfessoresPage> createState() => _ProfessoresPageState();
}

class _ProfessoresPageState extends State<ProfessoresPage> {
  static const primaryBlue = Color(0xFF006DFF);
  static const darkBlue = Color(0xFF08295A);
  static const textGray = Color(0xFF657491);
  static const borderGray = Color(0xFFE4E9F2);
  static const lightBlue = Color(0xFFEAF2FF);

  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: context.read<ProfessorViewModel>().termoBusca,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Encontre seu professor',
                    style: TextStyle(
                      color: darkBlue,
                      fontSize: 29,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Busque por nome ou filtre pela disciplina desejada.',
                    style: TextStyle(
                      color: textGray,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Consumer<ProfessorViewModel>(
                    builder: (context, viewModel, child) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              textInputAction: TextInputAction.search,
                              onChanged: viewModel.atualizarBusca,
                              onSubmitted: viewModel.buscar,
                              decoration: InputDecoration(
                                hintText: 'Buscar professor...',
                                hintStyle: const TextStyle(color: textGray),
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: viewModel.termoBusca.isEmpty
                                    ? null
                                    : IconButton(
                                        tooltip: 'Limpar busca',
                                        onPressed: () {
                                          _searchController.clear();
                                          unawaited(viewModel.buscar(''));
                                        },
                                        icon: const Icon(Icons.close),
                                      ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 17,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: borderGray,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: borderGray,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton.filledTonal(
                            tooltip: 'Filtrar por disciplina',
                            onPressed: () => _showDisciplineFilter(viewModel),
                            style: IconButton.styleFrom(
                              minimumSize: const Size(56, 56),
                              backgroundColor: lightBlue,
                              foregroundColor: primaryBlue,
                            ),
                            icon: Badge(
                              isLabelVisible:
                                  viewModel.disciplinaSelecionada != null,
                              child: const Icon(Icons.tune, size: 27),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Consumer<ProfessorViewModel>(
                    builder: (context, viewModel, child) {
                      final disciplina = viewModel.disciplinaSelecionada;
                      if (disciplina == null) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: InputChip(
                          avatar: const Icon(Icons.auto_stories, size: 18),
                          label: Text(disciplina.nome),
                          onDeleted: () {
                            unawaited(viewModel.selecionarDisciplina(null));
                          },
                          backgroundColor: lightBlue,
                          side: BorderSide.none,
                          labelStyle: const TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<ProfessorViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.carregando && viewModel.professores.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewModel.erro != null) {
                    return _FeedbackState(
                      icon: Icons.cloud_off_outlined,
                      message: viewModel.erro!,
                      buttonLabel: 'Tentar novamente',
                      onPressed: viewModel.tentarNovamente,
                    );
                  }
                  if (viewModel.semResultados) {
                    return _FeedbackState(
                      icon: Icons.search_off_outlined,
                      message: 'Nenhum professor encontrado.',
                      buttonLabel: viewModel.possuiFiltros
                          ? 'Limpar filtros'
                          : null,
                      onPressed: viewModel.possuiFiltros
                          ? () {
                              _searchController.clear();
                              return viewModel.limparFiltros();
                            }
                          : null,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: viewModel.tentarNovamente,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                      itemCount: viewModel.professores.length + 1,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (viewModel.carregando)
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 12),
                                  child: LinearProgressIndicator(),
                                ),
                              Text(
                                _resultCountLabel(viewModel.professores.length),
                                style: const TextStyle(
                                  color: textGray,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          );
                        }

                        return _ProfessorCard(
                          professor: viewModel.professores[index - 1],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDisciplineFilter(ProfessorViewModel viewModel) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 4, 24, 12),
                child: Text(
                  'Filtrar por disciplina',
                  style: TextStyle(
                    color: darkBlue,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.apps),
                title: const Text('Todas as disciplinas'),
                selected: viewModel.disciplinaSelecionada == null,
                onTap: () {
                  Navigator.pop(sheetContext);
                  unawaited(viewModel.selecionarDisciplina(null));
                },
              ),
              ...viewModel.disciplinas.map(
                (disciplina) => ListTile(
                  leading: const Icon(Icons.auto_stories_outlined),
                  title: Text(disciplina.nome),
                  subtitle: disciplina.descricao == null
                      ? null
                      : Text(
                          disciplina.descricao!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                  selected:
                      viewModel.disciplinaSelecionada?.id == disciplina.id,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    unawaited(viewModel.selecionarDisciplina(disciplina));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfessorCard extends StatelessWidget {
  final Professor professor;

  const _ProfessorCard({required this.professor});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: _ProfessoresPageState.borderGray),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.push(AppRoutes.professorDetalhes(professor.id!)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: _ProfessoresPageState.lightBlue,
                foregroundColor: _ProfessoresPageState.primaryBlue,
                backgroundImage: professor.pessoa.fotoPerfil == null
                    ? null
                    : NetworkImage(professor.pessoa.fotoPerfil!),
                child: professor.pessoa.fotoPerfil == null
                    ? Text(
                        professor.iniciais,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      professor.nomeCompleto,
                      style: const TextStyle(
                        color: _ProfessoresPageState.darkBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: professor.especialidades
                          .take(3)
                          .map((item) => _SubjectChip(disciplina: item))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      professor.bio ?? 'Biografia não informada.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ProfessoresPageState.textGray,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Wrap(
                      spacing: 14,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFF5B301),
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              professor.mediaAvaliacoes.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              ' (${professor.totalAvaliacoes})',
                              style: const TextStyle(
                                color: _ProfessoresPageState.textGray,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${_formatCurrency(professor.valorHoraAula)}/hora',
                          style: const TextStyle(
                            color: _ProfessoresPageState.primaryBlue,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text(
                          'Ver perfil →',
                          style: TextStyle(
                            color: _ProfessoresPageState.primaryBlue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubjectChip extends StatelessWidget {
  final Disciplina disciplina;

  const _SubjectChip({required this.disciplina});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _ProfessoresPageState.lightBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Text(
          disciplina.nome,
          style: const TextStyle(
            color: _ProfessoresPageState.primaryBlue,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _FeedbackState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? buttonLabel;
  final Future<void> Function()? onPressed;

  const _FeedbackState({
    required this.icon,
    required this.message,
    this.buttonLabel,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(32),
      children: [
        const SizedBox(height: 80),
        Icon(icon, size: 58, color: _ProfessoresPageState.textGray),
        const SizedBox(height: 18),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _ProfessoresPageState.darkBlue,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (buttonLabel != null && onPressed != null) ...[
          const SizedBox(height: 20),
          Center(
            child: FilledButton(
              onPressed: onPressed,
              child: Text(buttonLabel!),
            ),
          ),
        ],
      ],
    );
  }
}

String _formatCurrency(double value) {
  return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
}

String _resultCountLabel(int count) {
  return count == 1
      ? '1 professor encontrado'
      : '$count professores encontrados';
}
