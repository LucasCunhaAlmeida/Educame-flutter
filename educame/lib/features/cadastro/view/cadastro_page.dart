import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository.dart';
import '../viewmodels/cadastro_viewmodel.dart';

class CadastroPage extends StatefulWidget {
  static const primaryBlue = Color(0xFF2563EB);
  static const darkBlue = Color(0xFF172554);
  static const textGray = Color(0xFF64748B);
  static const borderGray = Color(0xFFCBD5E1);

  const CadastroPage({
    super.key,
  });

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  late final CadastroViewModel _viewModel;

  bool _mostrarSenha = false;
  bool _carregando = false;

  @override
  void initState() {
    super.initState();

    _viewModel = CadastroViewModel(
      authRepository: AuthRepository(),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _dataNascimentoController.dispose();
    _emailController.dispose();
    _senhaController.dispose();

    super.dispose();
  }

  Future<void> _selecionarDataNascimento() async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (dataSelecionada == null) {
      return;
    }

    final dia = dataSelecionada.day.toString().padLeft(2, '0');
    final mes = dataSelecionada.month.toString().padLeft(2, '0');
    final ano = dataSelecionada.year;

    _dataNascimentoController.text = '$dia/$mes/$ano';
  }

  DateTime _converterData(String data) {
    final partes = data.split('/');

    return DateTime(
      int.parse(partes[2]),
      int.parse(partes[1]),
      int.parse(partes[0]),
    );
  }

  Future<void> _criarConta() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      final dataNascimento = _converterData(
        _dataNascimentoController.text,
      );

      await _viewModel.cadastrar(
        nome: _nomeController.text.trim(),
        sobrenome: _sobrenomeController.text.trim(),
        dataNascimento: dataNascimento,
        email: _emailController.text.trim(),
        senha: _senhaController.text,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Conta criada com sucesso!',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) {
        return;
      }

      final mensagemErro = error
          .toString()
          .replaceFirst('Exception: ', '');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagemErro),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _LogoArea(),

                      const SizedBox(height: 40),

                      const _InputLabel(
                        text: 'Nome',
                      ),

                      const SizedBox(height: 8),

                      _CustomTextField(
                        controller: _nomeController,
                        hintText: 'Digite seu nome',
                        icon: Icons.person_outline_rounded,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe seu nome';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      const _InputLabel(
                        text: 'Sobrenome',
                      ),

                      const SizedBox(height: 8),

                      _CustomTextField(
                        controller: _sobrenomeController,
                        hintText: 'Digite seu sobrenome',
                        icon: Icons.person_outline_rounded,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe seu sobrenome';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      const _InputLabel(
                        text: 'Data de nascimento',
                      ),

                      const SizedBox(height: 8),

                      _CustomTextField(
                        controller: _dataNascimentoController,
                        hintText: 'Selecione sua data de nascimento',
                        icon: Icons.calendar_month_outlined,
                        readOnly: true,
                        onTap: _selecionarDataNascimento,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe sua data de nascimento';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      const _InputLabel(
                        text: 'E-mail',
                      ),

                      const SizedBox(height: 8),

                      _CustomTextField(
                        controller: _emailController,
                        hintText: 'seu@email.com',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe seu e-mail';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      const _InputLabel(
                        text: 'Senha',
                      ),

                      const SizedBox(height: 8),

                      _CustomTextField(
                        controller: _senhaController,
                        hintText: 'Digite sua senha',
                        icon: Icons.lock_outline_rounded,
                        obscureText: !_mostrarSenha,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _mostrarSenha
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: CadastroPage.primaryBlue,
                          ),
                          onPressed: () {
                            setState(() {
                              _mostrarSenha = !_mostrarSenha;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe sua senha';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _carregando
                              ? null
                              : _criarConta,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CadastroPage.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _carregando
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Criar conta',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const _BottomWaves(),
          ],
        ),
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
          color: CadastroPage.primaryBlue,
          size: 76,
        ),

        const SizedBox(height: 10),

        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Ensina',
                style: TextStyle(
                  color: CadastroPage.darkBlue,
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              TextSpan(
                text: 'Me',
                style: TextStyle(
                  color: CadastroPage.primaryBlue,
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
            color: CadastroPage.textGray,
            fontSize: 18,
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
        color: CadastroPage.darkBlue,
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
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _CustomTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.suffixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        color: CadastroPage.darkBlue,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: CadastroPage.textGray,
          fontSize: 18,
        ),
        prefixIcon: Icon(
          icon,
          color: CadastroPage.primaryBlue,
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
            color: CadastroPage.borderGray,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: CadastroPage.primaryBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
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
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paintOne = Paint()
      ..color = const Color(0xFFE5EFFF)
      ..style = PaintingStyle.fill;

    final pathOne = Path()
      ..moveTo(
        0,
        size.height * 0.25,
      )
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
      ..lineTo(
        size.width,
        size.height,
      )
      ..lineTo(
        0,
        size.height,
      )
      ..close();

    canvas.drawPath(
      pathOne,
      paintOne,
    );

    final paintTwo = Paint()
      ..color = const Color(0xFFD8E8FF).withValues(
        alpha: 0.75,
      )
      ..style = PaintingStyle.fill;

    final pathTwo = Path()
      ..moveTo(
        0,
        size.height * 0.65,
      )
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
      ..lineTo(
        size.width,
        size.height,
      )
      ..lineTo(
        0,
        size.height,
      )
      ..close();

    canvas.drawPath(
      pathTwo,
      paintTwo,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}