class Disponibilidade {
  final int? id;
  final int professorId;
  final DateTime inicio;
  final DateTime fim;
  final String status;
  final String? observacao;

  Disponibilidade({
    this.id,
    required this.professorId,
    required this.inicio,
    required this.fim,
    required this.status,
    this.observacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'professor_id': professorId,
      'inicio': inicio.toIso8601String(),
      'fim': fim.toIso8601String(),
      'status': status,
      'observacao': observacao,
    };
  }

  factory Disponibilidade.fromMap(Map<String, dynamic> map) {
    return Disponibilidade(
      id: map['id'],
      professorId: map['professor_id'],
      inicio: DateTime.parse(map['inicio']),
      fim: DateTime.parse(map['fim']),
      status: map['status'],
      observacao: map['observacao'],
    );
  }
}