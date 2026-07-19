import 'package:sqflite/sqflite.dart';

import '../models/aula.dart';
import 'database_provider.dart';

class AulaRepository {
  final DatabaseProvider _databaseProvider;

  AulaRepository({DatabaseProvider? databaseProvider})
      : _databaseProvider = databaseProvider ?? appDatabaseProvider;

  Future<int> agendar(Aula aula) async {
    final database = await _databaseProvider();

    return database.insert('aula', aula.toMap());
  }

  Future<int?> buscarAlunoIdPorPessoaId(int pessoaId) async {
    if (pessoaId <= 0) {
      throw ArgumentError.value(
        pessoaId,
        'pessoaId',
        'O ID da pessoa deve ser maior que zero.',
      );
    }

    final database = await _databaseProvider();
    final rows = await database.query(
      'aluno',
      columns: ['id'],
      where: 'pessoa_id = ?',
      whereArgs: [pessoaId],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return rows.first['id'] as int;
  }

  Future<Aula?> buscarPorId(int id) async {
    _validarId(id);

    final database = await _databaseProvider();
    final result = await database.query(
      'aula',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return Aula.fromMap(Map<String, dynamic>.from(result.first));
  }

  Future<AulaDetalhada?> buscarDetalhadaPorId(int aulaId) async {
    _validarId(aulaId);

    final aulas = await _consultarDetalhadas(
      where: 'aula.id = ?',
      whereArgs: [aulaId],
      orderBy: 'aula.inicio ASC',
      limit: 1,
    );

    if (aulas.isEmpty) {
      return null;
    }

    return aulas.first;
  }

  Future<List<Aula>> listarProximas(int alunoId) async {
    _validarAlunoId(alunoId);

    final database = await _databaseProvider();
    final agora = DateTime.now().toIso8601String();
    final result = await database.query(
      'aula',
      where: '''
        aluno_id = ?
        AND status IN ('agendada','confirmada')
        AND inicio > ?
      ''',
      whereArgs: [alunoId, agora],
      orderBy: 'inicio ASC',
    );

    return result
        .map((row) => Aula.fromMap(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }

  Future<List<Aula>> listarHistorico(int alunoId) async {
    _validarAlunoId(alunoId);

    final database = await _databaseProvider();
    final result = await database.query(
      'aula',
      where: '''
        aluno_id = ?
        AND status IN ('concluida','cancelada')
      ''',
      whereArgs: [alunoId],
      orderBy: 'inicio DESC',
    );

    return result
        .map((row) => Aula.fromMap(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }

  Future<List<AulaDetalhada>> listarProximasDetalhadas(
    int alunoId, {
    int? limite,
  }) async {
    _validarAlunoId(alunoId);
    final agora = DateTime.now().toIso8601String();

    return _consultarDetalhadas(
      where: '''
        aula.aluno_id = ?
        AND aula.status IN ('agendada','confirmada')
        AND aula.inicio > ?
      ''',
      whereArgs: [alunoId, agora],
      orderBy: 'aula.inicio ASC',
      limit: limite,
    );
  }

  Future<List<AulaDetalhada>> listarHistoricoDetalhado(
    int alunoId, {
    int? limite,
  }) async {
    _validarAlunoId(alunoId);

    return _consultarDetalhadas(
      where: '''
        aula.aluno_id = ?
        AND aula.status IN ('concluida','cancelada')
      ''',
      whereArgs: [alunoId],
      orderBy: 'aula.inicio DESC',
      limit: limite,
    );
  }

  Future<void> confirmar(int aulaId) async {
    _validarId(aulaId);

    final database = await _databaseProvider();
    await database.update(
      'aula',
      {'status': 'confirmada'},
      where: 'id = ?',
      whereArgs: [aulaId],
    );
  }

  Future<void> concluir(int aulaId) async {
    _validarId(aulaId);

    final database = await _databaseProvider();
    await database.update(
      'aula',
      {'status': 'concluida'},
      where: 'id = ?',
      whereArgs: [aulaId],
    );
  }

  Future<void> cancelar(int aulaId) async {
    _validarId(aulaId);

    final database = await _databaseProvider();
    await database.update(
      'aula',
      {'status': 'cancelada'},
      where: 'id = ?',
      whereArgs: [aulaId],
    );
  }

  Future<void> atualizar(Aula aula) async {
    if (aula.id == null) {
      throw ArgumentError('A aula precisa possuir um ID para ser atualizada.');
    }

    final database = await _databaseProvider();
    await database.update(
      'aula',
      aula.toMap(),
      where: 'id = ?',
      whereArgs: [aula.id],
    );
  }

  Future<void> excluir(int aulaId) async {
    _validarId(aulaId);

    final database = await _databaseProvider();
    await database.delete('aula', where: 'id = ?', whereArgs: [aulaId]);
  }

  Future<List<Aula>> listarPorProfessor(int professorId) async {
    if (professorId <= 0) {
      throw ArgumentError.value(
        professorId,
        'professorId',
        'O ID do professor deve ser maior que zero.',
      );
    }

    final database = await _databaseProvider();
    final result = await database.query(
      'aula',
      where: 'professor_id = ?',
      whereArgs: [professorId],
      orderBy: 'inicio ASC',
    );

    return result
        .map((row) => Aula.fromMap(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }

  Future<List<Aula>> listarTodas() async {
    final database = await _databaseProvider();
    final result = await database.query('aula', orderBy: 'inicio DESC');

    return result
        .map((row) => Aula.fromMap(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }

  Future<List<Map<String, dynamic>>> listarAgendamentosDetalhados(
    int alunoId,
  ) async {
    _validarAlunoId(alunoId);

    final database = await _databaseProvider();
    final rows = await database.rawQuery(
      '''
      SELECT
        aula.id,
        aula.aluno_id,
        aula.professor_id,
        aula.disciplina_id,
        aula.inicio,
        aula.fim,
        aula.status,
        aula.modalidade,
        aula.observacao,
        TRIM(pessoa.nome || ' ' || pessoa.sobrenome) AS professor,
        disciplina.nome AS disciplina
      FROM aula
      INNER JOIN professor
        ON professor.id = aula.professor_id
      INNER JOIN pessoa
        ON pessoa.id = professor.pessoa_id
      INNER JOIN disciplina
        ON disciplina.id = aula.disciplina_id
      WHERE aula.aluno_id = ?
      ORDER BY aula.inicio ASC
    ''',
      [alunoId],
    );

    return rows
        .map((row) => Map<String, dynamic>.from(row))
        .toList(growable: false);
  }

  Future<List<AulaDetalhada>> _consultarDetalhadas({
    required String where,
    required List<Object?> whereArgs,
    required String orderBy,
    int? limit,
  }) async {
    final database = await _databaseProvider();
    final limitClause = limit == null ? '' : 'LIMIT ?';
    final arguments = <Object?>[
      ...whereArgs,
      if (limit != null) limit,
    ];

    final rows = await database.rawQuery(
      '''
      SELECT
        aula.id,
        aula.aluno_id,
        aula.professor_id,
        aula.disciplina_id,
        aula.inicio,
        aula.fim,
        aula.status,
        aula.modalidade,
        aula.observacao,
        TRIM(pessoa.nome || ' ' || pessoa.sobrenome) AS professor,
        disciplina.nome AS disciplina
      FROM aula
      INNER JOIN professor
        ON professor.id = aula.professor_id
      INNER JOIN pessoa
        ON pessoa.id = professor.pessoa_id
      INNER JOIN disciplina
        ON disciplina.id = aula.disciplina_id
      WHERE $where
      ORDER BY $orderBy
      $limitClause
    ''',
      arguments,
    );

    return rows
        .map((row) => AulaDetalhada.fromMap(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }

  void _validarId(int id) {
    if (id <= 0) {
      throw ArgumentError.value(id, 'id', 'O ID deve ser maior que zero.');
    }
  }

  void _validarAlunoId(int alunoId) {
    if (alunoId <= 0) {
      throw ArgumentError.value(
        alunoId,
        'alunoId',
        'O ID do aluno deve ser maior que zero.',
      );
    }
  }
}

class AulaDetalhada {
  final Aula aula;
  final String professor;
  final String disciplina;

  const AulaDetalhada({
    required this.aula,
    required this.professor,
    required this.disciplina,
  });

  factory AulaDetalhada.fromMap(Map<String, dynamic> map) {
    return AulaDetalhada(
      aula: Aula.fromMap(map),
      professor: (map['professor'] as String?)?.trim().isNotEmpty == true
          ? (map['professor'] as String).trim()
          : 'Professor',
      disciplina: (map['disciplina'] as String?)?.trim().isNotEmpty == true
          ? (map['disciplina'] as String).trim()
          : 'Disciplina',
    );
  }
}
