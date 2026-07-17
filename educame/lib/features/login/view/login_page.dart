import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../cadastro/view/cadastro_page.dart';
import '../../home/home_page.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const Color darkBlue = Color(0xFF08295A);
  static const Color primaryBlue = Color(0xFF005BFF);
  static const Color textGray = Color(0xFF657491);
  static const Color borderGray = Color(0xFFD3DBEA);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  late final LoginViewModel _viewModel;

  bool _carregando = false;
  bool _mostrarSenha = false;

  @override
  void initState() {
    super.initState();

    _viewModel = LoginViewModel(
      authRepository: AuthRepository(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();

    super.dispose();
  }

  Future<void> _entrar() async {
    if (_emailController.text.trim().isEmpty) {
      _mostrarErro('Informe o e-mail.');
      return;
    }

    if (_senhaController.text.isEmpty) {
      _mostrarErro('Informe a senha.');
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      await _viewModel.login(
        email: _emailController.text.trim(),
        senha: _senhaController.text,
      );

      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      final mensagemErro = error
          .toString()
          .replaceFirst('Exception: ', '');

      _mostrarErro(mensagemErro);
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
      ),
    );
  }

  void _abrirCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CadastroPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomWaves(),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                32,
                90,
                32,
                180,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: _LogoArea(),
                  ),

                  const SizedBox(height: 90),

                  const Text(
                    'Bem-vindo de volta!',
                    style: TextStyle(
                      color: LoginPage.darkBlue,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Faça login para continuar sua jornada.',
                    style: TextStyle(
                      color: LoginPage.textGray,
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 54),

                  const _InputLabel(
                    text: 'E-mail',
                  ),

                  const SizedBox(height: 12),

                  _CustomTextField(
                    controller: _emailController,
                    hintText: 'seu@email.com',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 38),

                  const _InputLabel(
                    text: 'Senha',
                  ),

                  const SizedBox(height: 12),

                  _CustomTextField(
                    controller: _senhaController,
                    hintText: 'Sua senha',
                    icon: Icons.lock_outline,
                    obscureText: !_mostrarSenha,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _mostrarSenha = !_mostrarSenha;
                        });
                      },
                      icon: Icon(
                        _mostrarSenha
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: LoginPage.textGray,
                        size: 28,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Funcionalidade de recuperação
                        // de senha será implementada depois.
                      },
                      child: const Text(
                        'Esqueceu sua senha?',
                        style: TextStyle(
                          color: LoginPage.primaryBlue,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 44),

                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF005BFF),
                            Color(0xFF006DFF),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: LoginPage.primaryBlue
                                .withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _carregando ? null : _entrar,
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor:
                              Colors.transparent,
                          disabledForegroundColor:
                              Colors.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _carregando
                            ? const SizedBox(
                                width: 26,
                                height: 26,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                'Entrar',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 46),

                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        const Text(
                          'Ainda não tem uma conta? ',
                          style: TextStyle(
                            color: LoginPage.textGray,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        GestureDetector(
                          onTap: _abrirCadastro,
                          child: const Text(
                            'Criar conta',
                            style: TextStyle(
                              color: LoginPage.primaryBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoArea extends StatelessWidget {
  const _LogoArea();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.menu_book_rounded,
          color: LoginPage.primaryBlue,
          size: 76,
        ),

        const SizedBox(height: 10),

        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Ensina',
                style: TextStyle(
                  color: LoginPage.darkBlue,
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              TextSpan(
                text: 'Me',
                style: TextStyle(
                  color: LoginPage.primaryBlue,
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Aprenda hoje, transforme o amanhã.',
          style: TextStyle(
            color: LoginPage.textGray,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _InputLabel extends StatelessWidget {
  final String text;

  const _InputLabel({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: LoginPage.darkBlue,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;

  const _CustomTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: LoginPage.darkBlue,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: LoginPage.textGray,
            fontSize: 18,
          ),

          prefixIcon: Icon(
            icon,
            color: LoginPage.primaryBlue,
            size: 28,
          ),

          suffixIcon: suffixIcon,

          filled: true,
          fillColor: Colors.white,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: LoginPage.borderGray,
              width: 1.5,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: LoginPage.primaryBlue,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomWaves extends StatelessWidget {
  const _BottomWaves();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      width: double.infinity,
      child: CustomPaint(
        painter: _WavesPainter(),
      ),
    );
  }
}

class _WavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintOne = Paint()
      ..color = const Color(0xFFE5EFFF)
      ..style = PaintingStyle.fill;

    final pathOne = Path()
      ..moveTo(0, size.height * 0.25)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.45,
        size.width * 0.25,
        size.height * 0.95,
        size.width * 0.55,
        size.height * 0.85,
      )
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.78,
        size.width * 0.78,
        size.height * 0.35,
        size.width,
        size.height * 0.45,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(pathOne, paintOne);

    final paintTwo = Paint()
      ..color = const Color(0xFFD8E8FF).withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;

    final pathTwo = Path()
      ..moveTo(0, size.height * 0.65)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.5,
        size.width * 0.38,
        size.height * 0.65,
        size.width * 0.55,
        size.height * 0.78,
      )
      ..cubicTo(
        size.width * 0.75,
        size.height * 0.95,
        size.width * 0.82,
        size.height * 0.25,
        size.width,
        size.height * 0.45,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(pathTwo, paintTwo);
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}