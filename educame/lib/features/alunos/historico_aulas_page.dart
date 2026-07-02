import 'package:flutter/material.dart';

import '../../core/widgets/app_bottom_nav_bar.dart';

class HistoricoAulasPage extends StatelessWidget {
  const HistoricoAulasPage({super.key});

  static const Color primaryBlue = Color(0xFF006DFF);
  static const Color darkBlue = Color(0xFF08295A);
  static const Color textGray = Color(0xFF657491);
  static const Color borderGray = Color(0xFFE4E9F2);
  static const Color lightBlue = Color(0xFFEAF2FF);
  static const Color green = Color(0xFF00A849);
  static const Color red = Color(0xFFFF1F1F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const AppBottomNavBar(
        currentIndex: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TopBar(),

              const SizedBox(height: 34),

              const Text(
                'Histórico de aulas',
                style: TextStyle(
                  color: darkBlue,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Veja suas aulas anteriores e revise os detalhes.',
                style: TextStyle(
                  color: textGray,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 30),

              const _SummaryCard(),

              const SizedBox(height: 34),

              const _SearchAndFilter(),

              const SizedBox(height: 28),

              const _Tabs(),

              const SizedBox(height: 24),

              const _HistoryLessonCard(
                title: 'Matemática',
                teacher: 'Prof. Rafael Lima',
                date: 'Sex, 17/05/2024',
                time: '14:00',
                status: 'Concluída',
                statusColor: green,
                statusBackground: Color(0xFFE1F8EA),
                icon: Icons.calculate_outlined,
                iconColor: primaryBlue,
                iconBackground: lightBlue,
              ),

              const SizedBox(height: 14),

              const _HistoryLessonCard(
                title: 'Física',
                teacher: 'Profa. Camila Souza',
                date: 'Qua, 15/05/2024',
                time: '16:30',
                status: 'Concluída',
                statusColor: green,
                statusBackground: Color(0xFFE1F8EA),
                icon: Icons.science_outlined,
                iconColor: Color(0xFF18C56E),
                iconBackground: Color(0xFFE9F9F0),
              ),

              const SizedBox(height: 14),

              const _HistoryLessonCard(
                title: 'Química',
                teacher: 'Prof. João Pedro',
                date: 'Ter, 14/05/2024',
                time: '10:00',
                status: 'Concluída',
                statusColor: green,
                statusBackground: Color(0xFFE1F8EA),
                icon: Icons.menu_book_outlined,
                iconColor: Color(0xFF7B3DFF),
                iconBackground: Color(0xFFF1EAFE),
              ),

              const SizedBox(height: 14),

              const _HistoryLessonCard(
                title: 'Inglês',
                teacher: 'Profa. Mariana Alves',
                date: 'Seg, 13/05/2024',
                time: '11:00',
                status: 'Concluída',
                statusColor: green,
                statusBackground: Color(0xFFE1F8EA),
                icon: Icons.translate_outlined,
                iconColor: Color(0xFFFF9900),
                iconBackground: Color(0xFFFFF4DF),
              ),

              const SizedBox(height: 14),

              const _HistoryLessonCard(
                title: 'Programação',
                teacher: 'Prof. Lucas Martins',
                date: 'Sex, 10/05/2024',
                time: '15:00',
                status: 'Cancelada',
                statusColor: red,
                statusBackground: Color(0xFFFFE1E1),
                icon: Icons.code,
                iconColor: red,
                iconBackground: Color(0xFFFFEEEE),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.arrow_back,
          color: HistoricoAulasPage.primaryBlue,
          size: 32,
        ),
        CircleAvatar(
          radius: 31,
          backgroundColor: HistoricoAulasPage.lightBlue,
          child: Icon(
            Icons.person_outline,
            color: HistoricoAulasPage.primaryBlue,
            size: 36,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.symmetric(horizontal: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: HistoricoAulasPage.borderGray,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Expanded(
            child: _SummaryItem(
              icon: Icons.check,
              iconColor: HistoricoAulasPage.green,
              iconBackground: Color(0xFFE4F8EB),
              number: '12',
              label: 'aulas concluídas',
              numberColor: HistoricoAulasPage.green,
            ),
          ),

          Container(
            width: 1,
            height: 48,
            color: HistoricoAulasPage.borderGray,
          ),

          const Expanded(
            child: _SummaryItem(
              icon: Icons.close,
              iconColor: HistoricoAulasPage.red,
              iconBackground: Color(0xFFFFE4E4),
              number: '1',
              label: 'cancelada',
              numberColor: HistoricoAulasPage.red,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String number;
  final String label;
  final Color numberColor;

  const _SummaryItem({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.number,
    required this.label,
    required this.numberColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: iconBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 34,
          ),
        ),

        const SizedBox(width: 20),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: TextStyle(
                color: numberColor,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: HistoricoAulasPage.textGray,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SearchAndFilter extends StatelessWidget {
  const _SearchAndFilter();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: HistoricoAulasPage.borderGray,
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.search,
                  color: HistoricoAulasPage.textGray,
                  size: 30,
                ),
                SizedBox(width: 16),
                Text(
                  'Buscar aula ou professor',
                  style: TextStyle(
                    color: Color(0xFF8A96AD),
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 18),

        Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: HistoricoAulasPage.borderGray,
              width: 1.2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.filter_alt_outlined,
                color: HistoricoAulasPage.primaryBlue,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'Filtros',
                style: TextStyle(
                  color: HistoricoAulasPage.primaryBlue,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _FilterTab(
            text: 'Todas',
            selected: false,
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: _FilterTab(
            text: 'Concluídas',
            selected: true,
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: _FilterTab(
            text: 'Canceladas',
            selected: false,
          ),
        ),
      ],
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String text;
  final bool selected;

  const _FilterTab({
    required this.text,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? Colors.white : const Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected
              ? HistoricoAulasPage.primaryBlue
              : const Color(0xFFF5F7FB),
          width: 1.2,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected
              ? HistoricoAulasPage.primaryBlue
              : HistoricoAulasPage.darkBlue,
          fontSize: 16,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _HistoryLessonCard extends StatelessWidget {
  final String title;
  final String teacher;
  final String date;
  final String time;
  final String status;
  final Color statusColor;
  final Color statusBackground;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  const _HistoryLessonCard({
    required this.title,
    required this.teacher,
    required this.date,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.statusBackground,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: HistoricoAulasPage.borderGray,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 40,
            ),
          ),

          const SizedBox(width: 22),

          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: HistoricoAulasPage.darkBlue,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  teacher,
                  style: const TextStyle(
                    color: HistoricoAulasPage.textGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 7),
                const Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: HistoricoAulasPage.textGray,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Aula online',
                      style: TextStyle(
                        color: HistoricoAulasPage.textGray,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    color: HistoricoAulasPage.textGray,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: const TextStyle(
                    color: HistoricoAulasPage.primaryBlue,
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: statusBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 14),

          const Icon(
            Icons.chevron_right,
            color: HistoricoAulasPage.primaryBlue,
            size: 32,
          ),
        ],
      ),
    );
  }
}