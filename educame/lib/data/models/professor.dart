import 'disciplina.dart';
import 'pessoa.dart';

class Professor {
  final int? id;
  final Pessoa pessoa;
  final String? bio;
  final String? diploma;
  final double valorHoraAula;
  final bool ativo;
  final List<Disciplina> especialidades;
  final double mediaAvaliacoes;
  final int totalAvaliacoes;

  const Professor({
    this.id,
    required this.pessoa,
    this.bio,
    this.diploma,
    required this.valorHoraAula,
    this.ativo = true,
    this.especialidades = const [],
    this.mediaAvaliacoes = 0,
    this.totalAvaliacoes = 0,
  });

  int get pessoaId => pessoa.id!;
  String get nomeCompleto => pessoa.nomeCompleto;
  String get iniciais => pessoa.iniciais;
  bool get possuiAvaliacoes => totalAvaliacoes > 0;

  String get especialidadesTexto {
    return especialidades.map((disciplina) => disciplina.nome).join(', ');
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'pessoa_id': pessoaId,
      'bio': bio,
      'diploma': diploma,
      'valor_hora_aula': valorHoraAula,
      'ativo': ativo ? 1 : 0,
    };
  }

  factory Professor.fromMap(
    Map<String, Object?> map, {
    required Pessoa pessoa,
    List<Disciplina> especialidades = const [],
  }) {
    return Professor(
      id: map['id'] as int?,
      pessoa: pessoa,
      bio: map['bio'] as String?,
      diploma: map['diploma'] as String?,
      valorHoraAula: (map['valor_hora_aula'] as num).toDouble(),
      ativo: map['ativo'] == 1,
      especialidades: List.unmodifiable(especialidades),
      mediaAvaliacoes: (map['media_avaliacoes'] as num?)?.toDouble() ?? 0,
      totalAvaliacoes: (map['total_avaliacoes'] as num?)?.toInt() ?? 0,
    );
  }

  Professor copyWith({
    List<Disciplina>? especialidades,
    double? mediaAvaliacoes,
    int? totalAvaliacoes,
  }) {
    return Professor(
      id: id,
      pessoa: pessoa,
      bio: bio,
      diploma: diploma,
      valorHoraAula: valorHoraAula,
      ativo: ativo,
      especialidades: especialidades ?? this.especialidades,
      mediaAvaliacoes: mediaAvaliacoes ?? this.mediaAvaliacoes,
      totalAvaliacoes: totalAvaliacoes ?? this.totalAvaliacoes,
    );
  }
}
