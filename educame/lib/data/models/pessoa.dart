class Pessoa {
  final int? id;
  final String nome;
  final String sobrenome;
  final DateTime dataNascimento;
  final String? genero;
  final String? cpf;
  final String? fotoPerfil;
  final int? enderecoId;
  final String email;
  final String senha;

  const Pessoa({
    this.id,
    required this.nome,
    required this.sobrenome,
    required this.dataNascimento,
    this.genero,
    this.cpf,
    this.fotoPerfil,
    this.enderecoId,
    required this.email,
    required this.senha,
  });

  String get nomeCompleto => '$nome $sobrenome'.trim();

  String get iniciais {
    final partes = nomeCompleto
        .split(RegExp(r'\s+'))
        .where((parte) => parte.isNotEmpty)
        .toList();

    if (partes.isEmpty) {
      return '?';
    }
    if (partes.length == 1) {
      return partes.first.substring(0, 1).toUpperCase();
    }

    return '${partes.first.substring(0, 1)}${partes.last.substring(0, 1)}'
        .toUpperCase();
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'sobrenome': sobrenome,
      'data_nascimento': dataNascimento.toIso8601String(),
      'genero': genero,
      'cpf': cpf,
      'foto_perfil': fotoPerfil,
      'endereco_id': enderecoId,
      'email': email,
      'senha': senha,
    };
  }

  factory Pessoa.fromMap(Map<String, Object?> map) {
    return Pessoa(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      sobrenome: map['sobrenome'] as String,
      dataNascimento: DateTime.parse(map['data_nascimento'] as String),
      genero: map['genero'] as String?,
      cpf: map['cpf'] as String,
      fotoPerfil: map['foto_perfil'] as String?,
      enderecoId: map['endereco_id'] as int?,
      email: map['email'] as String,
      senha: map['senha'] as String,
    );
  }
}
