import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../viewmodel/perfil_viewmodel.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  static const Color primaryBlue = Color(0xFF006DFF);
  static const Color darkBlue = Color(0xFF08295A);
  static const Color textGray = Color(0xFF657491);
  static const Color borderGray = Color(0xFFE4E9F2);
  static const Color lightBlue = Color(0xFFEAF2FF);

  @override
  Widget build(BuildContext context) {
    final dadosUsuario = context
        .select<PerfilViewModel, ({String nome, String email})>(
          (viewModel) =>
              (nome: viewModel.nomeUsuario, email: viewModel.emailUsuario),
        );

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            children: [
              const _TopBar(),

              const SizedBox(height: 34),

              _ProfileHeader(
                nome: dadosUsuario.nome,
                email: dadosUsuario.email,
              ),

              const SizedBox(height: 30),

              const _StatsCard(),

              const SizedBox(height: 34),

              const _ProfileMenuItem(
                icon: Icons.person_outline,
                title: 'Dados pessoais',
                subtitle: 'Gerencie suas informações',
              ),
              const _ProfileMenuItem(
                icon: Icons.notifications_none_outlined,
                title: 'Notificações',
                subtitle: 'Configure suas preferências',
              ),
              const _ProfileMenuItem(
                icon: Icons.security_outlined,
                title: 'Segurança',
                subtitle: 'Senha e privacidade',
              ),
              const _ProfileMenuItem(
                icon: Icons.credit_card_outlined,
                title: 'Pagamentos',
                subtitle: 'Métodos de pagamento',
              ),
              const _ProfileMenuItem(
                icon: Icons.help_outline,
                title: 'Ajuda e suporte',
                subtitle: 'Dúvidas e atendimento',
              ),
              const _ProfileMenuItem(
                icon: Icons.logout_outlined,
                title: 'Sair da conta',
                subtitle: 'Encerrar sessão',
              ),

              const SizedBox(height: 24),

              const Text(
                'Versão 1.0.0',
                style: TextStyle(
                  color: textGray,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 8),
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
        Text(
          'Perfil',
          style: TextStyle(
            color: PerfilPage.darkBlue,
            fontSize: 31,
            fontWeight: FontWeight.w800,
          ),
        ),
        Icon(Icons.edit_square, color: PerfilPage.primaryBlue, size: 30),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String nome;
  final String email;

  const _ProfileHeader({required this.nome, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 132,
              height: 132,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: PerfilPage.lightBlue,
              ),
              child: const Icon(
                Icons.person,
                color: PerfilPage.primaryBlue,
                size: 78,
              ),
            ),

            Positioned(
              right: -2,
              bottom: 8,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: PerfilPage.primaryBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 5),
                ),
                child: const Icon(
                  Icons.photo_camera,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 22),

        Text(
          nome,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: PerfilPage.darkBlue,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          email,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: PerfilPage.textGray,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
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
        color: Colors.white,
        border: Border.all(color: PerfilPage.borderGray, width: 1.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.calendar_today_outlined,
              number: '12',
              label: 'Aulas agendadas',
            ),
          ),
          _VerticalDivider(),
          Expanded(
            child: _StatItem(
              icon: Icons.access_time,
              number: '24',
              label: 'Horas reservadas',
            ),
          ),
          _VerticalDivider(),
          Expanded(
            child: _StatItem(
              icon: Icons.menu_book_outlined,
              number: '5',
              label: 'Professores',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String number;
  final String label;

  const _StatItem({
    required this.icon,
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: PerfilPage.primaryBlue, size: 34),
        const SizedBox(height: 18),
        Text(
          number,
          style: const TextStyle(
            color: PerfilPage.darkBlue,
            fontSize: 31,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: PerfilPage.textGray,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 94, color: PerfilPage.borderGray);
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 98),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: PerfilPage.borderGray, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: PerfilPage.lightBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: PerfilPage.primaryBlue, size: 30),
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
                    color: PerfilPage.darkBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: PerfilPage.textGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          const Icon(Icons.chevron_right, color: PerfilPage.textGray, size: 32),
        ],
      ),
    );
  }
}
