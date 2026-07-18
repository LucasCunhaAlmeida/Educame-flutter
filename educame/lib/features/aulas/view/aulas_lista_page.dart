import 'package:flutter/material.dart';

import '../../../core/session/session_manager.dart';
import '../../../data/repositories/aula_repository.dart';

class AulasListaPage extends StatefulWidget {
  final AulaRepository aulaRepository;
  final bool historico;

  const AulasListaPage({
    super.key,
    required this.aulaRepository,
    required this.historico,
  });

  @override
  State<AulasListaPage> createState() => _AulasListaPageState();
}

class _AulasListaPageState extends State<AulasListaPage> {
  late final Future<List<AulaDetalhada>> _aulasFuture = _carregarAulas();

  static const Color primaryBlue = Color(0xFF006DFF);
  static const Color darkBlue = Color(0xFF08295A);
  static const Color textGray = Color(0xFF657491);
  static const Color borderGray = Color(0xFFE4E9F2);
  static const Color lightBlue = Color(0xFFEAF2FF);

  Future<List<AulaDetalhada>> _carregarAulas() async {
    final pessoaId = SessionManager.usuarioAtual?.id;
    if (pessoaId == null) {
      return const [];
    }

    final alunoId = await widget.aulaRepository.buscarAlunoIdPorPessoaId(
      pessoaId,
    );
    if (alunoId == null) {
      return const [];
    }

    if (widget.historico) {
      return widget.aulaRepository.listarHistoricoDetalhado(alunoId);
    }

    return widget.aulaRepository.listarProximasDetalhadas(alunoId);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.historico
        ? 'Histórico de aulas'
        : 'Aulas futuras';
    final emptyText = widget.historico
        ? 'Nenhuma aula anterior encontrada.'
        : 'Nenhuma aula futura encontrada.';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: FutureBuilder<List<AulaDetalhada>>(
        future: _aulasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const _MessageState(
              icon: Icons.cloud_off_outlined,
              text: 'Não foi possível carregar as aulas.',
            );
          }

          final aulas = snapshot.data ?? const [];
          if (aulas.isEmpty) {
            return _MessageState(
              icon: Icons.event_busy_outlined,
              text: emptyText,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            itemCount: aulas.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              return _AulaCard(aula: aulas[index]);
            },
          );
        },
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MessageState({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: _AulasListaPageState.textGray, size: 48),
            const SizedBox(height: 14),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _AulasListaPageState.textGray,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AulaCard extends StatelessWidget {
  final AulaDetalhada aula;

  const _AulaCard({required this.aula});

  @override
  Widget build(BuildContext context) {
    final inicio = aula.aula.inicio;
    final fim = aula.aula.fim;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _AulasListaPageState.borderGray),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _AulasListaPageState.lightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu_book_outlined,
                  color: _AulasListaPageState.primaryBlue,
                  size: 30,
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
                        color: _AulasListaPageState.darkBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      aula.professor,
                      style: const TextStyle(
                        color: _AulasListaPageState.textGray,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _InfoLine(
            icon: Icons.calendar_today_outlined,
            text: '${_formatDate(inicio)} às ${_formatTime(inicio)}',
          ),
          const SizedBox(height: 8),
          _InfoLine(
            icon: Icons.schedule_outlined,
            text: '${_formatTime(inicio)} - ${_formatTime(fim)}',
          ),
          const SizedBox(height: 8),
          _InfoLine(
            icon: Icons.location_on_outlined,
            text: _formatModalidade(aula.aula.modalidade),
          ),
          const SizedBox(height: 8),
          _InfoLine(
            icon: Icons.info_outline,
            text: _formatStatus(aula.aula.status),
          ),
          if ((aula.aula.observacao ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              aula.aula.observacao!.trim(),
              style: const TextStyle(
                color: _AulasListaPageState.textGray,
                fontSize: 14,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  static String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String _formatModalidade(String value) {
    return value.toLowerCase() == 'online' ? 'Aula online' : value;
  }

  static String _formatStatus(String value) {
    switch (value.toLowerCase()) {
      case 'concluida':
        return 'Concluída';
      case 'cancelada':
        return 'Cancelada';
      case 'agendada':
        return 'Agendada';
      default:
        return value;
    }
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _AulasListaPageState.primaryBlue, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _AulasListaPageState.textGray,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
