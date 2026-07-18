import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/perfil_repository.dart';
import '../../login/view/login_page.dart';
import '../view/dados_pessoais_page.dart';
import '../viewmodel/perfil_viewmodel.dart';
import 'seguranca_page.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  static const Color primaryBlue = Color(0xFF006DFF);
  static const Color darkBlue = Color(0xFF08295A);
  static const Color textGray = Color(0xFF657491);
  static const Color borderGray = Color(0xFFE4E9F2);
  static const Color lightBlue = Color(0xFFEAF2FF);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late final PerfilViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = PerfilViewModel(
      authRepository: AuthRepository(),
      perfilRepository: PerfilRepository(),
    );
    _viewModel.carregarDadosPessoais();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    await _viewModel.logout();

    if (!mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  void _abrirDadosPessoais() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider<PerfilViewModel>.value(
          value: _viewModel,
          child: const DadosPessoaisPage(),
        ),
      ),
    ).then((_) {
      _viewModel.carregarDadosPessoais();
    });
  }

  void _abrirSeguranca() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider<PerfilViewModel>.value(
          value: _viewModel,
          child: const SegurancaPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: const AppBottomNavBar(
            currentIndex: 3,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                children: [
                  const _TopBar(),
                  const SizedBox(height: 34),
                  _ProfileHeader(
                    nome: _viewModel.nomeUsuario,
                    email: _viewModel.emailUsuario,
                    fotoPerfil: _viewModel.usuario?.fotoPerfil,
                  ),
                  const SizedBox(height: 30),
                  const _StatsCard(),
                  const SizedBox(height: 34),
                  _ProfileMenuItem(
                    icon: Icons.person_outline,
                    title: 'Dados pessoais',
                    subtitle: 'Gerencie suas informacoes',
                    onTap: _abrirDadosPessoais,
                  ),
                  _ProfileMenuItem(
                    icon: Icons.security_outlined,
                    title: 'Seguranca',
                    subtitle: 'Alterar senha',
                    onTap: _abrirSeguranca,
                  ),
                  _ProfileMenuItem(
                    icon: Icons.logout_outlined,
                    title: 'Sair da conta',
                    subtitle: 'Encerrar sessao',
                    onTap: _logout,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Versao 1.0.0',
                    style: TextStyle(
                      color: PerfilPage.textGray,
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
      },
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
        Icon(
          Icons.edit_square,
          color: PerfilPage.primaryBlue,
          size: 30,
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String nome;
  final String email;
  final String? fotoPerfil;

  const _ProfileHeader({
    required this.nome,
    required this.email,
    required this.fotoPerfil,
  });

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
              child: fotoPerfil == null || fotoPerfil!.isEmpty
                  ? const Icon(
                      Icons.person,
                      color: PerfilPage.primaryBlue,
                      size: 78,
                    )
                  : ClipOval(
                      child: Image.file(
                        File(fotoPerfil!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            color: PerfilPage.primaryBlue,
                            size: 78,
                          );
                        },
                      ),
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
                  border: Border.all(
                    color: Colors.white,
                    width: 5,
                  ),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: PerfilPage.borderGray,
          width: 1.2,
        ),
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
        Icon(
          icon,
          color: PerfilPage.primaryBlue,
          size: 34,
        ),
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
    return Container(
      width: 1,
      height: 94,
      color: PerfilPage.borderGray,
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 98,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: PerfilPage.borderGray,
              width: 1,
            ),
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
              child: Icon(
                icon,
                color: PerfilPage.primaryBlue,
                size: 30,
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
            const Icon(
              Icons.chevron_right,
              color: PerfilPage.textGray,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
