class Disponibilidade {
  final int? id;
  final int professorId;
  final DateTime inicio;
  final DateTime fim;
  final String status;
  final String? observacao;

  const Disponibilidade({
    this.id,
    required this.professorId,
    required this.inicio,
    required this.fim,
    required this.status,
    this.observacao,
  });

  bool get disponivel => status.toLowerCase() == 'disponivel';
  Duration get duracao => fim.difference(inicio);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'professor_id': professorId,
      'inicio': inicio.toIso8601String(),
      'fim': fim.toIso8601String(),
      'status': status,
      'observacao': observacao,
    };
  }

  factory Disponibilidade.fromMap(Map<String, Object?> map) {
    return Disponibilidade(
      id: map['id'] as int?,
      professorId: map['professor_id'] as int,
      inicio: DateTime.parse(map['inicio'] as String),
      fim: DateTime.parse(map['fim'] as String),
      status: map['status'] as String,
      observacao: map['observacao'] as String?,
    );
  }
}
