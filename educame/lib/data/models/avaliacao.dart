class Avaliacao {
  final int? id;
  final int aulaId;
  final int alunoId;
  final int professorId;
  final double nota;
  final String? comentario;
  final DateTime? dataAvaliacao;
  final String autorNome;
  final String? autorFotoPerfil;

  const Avaliacao({
    this.id,
    required this.aulaId,
    required this.alunoId,
    required this.professorId,
    required this.nota,
    this.comentario,
    this.dataAvaliacao,
    this.autorNome = 'Aluno',
    this.autorFotoPerfil,
  });

  String get autorInicial {
    final nome = autorNome.trim();
    return nome.isEmpty ? '?' : nome.substring(0, 1).toUpperCase();
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'aula_id': aulaId,
      'aluno_id': alunoId,
      'professor_id': professorId,
      'nota': nota,
      'comentario': comentario,
      'data_avaliacao': dataAvaliacao?.toIso8601String(),
    };
  }

  factory Avaliacao.fromMap(Map<String, Object?> map) {
    final evaluationDate = map['data_avaliacao'] as String?;

    return Avaliacao(
      id: map['id'] as int?,
      aulaId: map['aula_id'] as int,
      alunoId: map['aluno_id'] as int,
      professorId: map['professor_id'] as int,
      nota: (map['nota'] as num).toDouble(),
      comentario: map['comentario'] as String?,
      dataAvaliacao: evaluationDate == null
          ? null
          : DateTime.parse(evaluationDate),
      autorNome: map['autor_nome'] as String? ?? 'Aluno',
      autorFotoPerfil: map['autor_foto_perfil'] as String?,
    );
  }
}
