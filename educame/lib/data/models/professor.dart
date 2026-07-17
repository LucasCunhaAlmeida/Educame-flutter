class Professor {
  final int? id;
  final int pessoaId;
  final String? bio;
  final String? diploma;
  final double valorHoraAula;
  final bool ativo;

  Professor({
    this.id,
    required this.pessoaId,
    this.bio,
    this.diploma,
    required this.valorHoraAula,
    this.ativo = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pessoa_id': pessoaId,
      'bio': bio,
      'diploma': diploma,
      'valor_hora_aula': valorHoraAula,
      'ativo': ativo ? 1 : 0,
    };
  }

  factory Professor.fromMap(Map<String, dynamic> map) {
    return Professor(
      id: map['id'],
      pessoaId: map['pessoa_id'],
      bio: map['bio'],
      diploma: map['diploma'],
      valorHoraAula: map['valor_hora_aula'],
      ativo: map['ativo'] == 1,
    );
  }
}