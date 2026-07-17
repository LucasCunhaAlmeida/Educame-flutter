class Aluno {
  final int? id;
  final int pessoaId;

  Aluno({
    this.id,
    required this.pessoaId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pessoa_id': pessoaId,
    };
  }

  factory Aluno.fromMap(Map<String, dynamic> map) {
    return Aluno(
      id: map['id'],
      pessoaId: map['pessoa_id'],
    );
  }
}