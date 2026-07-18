import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../data/models/endereco.dart';
import '../viewmodel/perfil_viewmodel.dart';

class DadosPessoaisPage extends StatefulWidget {
  const DadosPessoaisPage({super.key});

  static const Color primaryBlue = Color(0xFF006DFF);
  static const Color darkBlue = Color(0xFF08295A);
  static const Color textGray = Color(0xFF657491);
  static const Color borderGray = Color(0xFFE4E9F2);
  static const Color lightBlue = Color(0xFFEAF2FF);

  @override
  State<DadosPessoaisPage> createState() => _DadosPessoaisPageState();
}

class _DadosPessoaisPageState extends State<DadosPessoaisPage> {
  static const List<String> _opcoesGenero = [
    'Homem',
    'Mulher',
    'Transgênero',
    'Não-binário',
    'Agênero',
    'Gênero fluido',
    'Bigênero',
    'Pangênero',
  ];

  bool _alterandoEndereco = false;
  final ImagePicker _imagePicker = ImagePicker();

  late final TextEditingController _cpfController;
  late final TextEditingController _ruaController;
  late final TextEditingController _numeroController;
  late final TextEditingController _complementoController;
  late final TextEditingController _bairroController;
  late final TextEditingController _cidadeController;
  late final TextEditingController _estadoController;
  late final TextEditingController _cepController;
  late final TextEditingController _paisController;

