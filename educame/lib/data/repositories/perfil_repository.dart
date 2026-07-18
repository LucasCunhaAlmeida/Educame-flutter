import 'package:sqflite/sqflite.dart';

import '../app_database.dart';
import '../models/endereco.dart';
import '../models/pessoa.dart';

class PerfilRepository {
  Future<Pessoa?> buscarPessoaPorId(int pessoaId) async {
    final database = await AppDatabase.database;

    final resultado = await database.query(
      'pessoa',
      where: 'id = ?',
      whereArgs: [pessoaId],
      limit: 1,
    );

    if (resultado.isEmpty) {
      return null;
    }

    return Pessoa.fromMap(resultado.first);
  }

  Future<Endereco?> buscarEnderecoPorId(int enderecoId) async {
    final database = await AppDatabase.database;

    final resultado = await database.query(
      'endereco',
      where: 'id = ?',
      whereArgs: [enderecoId],
      limit: 1,
    );

    if (resultado.isEmpty) {
      return null;
    }

    return Endereco.fromMap(resultado.first);
  }

  Future<void> atualizarCpf({
    required int pessoaId,
    required String cpf,
  }) async {
    final database = await AppDatabase.database;

    await database.update(
      'pessoa',
      {
        'cpf': cpf,
      },
      where: "id = ? AND (cpf IS NULL OR TRIM(cpf) = '')",
      whereArgs: [pessoaId],
    );
  }

  Future<void> atualizarGenero({
    required int pessoaId,
    required String genero,
  }) async {
    final database = await AppDatabase.database;

    await database.update(
      'pessoa',
      {
        'genero': genero,
      },
      where: 'id = ?',
      whereArgs: [pessoaId],
    );
  }

  Future<void> atualizarEndereco({
    required int enderecoId,
    required String rua,
    required String numero,
    String? complemento,
    required String bairro,
    required String cidade,
    required String estado,
    required String cep,
    required String pais,
  }) async {
    final database = await AppDatabase.database;

    await database.update(
      'endereco',
      {
        'rua': rua,
        'numero': numero,
        'complemento': complemento,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado,
        'cep': cep,
        'pais': pais,
      },
      where: 'id = ?',
      whereArgs: [enderecoId],
    );
  }

  Future<int> criarEndereco({
    required String rua,
    required String numero,
    String? complemento,
    required String bairro,
    required String cidade,
    required String estado,
    required String cep,
    required String pais,
  }) async {
    final database = await AppDatabase.database;

    return await database.insert(
      'endereco',
      {
        'rua': rua,
        'numero': numero,
        'complemento': complemento,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado,
        'cep': cep,
        'pais': pais,
      },
    );
  }

  Future<void> associarEnderecoPessoa({
    required int pessoaId,
    required int enderecoId,
  }) async {
    final database = await AppDatabase.database;

    await database.update(
      'pessoa',
      {
        'endereco_id': enderecoId,
      },
      where: 'id = ?',
      whereArgs: [pessoaId],
    );
  }
}
