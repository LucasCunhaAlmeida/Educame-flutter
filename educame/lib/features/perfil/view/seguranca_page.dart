import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/perfil_viewmodel.dart';
import 'dados_pessoais_page.dart';

class SegurancaPage extends StatefulWidget {
  const SegurancaPage({super.key});

  @override
  State<SegurancaPage> createState() => _SegurancaPageState();
}

class _SegurancaPageState extends State<SegurancaPage> {
  final _novaSenhaController = TextEditingController();
  bool _salvando = false;
  bool _ocultarSenha = true;

  @override
  void dispose() {
    _novaSenhaController.dispose();
    super.dispose();
  }

  Future<void> _salvarSenha() async {
    final novaSenha = _novaSenhaController.text.trim();

    if (novaSenha.isEmpty) {
      _mostrarMensagem('Informe a nova senha.');
      return;
    }

    setState(() {
      _salvando = true;
    });

    try {
      await context.read<PerfilViewModel>().salvarNovaSenha(novaSenha);

      if (!mounted) {
        return;
      }

      _novaSenhaController.clear();
      _mostrarMensagem('Senha atualizada com sucesso!');
    } catch (e) {
      if (!mounted) {
        return;
      }

      _mostrarMensagem('Erro ao salvar senha: $e');
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: DadosPessoaisPage.darkBlue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Segurança',
          style: TextStyle(
            color: DadosPessoaisPage.darkBlue,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nova senha',
                style: TextStyle(
                  color: DadosPessoaisPage.darkBlue,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _novaSenhaController,
                obscureText: _ocultarSenha,
                decoration: InputDecoration(
                  labelText: 'Digite a nova senha',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: DadosPessoaisPage.primaryBlue,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _ocultarSenha = !_ocultarSenha;
                      });
                    },
                    icon: Icon(
                      _ocultarSenha
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _salvando ? null : _salvarSenha,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DadosPessoaisPage.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: _salvando
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
