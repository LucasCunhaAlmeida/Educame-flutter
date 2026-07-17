class Aula {
  final int? id;
  final int alunoId;
  final int professorId;
  final int disciplinaId;
  final DateTime inicio;
  final DateTime fim;
  final String status;
  final String modalidade;
  final String? observacao;

  Aula({
    this.id,
    required this.alunoId,
    required this.professorId,
    required this.disciplinaId,
    required this.inicio,
    required this.fim,
    required this.status,
    required this.modalidade,
    this.observacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'aluno_id': alunoId,
      'professor_id': professorId,
      'disciplina_id': disciplinaId,
      'inicio': inicio.toIso8601String(),
      'fim': fim.toIso8601String(),
      'status': status,
      'modalidade': modalidade,
      'observacao': observacao,
    };
  }

  factory Aula.fromMap(Map<String, dynamic> map) {
    return Aula(
      id: map['id'],
      alunoId: map['aluno_id'],
      professorId: map['professor_id'],
      disciplinaId: map['disciplina_id'],
      inicio: DateTime.parse(map['inicio']),
      fim: DateTime.parse(map['fim']),
      status: map['status'],
      modalidade: map['modalidade'],
      observacao: map['observacao'],
    );
  }
}
