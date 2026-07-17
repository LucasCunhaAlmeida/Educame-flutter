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

  Pessoa({
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

  Map<String, dynamic> toMap() {
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

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      id: map['id'],
      nome: map['nome'],
      sobrenome: map['sobrenome'],
      dataNascimento: DateTime.parse(
        map['data_nascimento'],
      ),
      genero: map['genero'],
      cpf: map['cpf'],
      fotoPerfil: map['foto_perfil'],
      enderecoId: map['endereco_id'],
      email: map['email'],
      senha: map['senha'],
    );
  }
}