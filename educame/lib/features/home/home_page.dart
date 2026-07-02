import 'package:flutter/material.dart';

import '../../core/widgets/app_bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color primaryBlue = Color(0xFF006DFF);
  static const Color darkBlue = Color(0xFF08295A);
  static const Color textGray = Color(0xFF657491);
  static const Color borderGray = Color(0xFFE4E9F2);
  static const Color lightBlue = Color(0xFFEAF2FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const AppBottomNavBar(
        currentIndex: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 34, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Header(),

              const SizedBox(height: 52),

              _SectionHeader(
                icon: Icons.calendar_today_outlined,
                title: 'Próximas aulas',
                actionText: 'Ver todas',
              ),

              const SizedBox(height: 8),

              const Text(
                'Veja seus agendamentos desta semana.',
                style: TextStyle(
                  color: textGray,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 26),

              const _ClassCard(
                title: 'Matemática',
                teacher: 'Prof. Rafael Lima',
                type: 'Aula online',
                date: 'Seg, 20/05',
                time: '14:00',
                icon: Icons.calculate_outlined,
                iconColor: primaryBlue,
                backgroundColor: Color(0xFFEAF2FF),
              ),

              const SizedBox(height: 14),

              const _ClassCard(
                title: 'Física',
                teacher: 'Profa. Camila Souza',
                type: 'Aula online',
                date: 'Qua, 22/05',
                time: '16:30',
                icon: Icons.science_outlined,
                iconColor: Color(0xFF18C56E),
                backgroundColor: Color(0xFFE9F9F0),
              ),

              const SizedBox(height: 14),

              const _ClassCard(
                title: 'Química',
                teacher: 'Prof. João Pedro',
                type: 'Aula online',
                date: 'Sex, 24/05',
                time: '10:00',
                icon: Icons.menu_book_outlined,
                iconColor: Color(0xFF7B3DFF),
                backgroundColor: Color(0xFFF1EAFE),
              ),

              const SizedBox(height: 14),

              const _ClassCard(
                title: 'Inglês',
                teacher: 'Profa. Mariana Alves',
                type: 'Aula online',
                date: 'Sáb, 25/05',
                time: '11:00',
                icon: Icons.translate_outlined,
                iconColor: Color(0xFFFF9900),
                backgroundColor: Color(0xFFFFF4DF),
              ),

              const SizedBox(height: 20),

              const _EmptyScheduleCard(),

              const SizedBox(height: 46),

              _SectionHeader(
                icon: Icons.auto_stories_outlined,
                title: 'Explorar disciplinas',
                actionText: 'Ver todas',
              ),

              const SizedBox(height: 28),

              const _SubjectsList(),

              const SizedBox(height: 34),

              const _HistoryCard(),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, Lucas!',
              style: TextStyle(
                color: HomePage.darkBlue,
                fontSize: 31,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Aqui está sua agenda da semana.',
              style: TextStyle(
                color: HomePage.textGray,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Container(
          width: 58,
          height: 58,
          decoration: const BoxDecoration(
            color: Color(0xFFEAF2FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_outline,
            color: HomePage.primaryBlue,
            size: 34,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String actionText;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: HomePage.primaryBlue,
          size: 29,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: HomePage.darkBlue,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          actionText,
          style: const TextStyle(
            color: HomePage.primaryBlue,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ClassCard extends StatelessWidget {
  final String title;
  final String teacher;
  final String type;
  final String date;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const _ClassCard({
    required this.title,
    required this.teacher,
    required this.type,
    required this.date,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: HomePage.borderGray,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 42,
            ),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: HomePage.darkBlue,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  teacher,
                  style: const TextStyle(
                    color: HomePage.textGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: HomePage.textGray,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      type,
                      style: const TextStyle(
                        color: HomePage.textGray,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                date,
                style: const TextStyle(
                  color: HomePage.textGray,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                time,
                style: const TextStyle(
                  color: HomePage.primaryBlue,
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          const Icon(
            Icons.chevron_right,
            color: HomePage.primaryBlue,
            size: 34,
          ),
        ],
      ),
    );
  }
}

class _EmptyScheduleCard extends StatelessWidget {
  const _EmptyScheduleCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            color: HomePage.primaryBlue,
            size: 40,
          ),
          const SizedBox(width: 24),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nada agendado para o resto da semana',
                  style: TextStyle(
                    color: HomePage.darkBlue,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Que tal agendar uma nova aula?',
                  style: TextStyle(
                    color: HomePage.textGray,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            decoration: BoxDecoration(
              color: HomePage.primaryBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Agendar aula',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectsList extends StatelessWidget {
  const _SubjectsList();

  @override
  Widget build(BuildContext context) {
    final subjects = [
      _SubjectItem(
        title: 'Matemática',
        icon: Icons.calculate_outlined,
        iconColor: HomePage.primaryBlue,
        backgroundColor: const Color(0xFFEAF2FF),
      ),
      _SubjectItem(
        title: 'Física',
        icon: Icons.science_outlined,
        iconColor: const Color(0xFF18C56E),
        backgroundColor: const Color(0xFFE9F9F0),
      ),
      _SubjectItem(
        title: 'Química',
        icon: Icons.menu_book_outlined,
        iconColor: const Color(0xFF7B3DFF),
        backgroundColor: const Color(0xFFF1EAFE),
      ),
      _SubjectItem(
        title: 'Inglês',
        icon: Icons.translate_outlined,
        iconColor: const Color(0xFFFF9900),
        backgroundColor: const Color(0xFFFFF4DF),
      ),
      _SubjectItem(
        title: 'Programação',
        icon: Icons.code,
        iconColor: HomePage.primaryBlue,
        backgroundColor: const Color(0xFFF0F5FF),
      ),
      _SubjectItem(
        title: 'Redação',
        icon: Icons.edit_outlined,
        iconColor: const Color(0xFFFF3B3B),
        backgroundColor: const Color(0xFFFFEEEE),
      ),
    ];

    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: subjects.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          return subjects[index];
        },
      ),
    );
  }
}

class _SubjectItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const _SubjectItem({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82,
      child: Column(
        children: [
          Container(
            width: 78,
            height: 72,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 38,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: HomePage.darkBlue,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: HomePage.borderGray,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: HomePage.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.history,
              color: HomePage.primaryBlue,
              size: 36,
            ),
          ),
          const SizedBox(width: 22),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Histórico de aulas',
                  style: TextStyle(
                    color: HomePage.darkBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Veja suas aulas anteriores e revisite os detalhes.',
                  style: TextStyle(
                    color: HomePage.textGray,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'Ver histórico',
            style: TextStyle(
              color: HomePage.primaryBlue,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.chevron_right,
            color: HomePage.primaryBlue,
            size: 30,
          ),
        ],
      ),
    );
  }
}