import 'package:sqflite/sqflite.dart';

import '../models/pagamento.dart';
import 'database_provider.dart';

class PagamentoRepository {
  final DatabaseProvider _databaseProvider;

  PagamentoRepository({DatabaseProvider? databaseProvider})
    : _databaseProvider = databaseProvider ?? appDatabaseProvider;

  Future<Pagamento?> buscarPorAulaId(int aulaId) async {
    if (aulaId <= 0) {
      throw ArgumentError.value(
        aulaId,
        'aulaId',
        'O ID da aula deve ser maior que zero.',
      );
    }

    final database = await _databaseProvider();
    final rows = await database.query(
      'pagamento',
      where: 'aula_id = ?',
      whereArgs: [aulaId],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return Pagamento.fromMap(Map<String, dynamic>.from(rows.first));
  }

  Future<List<Pagamento>> listarPorAluno(int alunoId) async {
    if (alunoId <= 0) {
      throw ArgumentError.value(
        alunoId,
        'alunoId',
        'O ID do aluno deve ser maior que zero.',
      );
    }

    final database = await _databaseProvider();
    final rows = await database.query(
      'pagamento',
      where: 'aluno_id = ?',
      whereArgs: [alunoId],
      orderBy: 'data_vencimento DESC',
    );

    return rows
        .map((row) => Pagamento.fromMap(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }

  Future<int> criar(Pagamento pagamento, {DatabaseExecutor? executor}) async {
    final alvo = executor ?? await _databaseProvider();
    return alvo.insert(
      'pagamento',
      pagamento.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> atualizarStatus({
    required int pagamentoId,
    required String status,
    DateTime? dataPagamento,
    String? metodoPagamento,
    String? referenciaExterna,
  }) async {
    if (pagamentoId <= 0) {
      throw ArgumentError.value(
        pagamentoId,
        'pagamentoId',
        'O ID do pagamento deve ser maior que zero.',
      );
    }

    final database = await _databaseProvider();
    await database.update(
      'pagamento',
      {
        'status': status,
        'data_pagamento': dataPagamento?.toIso8601String(),
        'metodo_pagamento': metodoPagamento,
        'referencia_externa': referenciaExterna,
      }..removeWhere((key, value) => value == null),
      where: 'id = ?',
      whereArgs: [pagamentoId],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> cancelarPorAula(int aulaId, {DatabaseExecutor? executor}) async {
    if (aulaId <= 0) {
      throw ArgumentError.value(
        aulaId,
        'aulaId',
        'O ID da aula deve ser maior que zero.',
      );
    }

    final alvo = executor ?? await _databaseProvider();
    await alvo.update(
      'pagamento',
      {'status': 'cancelado'},
      where: 'aula_id = ?',
      whereArgs: [aulaId],
    );
  }
}
