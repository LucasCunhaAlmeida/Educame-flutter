import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
static const String _databaseName = 'educame.db';
  static const int _databaseVersion = 1;

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      _databaseName,
    );

    return await openDatabase(
      path,
      version: _databaseVersion,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(
    Database database,
    int version,
  ) async {
    await database.execute('''
      CREATE TABLE endereco (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        rua TEXT NOT NULL,
        numero TEXT NOT NULL,
        complemento TEXT,
        bairro TEXT NOT NULL,
        cidade TEXT NOT NULL,
        estado TEXT NOT NULL,
        cep TEXT NOT NULL,
        pais TEXT NOT NULL
      )
    ''');

    await database.execute('''
      CREATE TABLE pessoa (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        sobrenome TEXT NOT NULL,
        data_nascimento TEXT NOT NULL,
        genero TEXT,
        cpf TEXT UNIQUE,
        foto_perfil TEXT,
        endereco_id INTEGER,
        email TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL,

        FOREIGN KEY (endereco_id)
          REFERENCES endereco (id)
          ON DELETE SET NULL
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

    await database.execute('''
      CREATE TABLE disciplina (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        descricao TEXT,
        ativo INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await database.execute('''
      CREATE TABLE disponibilidade (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        professor_id INTEGER NOT NULL,
        inicio TEXT NOT NULL,
        fim TEXT NOT NULL,
        status TEXT NOT NULL,
        observacao TEXT,

        FOREIGN KEY (professor_id)
          REFERENCES professor (id)
          ON DELETE CASCADE
      )
    ''');

    await database.execute('''
      CREATE TABLE aula (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        aluno_id INTEGER NOT NULL,
        professor_id INTEGER NOT NULL,
        disciplina_id INTEGER NOT NULL,
        inicio TEXT NOT NULL,
        fim TEXT NOT NULL,
        status TEXT NOT NULL,
        modalidade TEXT NOT NULL,
        observacao TEXT,

        FOREIGN KEY (aluno_id)
          REFERENCES aluno (id)
          ON DELETE CASCADE,

        FOREIGN KEY (professor_id)
          REFERENCES professor (id)
          ON DELETE CASCADE,

        FOREIGN KEY (disciplina_id)
          REFERENCES disciplina (id)
          ON DELETE CASCADE
      )
    ''');

    await database.execute('''
      CREATE TABLE pagamento (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        aula_id INTEGER NOT NULL,
        aluno_id INTEGER NOT NULL,
        valor REAL NOT NULL,
        status TEXT NOT NULL,
        data_vencimento TEXT NOT NULL,
        data_pagamento TEXT,
        metodo_pagamento TEXT,
        referencia_externa TEXT,

        FOREIGN KEY (aula_id)
          REFERENCES aula (id)
          ON DELETE CASCADE,

        FOREIGN KEY (aluno_id)
          REFERENCES aluno (id)
          ON DELETE CASCADE
      )
    ''');

    await database.execute('''
      CREATE TABLE avaliacao (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        aula_id INTEGER NOT NULL,
        aluno_id INTEGER NOT NULL,
        professor_id INTEGER NOT NULL,
        nota REAL NOT NULL,
        comentario TEXT,

        FOREIGN KEY (aula_id)
          REFERENCES aula (id)
          ON DELETE CASCADE,

        FOREIGN KEY (aluno_id)
          REFERENCES aluno (id)
          ON DELETE CASCADE,

        FOREIGN KEY (professor_id)
          REFERENCES professor (id)
          ON DELETE CASCADE
      )
    ''');
  }
}