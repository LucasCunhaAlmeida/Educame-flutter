class Disciplina {
  final int? id;
  final String nome;
  final String? descricao;
  final bool ativo;

  Disciplina({
    this.id,
    required this.nome,
    this.descricao,
    this.ativo = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'ativo': ativo ? 1 : 0,
    };
  }

  factory Disciplina.fromMap(Map<String, dynamic> map) {
    return Disciplina(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      ativo: map['ativo'] == 1,
    );
  }
}