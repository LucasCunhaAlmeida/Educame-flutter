import 'package:flutter/material.dart';

import '../../core/widgets/app_bottom_nav_bar.dart';

class ProfessorDetalhesPage extends StatelessWidget {
  const ProfessorDetalhesPage({super.key});

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
        currentIndex: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TopBar(),
              const SizedBox(height: 26),
              const _ProfessorHeader(),
              const SizedBox(height: 28),
              const _StatsCard(),
              const SizedBox(height: 28),
              const Text(
                'Disciplinas',
                style: TextStyle(
                  color: darkBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              const Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _Chip(text: 'Matemática Básica'),
                  _Chip(text: 'Álgebra'),
                  _Chip(text: 'Geometria'),
                  _Chip(text: 'Trigonometria'),
                  _Chip(text: 'Cálculo I'),
                  _Chip(text: 'Cálculo II'),
                  _Chip(text: 'Estatística'),
                ],
              ),
              const SizedBox(height: 34),
              const Text(
                'Sobre o professor',
                style: TextStyle(
                  color: darkBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Sou apaixonado por ensinar matemática e acredito que todos\n'
                'podem aprender com o método certo. Minhas aulas são dinâmicas,\n'
                'focadas na prática e adaptadas às necessidades de cada aluno.\n'
                'Vamos juntos alcançar seus objetivos!',
                style: TextStyle(
                  color: textGray,
                  fontSize: 16,
                  height: 1.55,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 34),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Avaliações de alunos',
                    style: TextStyle(
                      color: darkBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Ver todas',
                    style: TextStyle(
                      color: primaryBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const _ReviewCard(),
              const SizedBox(height: 22),
              const _InfoCard(),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                height: 62,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF005BFF),
                      Color(0xFF006DFF),
                    ],
                  ),
                ),
                child: ElevatedButton.icon(
                  onPressed: null,
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Agendar aula',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.transparent,
                    disabledForegroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
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
          color: ProfessorDetalhesPage.primaryBlue,
          size: 32,
        ),
        Icon(
          Icons.favorite_border,
          color: ProfessorDetalhesPage.primaryBlue,
          size: 34,
        ),
      ],
    );
  }
}

class _ProfessorHeader extends StatelessWidget {
  const _ProfessorHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            const CircleAvatar(
              radius: 75,
              backgroundColor: Color(0xFFEAF2FF),
              child: Text(
                'R',
                style: TextStyle(
                  color: ProfessorDetalhesPage.darkBlue,
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Positioned(
              right: -2,
              bottom: 8,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF2ECC4A),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 22),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prof. Rafael Lima',
                style: TextStyle(
                  color: ProfessorDetalhesPage.darkBlue,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 12),
              _HeaderBadge(),
              SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    '★',
                    style: TextStyle(
                      color: Color(0xFFF5B301),
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '4,9',
                    style: TextStyle(
                      color: ProfessorDetalhesPage.darkBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '(128 avaliações)',
                    style: TextStyle(
                      color: ProfessorDetalhesPage.textGray,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Professor de matemática com 7 anos de experiência.\n'
                'Aulas personalizadas para todos os níveis.',
                style: TextStyle(
                  color: ProfessorDetalhesPage.textGray,
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: ProfessorDetalhesPage.lightBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.circle,
            size: 10,
            color: ProfessorDetalhesPage.primaryBlue,
          ),
          SizedBox(width: 8),
          Text(
            'Matemática',
            style: TextStyle(
              color: ProfessorDetalhesPage.primaryBlue,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: BoxDecoration(
        border: Border.all(
          color: ProfessorDetalhesPage.borderGray,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.school_outlined,
              title: '7+ anos',
              subtitle: 'de experiência',
            ),
          ),
          _StatDivider(),
          Expanded(
            child: _StatItem(
              icon: Icons.groups_outlined,
              title: '320+',
              subtitle: 'alunos',
            ),
          ),
          _StatDivider(),
          Expanded(
            child: _StatItem(
              icon: Icons.access_time,
              title: '98%',
              subtitle: 'taxa de aprovação',
            ),
          ),
          _StatDivider(),
          Expanded(
            child: _StatItem(
              icon: Icons.verified_user_outlined,
              title: 'Super Professor',
              subtitle: 'na plataforma',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _StatItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: ProfessorDetalhesPage.primaryBlue,
          size: 36,
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ProfessorDetalhesPage.darkBlue,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ProfessorDetalhesPage.textGray,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 116,
      color: ProfessorDetalhesPage.borderGray,
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;

  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: ProfessorDetalhesPage.lightBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: ProfessorDetalhesPage.primaryBlue,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      decoration: BoxDecoration(
        border: Border.all(
          color: ProfessorDetalhesPage.borderGray,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFFEAF2FF),
                child: Text(
                  'M',
                  style: TextStyle(
                    color: ProfessorDetalhesPage.darkBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mariana Silva',
                      style: TextStyle(
                        color: ProfessorDetalhesPage.darkBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '★ ★ ★ ★ ★',
                          style: TextStyle(
                            color: Color(0xFFF5B301),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '5,0',
                          style: TextStyle(
                            color: ProfessorDetalhesPage.textGray,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Text(
                '12/05/2024',
                style: TextStyle(
                  color: ProfessorDetalhesPage.textGray,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Excelente professor! Explica muito bem e tem muita paciência.\n'
              'Minhas notas melhoraram demais!',
              style: TextStyle(
                color: ProfessorDetalhesPage.textGray,
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _Dot(active: true),
              SizedBox(width: 8),
              _Dot(active: false),
              SizedBox(width: 8),
              _Dot(active: false),
              SizedBox(width: 8),
              _Dot(active: false),
              SizedBox(width: 8),
              _Dot(active: false),
            ],
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;

  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: active
            ? ProfessorDetalhesPage.primaryBlue
            : const Color(0xFFD9E0EC),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        border: Border.all(
          color: ProfessorDetalhesPage.borderGray,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: ProfessorDetalhesPage.lightBlue,
                child: Icon(
                  Icons.access_time,
                  color: ProfessorDetalhesPage.primaryBlue,
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Valor por hora',
                    style: TextStyle(
                      color: ProfessorDetalhesPage.textGray,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'R\$ 80,00',
                    style: TextStyle(
                      color: ProfessorDetalhesPage.darkBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            height: 1,
            color: ProfessorDetalhesPage.borderGray,
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: ProfessorDetalhesPage.lightBlue,
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: ProfessorDetalhesPage.primaryBlue,
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Disponibilidade',
                    style: TextStyle(
                      color: ProfessorDetalhesPage.textGray,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Segunda a Sexta',
                    style: TextStyle(
                      color: ProfessorDetalhesPage.darkBlue,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '08:00 - 20:00',
                    style: TextStyle(
                      color: ProfessorDetalhesPage.darkBlue,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}