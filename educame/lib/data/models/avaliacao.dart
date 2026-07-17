class Avaliacao {
  final int? id;
  final int aulaId;
  final int alunoId;
  final int professorId;
  final double nota;
  final String? comentario;

  Avaliacao({
    this.id,
    required this.aulaId,
    required this.alunoId,
    required this.professorId,
    required this.nota,
    this.comentario,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'aula_id': aulaId,
      'aluno_id': alunoId,
      'professor_id': professorId,
      'nota': nota,
      'comentario': comentario,
    };
  }

  factory Avaliacao.fromMap(Map<String, dynamic> map) {
    return Avaliacao(
      id: map['id'],
      aulaId: map['aula_id'],
      alunoId: map['aluno_id'],
      professorId: map['professor_id'],
      nota: map['nota'],
      comentario: map['comentario'],
    );
  }
}