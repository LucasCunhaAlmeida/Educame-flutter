import 'package:flutter/material.dart';

import '../../core/widgets/app_bottom_nav_bar.dart';

class AgendarAulasPage extends StatelessWidget {
  const AgendarAulasPage({super.key});

  static const Color primaryBlue = Color(0xFF006DFF);
  static const Color darkBlue = Color(0xFF08295A);
  static const Color textGray = Color(0xFF657491);
  static const Color borderGray = Color(0xFFE4E9F2);
  static const Color lightBlue = Color(0xFFEAF2FF);
  static const Color green = Color(0xFF18C56E);
  static const Color purple = Color(0xFF7B3DFF);
  static const Color orange = Color(0xFFFF9900);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const AppBottomNavBar(
        currentIndex: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Header(),
              const SizedBox(height: 38),
              const _SearchArea(),
              const SizedBox(height: 28),
              const _ProfessorCard(
                name: 'Prof. Rafael Lima',
                subject: 'Matemática',
                description:
                    'Professor de Matemática com 8 anos\nde experiência no ensino médio e\npré-vestibular.',
                price: 'R\$ 80,00',
                rating: '4,9',
                reviews: '(128 avaliações)',
                avatarText: 'R',
                avatarBackground: Color(0xFFEAF2FF),
                subjectColor: primaryBlue,
                subjectBackground: lightBlue,
              ),
              const SizedBox(height: 18),
              const _ProfessorCard(
                name: 'Profa. Camila Souza',
                subject: 'Física',
                description:
                    'Aulas dinâmicas e personalizadas\npara ensino médio, ENEM e\nvestibulares.',
                price: 'R\$ 75,00',
                rating: '4,9',
                reviews: '(96 avaliações)',
                avatarText: 'C',
                avatarBackground: Color(0xFFE9F9F0),
                subjectColor: green,
                subjectBackground: Color(0xFFE3F8EC),
              ),
              const SizedBox(height: 18),
              const _ProfessorCard(
                name: 'Prof. João Pedro',
                subject: 'Química',
                description:
                    'Mestre em Química com foco em\nexplicações claras e resolução\nde exercícios.',
                price: 'R\$ 70,00',
                rating: '4,8',
                reviews: '(87 avaliações)',
                avatarText: 'J',
                avatarBackground: Color(0xFFF1EAFE),
                subjectColor: purple,
                subjectBackground: Color(0xFFF0E8FF),
              ),
              const SizedBox(height: 18),
              const _ProfessorCard(
                name: 'Profa. Mariana Alves',
                subject: 'Inglês',
                description:
                    'Professora de Inglês com certificação\ninternacional e experiência com\ntodos os níveis.',
                price: 'R\$ 65,00',
                rating: '4,9',
                reviews: '(112 avaliações)',
                avatarText: 'M',
                avatarBackground: Color(0xFFFFF4DF),
                subjectColor: orange,
                subjectBackground: Color(0xFFFFF0D8),
              ),
              const SizedBox(height: 18),
              const _ProfessorCard(
                name: 'Prof. Lucas Martins',
                subject: 'Programação',
                description:
                    'Desenvolvedor e professor com\nexperiência em diversas linguagens\ne tecnologias.',
                price: 'R\$ 90,00',
                rating: '4,8',
                reviews: '(74 avaliações)',
                avatarText: 'L',
                avatarBackground: Color(0xFFEAF2FF),
                subjectColor: primaryBlue,
                subjectBackground: lightBlue,
              ),
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
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Agendar aulas',
              style: TextStyle(
                color: AgendarAulasPage.darkBlue,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Encontre o professor ideal para você.',
              style: TextStyle(
                color: AgendarAulasPage.textGray,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 31,
          backgroundColor: AgendarAulasPage.lightBlue,
          child: Icon(
            Icons.person_outline,
            color: AgendarAulasPage.primaryBlue,
            size: 36,
          ),
        ),
      ],
    );
  }
}

class _SearchArea extends StatelessWidget {
  const _SearchArea();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(
                color: AgendarAulasPage.borderGray,
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.search,
                  color: AgendarAulasPage.textGray,
                  size: 30,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Buscar por disciplina ou professor...',
                    style: TextStyle(
                      color: Color(0xFF8A96AD),
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 18),
        const Row(
          children: [
            Icon(
              Icons.tune,
              color: AgendarAulasPage.primaryBlue,
              size: 28,
            ),
            SizedBox(width: 10),
            Text(
              'Filtros',
              style: TextStyle(
                color: AgendarAulasPage.primaryBlue,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfessorCard extends StatelessWidget {
  final String name;
  final String subject;
  final String description;
  final String price;
  final String rating;
  final String reviews;
  final String avatarText;
  final Color avatarBackground;
  final Color subjectColor;
  final Color subjectBackground;

  const _ProfessorCard({
    required this.name,
    required this.subject,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.avatarText,
    required this.avatarBackground,
    required this.subjectColor,
    required this.subjectBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AgendarAulasPage.borderGray,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 58,
            backgroundColor: avatarBackground,
            child: Text(
              avatarText,
              style: const TextStyle(
                color: AgendarAulasPage.darkBlue,
                fontSize: 40,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: AgendarAulasPage.darkBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.verified,
                      color: AgendarAulasPage.primaryBlue,
                      size: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _SubjectBadge(
                  text: subject,
                  color: subjectColor,
                  backgroundColor: subjectBackground,
                ),
                const SizedBox(height: 14),
                Text(
                  description,
                  style: const TextStyle(
                    color: AgendarAulasPage.textGray,
                    fontSize: 15,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Text(
                      '★ ★ ★ ★ ★',
                      style: TextStyle(
                        color: Color(0xFFF5B301),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$rating $reviews',
                      style: const TextStyle(
                        color: AgendarAulasPage.textGray,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 1,
            height: 150,
            color: AgendarAulasPage.borderGray,
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  price,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AgendarAulasPage.primaryBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'por hora',
                  style: TextStyle(
                    color: AgendarAulasPage.textGray,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AgendarAulasPage.primaryBlue,
                      width: 1.3,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Agendar',
                    style: TextStyle(
                      color: AgendarAulasPage.primaryBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color backgroundColor;

  const _SubjectBadge({
    required this.text,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}