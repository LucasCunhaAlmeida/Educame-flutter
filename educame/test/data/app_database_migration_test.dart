import 'dart:io';

import 'package:educame/data/app_database.dart';
import 'package:educame/data/models/pessoa.dart';
import 'package:educame/data/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' show Sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('migra banco v2 e permite cadastrar pessoa sem CPF', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final temporaryDirectory = await Directory.systemTemp.createTemp(
      'educame_database_test_',
    );
    addTearDown(() => temporaryDirectory.delete(recursive: true));

    await databaseFactoryFfi.setDatabasesPath(temporaryDirectory.path);
    final databasePath = path.join(temporaryDirectory.path, 'educame.db');

    final version2Database = await databaseFactoryFfi.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: (database, version) async {
          await database.execute('''
            CREATE TABLE endereco (
              id INTEGER PRIMARY KEY AUTOINCREMENT
            )
          ''');
          await database.execute('''
            CREATE TABLE pessoa (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome TEXT NOT NULL,
              sobrenome TEXT NOT NULL,
              data_nascimento TEXT NOT NULL,
              genero TEXT,
              cpf TEXT NOT NULL UNIQUE,
              foto_perfil TEXT,
              endereco_id INTEGER,
              email TEXT NOT NULL UNIQUE,
              senha TEXT NOT NULL,
              FOREIGN KEY (endereco_id) REFERENCES endereco (id)
            )
          ''');
          await database.execute('''
            CREATE TABLE aluno (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              pessoa_id INTEGER NOT NULL UNIQUE,
              FOREIGN KEY (pessoa_id)
                REFERENCES pessoa (id)
                ON DELETE CASCADE
            )
          ''');
          await database.execute('''
            CREATE TABLE professor (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              pessoa_id INTEGER NOT NULL UNIQUE,
              bio TEXT,
              diploma TEXT,
              valor_hora_aula REAL NOT NULL,
              ativo INTEGER NOT NULL DEFAULT 1,
              FOREIGN KEY (pessoa_id)
                REFERENCES pessoa (id)
                ON DELETE CASCADE
            )
          ''');
          await database.insert('pessoa', {
            'id': 1,
            'nome': 'Pessoa',
            'sobrenome': 'Existente',
            'data_nascimento': '2000-01-01T00:00:00.000',
            'cpf': '12345678900',
            'email': 'existente@educame.com',
            'senha': 'hash',
          });
          await database.insert('aluno', {'id': 1, 'pessoa_id': 1});
        },
      ),
    );
    await version2Database.close();

    final migratedDatabase = await AppDatabase.database;
    final cpfColumn = (await migratedDatabase.rawQuery(
      'PRAGMA table_info(pessoa)',
    )).firstWhere((column) => column['name'] == 'cpf');

    expect(await migratedDatabase.getVersion(), 3);
    expect(cpfColumn['notnull'], 0);
    expect(
      Sqflite.firstIntValue(
        await migratedDatabase.rawQuery('SELECT COUNT(*) FROM aluno'),
      ),
      1,
    );

    await AuthRepository().cadastrar(
      Pessoa(
        nome: 'Novo',
        sobrenome: 'Aluno',
        dataNascimento: DateTime(2004, 8, 9),
        email: 'novo@educame.com',
        senha: 'senha123',
      ),
    );

    expect(
      Sqflite.firstIntValue(
        await migratedDatabase.rawQuery('SELECT COUNT(*) FROM pessoa'),
      ),
      2,
    );
    expect(
      Sqflite.firstIntValue(
        await migratedDatabase.rawQuery('SELECT COUNT(*) FROM aluno'),
      ),
      2,
    );
    expect(
      Sqflite.firstIntValue(
        await migratedDatabase.rawQuery('SELECT COUNT(*) FROM professor'),
      ),
      1,
    );

    expect(
      await migratedDatabase.rawQuery('PRAGMA foreign_key_check'),
      isEmpty,
    );
  });
}
