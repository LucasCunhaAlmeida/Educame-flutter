import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_router.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';

class MensagensPage extends StatelessWidget {
  const MensagensPage({super.key});

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
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 34, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Header(),

              const SizedBox(height: 54),

              const _SearchArea(),

              const SizedBox(height: 28),

              const _ConversationCard(
                name: 'Prof. Rafael Lima',
                subject: 'Matemática',
                subjectColor: primaryBlue,
                subjectBackground: lightBlue,
                message:
                    'Olá, Lucas! Tudo bem? Lembrando que\nnossa aula é amanhã às 14:00.',
                time: '09:15',
                unreadCount: '1',
                avatarText: 'R',
                avatarBackground: Color(0xFFDDEAFF),
                online: true,
              ),

              const SizedBox(height: 14),

              const _ConversationCard(
                name: 'Profa. Camila Souza',
                subject: 'Física',
                subjectColor: green,
                subjectBackground: Color(0xFFE3F8EC),
                message:
                    'Lucas, segue o material que comentei\nna nossa última aula.',
                time: 'Ontem',
                unreadCount: '2',
                avatarText: 'C',
                avatarBackground: Color(0xFFE4F8EB),
                online: true,
              ),

              const SizedBox(height: 14),

              const _ConversationCard(
                name: 'Prof. João Pedro',
                subject: 'Química',
                subjectColor: purple,
                subjectBackground: Color(0xFFF0E8FF),
                message: 'Perfeito! Qualquer dúvida, me chama\npor aqui.',
                time: 'Terça-feira',
                avatarText: 'J',
                avatarBackground: Color(0xFFF1EAFE),
                online: false,
              ),

              const SizedBox(height: 14),

              const _ConversationCard(
                name: 'Profa. Mariana Alves',
                subject: 'Inglês',
                subjectColor: orange,
                subjectBackground: Color(0xFFFFF0D8),
                message:
                    'Oi Lucas! Vou te enviar alguns exercícios\nextras para praticar.',
                time: 'Segunda-feira',
                avatarText: 'M',
                avatarBackground: Color(0xFFFFF4DF),
                online: false,
              ),

              const SizedBox(height: 14),

              const _ConversationCard(
                name: 'Prof. Lucas Martins',
                subject: 'Programação',
                subjectColor: primaryBlue,
                subjectBackground: lightBlue,
                message:
                    'Boa tarde, Lucas! Aqui está o link do\nrepositório que usamos em aula.',
                time: '19/05',
                avatarText: 'L',
                avatarBackground: Color(0xFFEAF2FF),
                online: false,
              ),

              const SizedBox(height: 32),

              const _EmptyConversationCard(),

              const SizedBox(height: 18),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mensagens',
                style: TextStyle(
                  color: MensagensPage.darkBlue,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Converse com seus professores.',
                style: TextStyle(
                  color: MensagensPage.textGray,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        CircleAvatar(
          radius: 31,
          backgroundColor: MensagensPage.lightBlue,
          child: Icon(
            Icons.person_outline,
            color: MensagensPage.primaryBlue,
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
            padding: const EdgeInsets.symmetric(horizontal: 22),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: MensagensPage.borderGray, width: 1.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: MensagensPage.textGray, size: 30),
                SizedBox(width: 18),
                Expanded(
                  child: Text(
                    'Buscar conversa...',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF8A96AD),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 18),

        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: MensagensPage.borderGray, width: 1.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.tune,
            color: MensagensPage.primaryBlue,
            size: 30,
          ),
        ),
      ],
    );
  }
}

class _ConversationCard extends StatelessWidget {
  final String name;
  final String subject;
  final Color subjectColor;
  final Color subjectBackground;
  final String message;
  final String time;
  final String avatarText;
  final Color avatarBackground;
  final bool online;
  final String? unreadCount;

  const _ConversationCard({
    required this.name,
    required this.subject,
    required this.subjectColor,
    required this.subjectBackground,
    required this.message,
    required this.time,
    required this.avatarText,
    required this.avatarBackground,
    required this.online,
    this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: MensagensPage.borderGray, width: 1.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(
            text: avatarText,
            backgroundColor: avatarBackground,
            online: online,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: MensagensPage.darkBlue,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: const TextStyle(
                        color: MensagensPage.textGray,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
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
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MensagensPage.textGray,
                    fontSize: 16,
                    height: 1.35,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (unreadCount != null) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: MensagensPage.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        unreadCount!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final bool online;

  const _Avatar({
    required this.text,
    required this.backgroundColor,
    required this.online,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: backgroundColor,
          child: Text(
            text,
            style: const TextStyle(
              color: MensagensPage.darkBlue,
              fontSize: 34,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        Positioned(
          right: 1,
          bottom: 5,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: online ? const Color(0xFF2ECC4A) : const Color(0xFFC8D0DD),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
          ),
        ),
      ],
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
      height: 27,
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyConversationCard extends StatelessWidget {
  const _EmptyConversationCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MensagensPage.lightBlue,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.go(AppRoutes.professores),
        child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MensagensPage.lightBlue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.chat_bubble,
                  color: MensagensPage.primaryBlue,
                  size: 30,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Não encontrou uma conversa?',
                      style: TextStyle(
                        color: MensagensPage.darkBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Agende uma aula com um professor para iniciar uma conversa.',
                      style: TextStyle(
                        color: MensagensPage.textGray,
                        fontSize: 15,
                        height: 1.35,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: MensagensPage.primaryBlue, width: 1.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Agendar aula',
              style: TextStyle(
                color: MensagensPage.primaryBlue,
                fontSize: 15,
                fontWeight: FontWeight.w700,
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