  @override
  void initState() {
    super.initState();

    _cpfController = TextEditingController();
    _ruaController = TextEditingController();
    _numeroController = TextEditingController();
    _complementoController = TextEditingController();
    _bairroController = TextEditingController();
    _cidadeController = TextEditingController();
    _estadoController = TextEditingController();
    _cepController = TextEditingController();
    _paisController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<PerfilViewModel>();

      viewModel.carregarDadosPessoais().then((_) {
        if (!mounted) {
          return;
        }

        final endereco = viewModel.endereco;

        if (endereco != null) {
          _ruaController.text = endereco.rua;
          _numeroController.text = endereco.numero;
          _complementoController.text = endereco.complemento ?? '';
          _bairroController.text = endereco.bairro;
          _cidadeController.text = endereco.cidade;
          _estadoController.text = endereco.estado;
          _cepController.text = endereco.cep;
          _paisController.text = endereco.pais;
        }
      });
    });
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _cepController.dispose();
    _paisController.dispose();

    super.dispose();
  }

  void _alterarEndereco() {
    setState(() {
      _alterandoEndereco = !_alterandoEndereco;
    });
  }

  Future<void> _abrirCadastroCpf() async {
    _cpfController.clear();

    final cpf = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cadastrar CPF',
                style: TextStyle(
                  color: DadosPessoaisPage.darkBlue,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _cpfController,
                autofocus: true,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: DadosPessoaisPage.darkBlue,
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  labelText: 'CPF',
                  prefixIcon: const Icon(
                    Icons.badge_outlined,
                    color: DadosPessoaisPage.primaryBlue,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: DadosPessoaisPage.borderGray,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: DadosPessoaisPage.borderGray,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: DadosPessoaisPage.primaryBlue,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                      },
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                          sheetContext,
                          _cpfController.text.trim(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DadosPessoaisPage.primaryBlue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (cpf == null || cpf.isEmpty || !mounted) {
      return;
    }

    final viewModel = context.read<PerfilViewModel>();

    try {
      await viewModel.salvarCpf(cpf);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('CPF salvo com sucesso!'),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar CPF: $e'),
        ),
      );
    }
  }

  Future<void> _abrirSeletorGenero(String? generoAtual) async {
    final generoSelecionado = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        var generoTemporario = _opcoesGenero.contains(generoAtual)
            ? generoAtual
            : _opcoesGenero.first;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Alterar gênero'),
              content: DropdownButtonFormField<String>(
                value: generoTemporario,
                decoration: const InputDecoration(
                  labelText: 'Gênero',
                  prefixIcon: Icon(Icons.wc_outlined),
                ),
                items: _opcoesGenero
                    .map(
                      (genero) => DropdownMenuItem<String>(
                        value: genero,
                        child: Text(genero),
                      ),
                    )
                    .toList(),
                onChanged: (genero) {
                  if (genero == null) {
                    return;
                  }

                  setDialogState(() {
                    generoTemporario = genero;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, generoTemporario);
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (generoSelecionado == null ||
        generoSelecionado == generoAtual ||
        !mounted) {
      return;
    }

    final viewModel = context.read<PerfilViewModel>();

    try {
      await viewModel.salvarGenero(generoSelecionado);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gênero salvo com sucesso!'),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar gênero: $e'),
        ),
      );
    }
  }

  Future<void> _salvarEndereco() async {
    final viewModel = context.read<PerfilViewModel>();

    try {
      await viewModel.salvarEndereco(
        rua: _ruaController.text.trim(),
        numero: _numeroController.text.trim(),
        complemento: _complementoController.text.trim().isEmpty
            ? null
            : _complementoController.text.trim(),
        bairro: _bairroController.text.trim(),
        cidade: _cidadeController.text.trim(),
        estado: _estadoController.text.trim(),
        cep: _cepController.text.trim(),
        pais: _paisController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _alterandoEndereco = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Endereço salvo com sucesso!',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao salvar endereço: $e',
          ),
        ),
      );
    }
  }

  void _alterarFotoPerfil() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'A seleção de imagem será implementada posteriormente.',
        ),
      ),
    );
  }

  Future<void> _selecionarFotoPerfil() async {
    try {
      final imagemSelecionada = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (imagemSelecionada == null || !mounted) {
        return;
      }

      final diretorioDocumentos = await getApplicationDocumentsDirectory();
      final diretorioFotos = Directory(
        path.join(diretorioDocumentos.path, 'profile_images'),
      );

      if (!await diretorioFotos.exists()) {
        await diretorioFotos.create(recursive: true);
      }

      final extensao = path.extension(imagemSelecionada.path);
      final nomeArquivo =
          'perfil_${DateTime.now().millisecondsSinceEpoch}$extensao';
      final destino = path.join(diretorioFotos.path, nomeArquivo);

      await File(imagemSelecionada.path).copy(destino);

      if (!mounted) {
        return;
      }

      await context.read<PerfilViewModel>().salvarFotoPerfil(destino);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto de perfil atualizada!'),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao alterar foto: $e'),
        ),
      );
    }
  }

  String _formatarData(DateTime? data) {
    if (data == null) {
      return 'Não informado';
    }

    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');

    return '$dia/$mes/${data.year}';
  }

  String _valorOuNaoInformado(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Não informado';
    }

    return valor;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PerfilViewModel>(
      builder: (context, viewModel, child) {
        final usuario = viewModel.usuario;
        final endereco = viewModel.endereco;
        final possuiCpf = usuario?.cpf?.trim().isNotEmpty ?? false;

        if (viewModel.carregando) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

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
              'Dados pessoais',
              style: TextStyle(
                color: DadosPessoaisPage.darkBlue,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileImageSection(
                    fotoPerfil: usuario?.fotoPerfil,
                    onAlterarFoto: _selecionarFotoPerfil,
                  ),

                  const SizedBox(height: 36),

                  const _SectionTitle(
                    title: 'Informações pessoais',
                  ),

                  const SizedBox(height: 16),

                  _InfoCard(
                    children: [
                      _InfoItem(
                        icon: Icons.person_outline,
                        label: 'Nome completo',
                        value: usuario == null
                            ? 'Não informado'
                            : '${usuario.nome} ${usuario.sobrenome}',
                      ),

                      const _InfoDivider(),

                      _InfoItem(
                        icon: Icons.email_outlined,
                        label: 'E-mail',
                        value: _valorOuNaoInformado(
                          usuario?.email,
                        ),
                      ),

                      const _InfoDivider(),

                      _InfoItem(
                        icon: Icons.calendar_today_outlined,
                        label: 'Data de nascimento',
                        value: _formatarData(
                          usuario?.dataNascimento,
                        ),
                      ),

                      const _InfoDivider(),

                      _InfoItem(
                        icon: Icons.badge_outlined,
                        label: 'CPF',
                        value: _valorOuNaoInformado(
                          usuario?.cpf,
                        ),
                        trailing: possuiCpf
                            ? null
                            : IconButton(
                                onPressed: _abrirCadastroCpf,
                                icon: const Icon(Icons.edit_outlined),
                                color: DadosPessoaisPage.primaryBlue,
                                tooltip: 'Cadastrar CPF',
                              ),
                      ),

                      const _InfoDivider(),

                      _InfoItem(
                        icon: Icons.wc_outlined,
                        label: 'Gênero',
                        value: _valorOuNaoInformado(
                          usuario?.genero,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            _abrirSeletorGenero(usuario?.genero);
                          },
                          icon: const Icon(Icons.edit_outlined),
                          color: DadosPessoaisPage.primaryBlue,
                          tooltip: 'Alterar genero',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  const _SectionTitle(
                    title: 'Endereço',
                  ),

                  const SizedBox(height: 16),

                  _AddressCard(
                    endereco: endereco,
                    onAlterarEndereco: _alterarEndereco,
                  ),

                  if (_alterandoEndereco) ...[
                    const SizedBox(height: 20),

                    _AddressForm(
                      ruaController: _ruaController,
                      numeroController: _numeroController,
                      complementoController: _complementoController,
                      bairroController: _bairroController,
                      cidadeController: _cidadeController,
                      estadoController: _estadoController,
                      cepController: _cepController,
                      paisController: _paisController,
                      onSalvar: _salvarEndereco,
                      onCancelar: _alterarEndereco,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileImageSection extends StatelessWidget {
  final String? fotoPerfil;
  final VoidCallback onAlterarFoto;

  const _ProfileImageSection({
    required this.fotoPerfil,
    required this.onAlterarFoto,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: DadosPessoaisPage.lightBlue,
                ),
                child: fotoPerfil == null || fotoPerfil!.isEmpty
                    ? const Icon(
                        Icons.person,
                        color: DadosPessoaisPage.primaryBlue,
                        size: 82,
                      )
                    : ClipOval(
                        child: Image.file(
                          File(fotoPerfil!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              color: DadosPessoaisPage.primaryBlue,
                              size: 82,
                            );
                          },
                        ),
                      ),
              ),

              Positioned(
                right: -4,
                bottom: 4,
                child: GestureDetector(
                  onTap: onAlterarFoto,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: DadosPessoaisPage.primaryBlue,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 5,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            'Foto de perfil',
            style: TextStyle(
              color: DadosPessoaisPage.darkBlue,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          TextButton(
            onPressed: onAlterarFoto,
            child: const Text(
              'Alterar foto',
              style: TextStyle(
                color: DadosPessoaisPage.primaryBlue,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: DadosPessoaisPage.darkBlue,
        fontSize: 23,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: DadosPessoaisPage.borderGray,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 17,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: DadosPessoaisPage.lightBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: DadosPessoaisPage.primaryBlue,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: DadosPessoaisPage.textGray,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: const TextStyle(
                    color: DadosPessoaisPage.darkBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      color: DadosPessoaisPage.borderGray,
    );
  }
}

class _AddressCard extends StatelessWidget {
  final Endereco? endereco;
  final VoidCallback onAlterarEndereco;

  const _AddressCard({
    required this.endereco,
    required this.onAlterarEndereco,
  });

  String _formatarEndereco() {
    if (endereco == null) {
      return 'Nenhum endereço cadastrado';
    }

    final enderecoFormatado = StringBuffer();

    enderecoFormatado.write(
      '${endereco!.rua}, ${endereco!.numero}',
    );

    if (endereco!.complemento != null &&
        endereco!.complemento!.isNotEmpty) {
      enderecoFormatado.write(
        ' - ${endereco!.complemento}',
      );
    }

    enderecoFormatado.write(
      '\n${endereco!.bairro}',
    );

    enderecoFormatado.write(
      '\n${endereco!.cidade} - ${endereco!.estado}',
    );

    enderecoFormatado.write(
      '\nCEP: ${endereco!.cep}',
    );

    enderecoFormatado.write(
      '\n${endereco!.pais}',
    );

    return enderecoFormatado.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: DadosPessoaisPage.borderGray,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: DadosPessoaisPage.lightBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: DadosPessoaisPage.primaryBlue,
                  size: 28,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  _formatarEndereco(),
                  style: const TextStyle(
                    color: DadosPessoaisPage.darkBlue,
                    fontSize: 17,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: onAlterarEndereco,
              icon: const Icon(
                Icons.edit_outlined,
                size: 21,
              ),
              label: const Text(
                'Alterar endereço',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: DadosPessoaisPage.primaryBlue,
                side: const BorderSide(
                  color: DadosPessoaisPage.primaryBlue,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressForm extends StatelessWidget {
  final TextEditingController ruaController;
  final TextEditingController numeroController;
  final TextEditingController complementoController;
  final TextEditingController bairroController;
  final TextEditingController cidadeController;
  final TextEditingController estadoController;
  final TextEditingController cepController;
  final TextEditingController paisController;
  final VoidCallback onSalvar;
  final VoidCallback onCancelar;

  const _AddressForm({
    required this.ruaController,
    required this.numeroController,
    required this.complementoController,
    required this.bairroController,
    required this.cidadeController,
    required this.estadoController,
    required this.cepController,
    required this.paisController,
    required this.onSalvar,
    required this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DadosPessoaisPage.lightBlue.withValues(
          alpha: 0.35,
        ),
        border: Border.all(
          color: DadosPessoaisPage.borderGray,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Editar endereço',
            style: TextStyle(
              color: DadosPessoaisPage.darkBlue,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 20),

          _AddressTextField(
            controller: ruaController,
            label: 'Rua',
            icon: Icons.route_outlined,
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _AddressTextField(
                  controller: numeroController,
                  label: 'Número',
                  icon: Icons.numbers_outlined,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _AddressTextField(
                  controller: complementoController,
                  label: 'Complemento',
                  icon: Icons.home_work_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _AddressTextField(
            controller: bairroController,
            label: 'Bairro',
            icon: Icons.location_city_outlined,
          ),

          const SizedBox(height: 14),

          _AddressTextField(
            controller: cidadeController,
            label: 'Cidade',
            icon: Icons.location_city_outlined,
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _AddressTextField(
                  controller: estadoController,
                  label: 'Estado',
                  icon: Icons.map_outlined,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _AddressTextField(
                  controller: cepController,
                  label: 'CEP',
                  icon: Icons.markunread_mailbox_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _AddressTextField(
            controller: paisController,
            label: 'País',
            icon: Icons.public_outlined,
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancelar,
                  child: const Text(
                    'Cancelar',
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: onSalvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DadosPessoaisPage.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Salvar',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddressTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _AddressTextField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: DadosPessoaisPage.darkBlue,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: DadosPessoaisPage.primaryBlue,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: DadosPessoaisPage.borderGray,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: DadosPessoaisPage.borderGray,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: DadosPessoaisPage.primaryBlue,
            width: 2,
          ),
        ),
      ),
    );
  }
}
