class Disciplina {
  final int? id;
  final String nome;
  final String? descricao;
  final bool ativo;

  const Disciplina({
    this.id,
    required this.nome,
    this.descricao,
    this.ativo = true,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'ativo': ativo ? 1 : 0,
    };
  }

  factory Disciplina.fromMap(Map<String, Object?> map) {
    return Disciplina(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      descricao: map['descricao'] as String?,
      ativo: map['ativo'] == 1,
    );
  }
}
