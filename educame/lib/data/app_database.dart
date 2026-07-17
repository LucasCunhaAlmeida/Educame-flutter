import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const String _databaseName = 'educame.db';
  static const int _databaseVersion = 2;

  static Database? _database;
  static Future<Database>? _databaseFuture;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final pendingDatabase = _databaseFuture;
    if (pendingDatabase != null) {
      return pendingDatabase;
    }

    final databaseFuture = _initDatabase();
    _databaseFuture = databaseFuture;

    try {
      final initializedDatabase = await databaseFuture;
      _database = initializedDatabase;
      return initializedDatabase;
    } catch (_) {
      if (identical(_databaseFuture, databaseFuture)) {
        _databaseFuture = null;
      }
      rethrow;
    }
  }

  static Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (database, version) async {
        await _createTables(database);
        await _createIndexes(database);
        await _seedDatabase(database);
      },
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onUpgrade(
    Database database,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await database.execute('''
        CREATE TABLE IF NOT EXISTS professor_disciplina (
          professor_id INTEGER NOT NULL,
          disciplina_id INTEGER NOT NULL,

          PRIMARY KEY (professor_id, disciplina_id),

          FOREIGN KEY (professor_id)
            REFERENCES professor (id)
            ON DELETE CASCADE,

          FOREIGN KEY (disciplina_id)
            REFERENCES disciplina (id)
            ON DELETE CASCADE
        )
      ''');

      final avaliacaoColumns = await database.rawQuery(
        'PRAGMA table_info(avaliacao)',
      );
      final hasEvaluationDate = avaliacaoColumns.any(
        (column) => column['name'] == 'data_avaliacao',
      );

      if (!hasEvaluationDate) {
        await database.execute(
          'ALTER TABLE avaliacao ADD COLUMN data_avaliacao TEXT',
        );
      }

      await _createIndexes(database);
      await _seedDatabase(database);
    }
  }

  static Future<void> _createTables(Database database) async {
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
      CREATE TABLE professor_disciplina (
        professor_id INTEGER NOT NULL,
        disciplina_id INTEGER NOT NULL,

        PRIMARY KEY (professor_id, disciplina_id),

        FOREIGN KEY (professor_id)
          REFERENCES professor (id)
          ON DELETE CASCADE,

        FOREIGN KEY (disciplina_id)
          REFERENCES disciplina (id)
          ON DELETE CASCADE
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
        data_avaliacao TEXT NOT NULL,

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

  static Future<void> _createIndexes(Database database) async {
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_pessoa_nome
      ON pessoa (nome COLLATE NOCASE, sobrenome COLLATE NOCASE)
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_professor_ativo
      ON professor (ativo)
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_disciplina_nome
      ON disciplina (nome COLLATE NOCASE)
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_professor_disciplina_disciplina
      ON professor_disciplina (disciplina_id, professor_id)
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_disponibilidade_professor
      ON disponibilidade (professor_id, status, inicio)
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_avaliacao_professor
      ON avaliacao (professor_id, data_avaliacao)
    ''');
  }

  static Future<void> _seedDatabase(Database database) async {
    final batch = database.batch();

    const addresses = [
      {
        'id': 1,
        'rua': 'Avenida Fernandes Lima',
        'numero': '1200',
        'complemento': 'Sala 08',
        'bairro': 'Farol',
        'cidade': 'Maceió',
        'estado': 'AL',
        'cep': '57050-000',
        'pais': 'Brasil',
      },
      {
        'id': 2,
        'rua': 'Rua das Acácias',
        'numero': '245',
        'complemento': 'Apto 302',
        'bairro': 'Ponta Verde',
        'cidade': 'Maceió',
        'estado': 'AL',
        'cep': '57035-180',
        'pais': 'Brasil',
      },
      {
        'id': 3,
        'rua': 'Rua Professor Sandoval Arroxelas',
        'numero': '880',
        'complemento': null,
        'bairro': 'Ponta Verde',
        'cidade': 'Maceió',
        'estado': 'AL',
        'cep': '57035-230',
        'pais': 'Brasil',
      },
      {
        'id': 4,
        'rua': 'Avenida Álvaro Otacílio',
        'numero': '3100',
        'complemento': 'Apto 504',
        'bairro': 'Jatiúca',
        'cidade': 'Maceió',
        'estado': 'AL',
        'cep': '57036-850',
        'pais': 'Brasil',
      },
      {
        'id': 5,
        'rua': 'Rua Deputado José Lages',
        'numero': '410',
        'complemento': null,
        'bairro': 'Ponta Verde',
        'cidade': 'Maceió',
        'estado': 'AL',
        'cep': '57035-330',
        'pais': 'Brasil',
      },
      {
        'id': 6,
        'rua': 'Rua Cincinato Pinto',
        'numero': '560',
        'complemento': 'Sala 12',
        'bairro': 'Centro',
        'cidade': 'Maceió',
        'estado': 'AL',
        'cep': '57020-050',
        'pais': 'Brasil',
      },
      {
        'id': 7,
        'rua': 'Avenida Menino Marcelo',
        'numero': '7500',
        'complemento': 'Bloco B',
        'bairro': 'Antares',
        'cidade': 'Maceió',
        'estado': 'AL',
        'cep': '57083-410',
        'pais': 'Brasil',
      },
      {
        'id': 8,
        'rua': 'Rua José Sampaio Luz',
        'numero': '190',
        'complemento': 'Apto 701',
        'bairro': 'Ponta Verde',
        'cidade': 'Maceió',
        'estado': 'AL',
        'cep': '57035-260',
        'pais': 'Brasil',
      },
      {
        'id': 9,
        'rua': 'Avenida Comendador Gustavo Paiva',
        'numero': '2800',
        'complemento': null,
        'bairro': 'Mangabeiras',
        'cidade': 'Maceió',
        'estado': 'AL',
        'cep': '57037-285',
        'pais': 'Brasil',
      },
      {
        'id': 10,
        'rua': 'Rua Doutor Antônio Cansanção',
        'numero': '640',
        'complemento': 'Apto 202',
        'bairro': 'Ponta Verde',
        'cidade': 'Maceió',
        'estado': 'AL',
        'cep': '57035-190',
        'pais': 'Brasil',
      },
    ];

    const people = [
      {
        'id': 1,
        'nome': 'Rafael',
        'sobrenome': 'Lima',
        'data_nascimento': '1987-03-14',
        'genero': 'Masculino',
        'cpf': '10000000001',
        'foto_perfil': null,
        'endereco_id': 1,
        'email': 'rafael.lima@educame.com',
        'senha': 'seed_demo',
      },
      {
        'id': 2,
        'nome': 'Camila',
        'sobrenome': 'Souza',
        'data_nascimento': '1990-07-22',
        'genero': 'Feminino',
        'cpf': '10000000002',
        'foto_perfil': null,
        'endereco_id': 2,
        'email': 'camila.souza@educame.com',
        'senha': 'seed_demo',
      },
      {
        'id': 3,
        'nome': 'João Pedro',
        'sobrenome': 'Oliveira',
        'data_nascimento': '1985-11-09',
        'genero': 'Masculino',
        'cpf': '10000000003',
        'foto_perfil': null,
        'endereco_id': 3,
        'email': 'joao.oliveira@educame.com',
        'senha': 'seed_demo',
      },
      {
        'id': 4,
        'nome': 'Mariana',
        'sobrenome': 'Alves',
        'data_nascimento': '1992-01-18',
        'genero': 'Feminino',
        'cpf': '10000000004',
        'foto_perfil': null,
        'endereco_id': 4,
        'email': 'mariana.alves@educame.com',
        'senha': 'seed_demo',
      },
      {
        'id': 5,
        'nome': 'Lucas',
        'sobrenome': 'Martins',
        'data_nascimento': '1989-05-30',
        'genero': 'Masculino',
        'cpf': '10000000005',
        'foto_perfil': null,
        'endereco_id': 5,
        'email': 'lucas.martins@educame.com',
        'senha': 'seed_demo',
      },
      {
        'id': 6,
        'nome': 'Ana Beatriz',
        'sobrenome': 'Costa',
        'data_nascimento': '1991-09-12',
        'genero': 'Feminino',
        'cpf': '10000000006',
        'foto_perfil': null,
        'endereco_id': 6,
        'email': 'ana.costa@educame.com',
        'senha': 'seed_demo',
      },
      {
        'id': 7,
        'nome': 'Bruno',
        'sobrenome': 'Ferreira',
        'data_nascimento': '1984-06-03',
        'genero': 'Masculino',
        'cpf': '10000000007',
        'foto_perfil': null,
        'endereco_id': 7,
        'email': 'bruno.ferreira@educame.com',
        'senha': 'seed_demo',
      },
      {
        'id': 8,
        'nome': 'Carla',
        'sobrenome': 'Mendes',
        'data_nascimento': '1988-12-20',
        'genero': 'Feminino',
        'cpf': '10000000008',
        'foto_perfil': null,
        'endereco_id': 8,
        'email': 'carla.mendes@educame.com',
        'senha': 'seed_demo',
      },
      {
        'id': 9,
        'nome': 'Diego',
        'sobrenome': 'Rocha',
        'data_nascimento': '1993-04-07',
        'genero': 'Masculino',
        'cpf': '10000000009',
        'foto_perfil': null,
        'endereco_id': 9,
        'email': 'diego.rocha@educame.com',
        'senha': 'seed_demo',
      },
      {
        'id': 10,
        'nome': 'Fernanda',
        'sobrenome': 'Nunes',
        'data_nascimento': '1986-08-25',
        'genero': 'Feminino',
        'cpf': '10000000010',
        'foto_perfil': null,
        'endereco_id': 10,
        'email': 'fernanda.nunes@educame.com',
        'senha': 'seed_demo',
      },
      {
        'id': 11,
        'nome': 'Mariana',
        'sobrenome': 'Silva',
        'data_nascimento': '2005-02-10',
        'genero': 'Feminino',
        'cpf': '20000000001',
        'foto_perfil': null,
        'endereco_id': null,
        'email': 'mariana.silva@aluno.educame.com',
        'senha': 'seed_demo',
      },
      {
        'id': 12,
        'nome': 'Pedro',
        'sobrenome': 'Santos',
        'data_nascimento': '2004-06-21',
        'genero': 'Masculino',
        'cpf': '20000000002',
        'foto_perfil': null,
        'endereco_id': null,
        'email': 'pedro.santos@aluno.educame.com',
        'senha': 'seed_demo',
      },
      {
        'id': 13,
        'nome': 'Júlia',
        'sobrenome': 'Barbosa',
        'data_nascimento': '2006-10-04',
        'genero': 'Feminino',
        'cpf': '20000000003',
        'foto_perfil': null,
        'endereco_id': null,
        'email': 'julia.barbosa@aluno.educame.com',
        'senha': 'seed_demo',
      },
      {
        'id': 14,
        'nome': 'Gabriel',
        'sobrenome': 'Melo',
        'data_nascimento': '2003-08-17',
        'genero': 'Masculino',
        'cpf': '20000000004',
        'foto_perfil': null,
        'endereco_id': null,
        'email': 'gabriel.melo@aluno.educame.com',
        'senha': 'seed_demo',
      },
      {
        'id': 15,
        'nome': 'Larissa',
        'sobrenome': 'Pereira',
        'data_nascimento': '2005-12-01',
        'genero': 'Feminino',
        'cpf': '20000000005',
        'foto_perfil': null,
        'endereco_id': null,
        'email': 'larissa.pereira@aluno.educame.com',
        'senha': 'seed_demo',
      },
    ];

    const professors = [
      {
        'id': 1,
        'pessoa_id': 1,
        'bio':
            'Professor de Matemática com experiência no ensino médio, ENEM e pré-vestibular. Trabalha com resolução guiada de exercícios e planos personalizados para cada aluno.',
        'diploma': 'Mestre em Matemática pela UFAL',
        'valor_hora_aula': 80.0,
        'ativo': 1,
      },
      {
        'id': 2,
        'pessoa_id': 2,
        'bio':
            'Professora de Física focada em transformar conceitos abstratos em exemplos do cotidiano. Suas aulas combinam teoria, experimentos e preparação para vestibulares.',
        'diploma': 'Mestra em Física pela UFPE',
        'valor_hora_aula': 75.0,
        'ativo': 1,
      },
      {
        'id': 3,
        'pessoa_id': 3,
        'bio':
            'Professor de Química com metodologia clara e visual. Auxilia alunos do ensino médio e superior em química geral, orgânica e resolução de exercícios.',
        'diploma': 'Mestre em Química pela UFS',
        'valor_hora_aula': 70.0,
        'ativo': 1,
      },
      {
        'id': 4,
        'pessoa_id': 4,
        'bio':
            'Professora de Inglês com certificação internacional e experiência com alunos de todos os níveis. As aulas priorizam conversação e objetivos acadêmicos.',
        'diploma': 'Certificação Cambridge CELTA',
        'valor_hora_aula': 65.0,
        'ativo': 1,
      },
      {
        'id': 5,
        'pessoa_id': 5,
        'bio':
            'Desenvolvedor e professor de programação. Ensina lógica, algoritmos e desenvolvimento de aplicações por meio de projetos práticos e acompanhamento individual.',
        'diploma': 'Bacharel em Ciência da Computação pela UFAL',
        'valor_hora_aula': 90.0,
        'ativo': 1,
      },
      {
        'id': 6,
        'pessoa_id': 6,
        'bio':
            'Professora de Redação e Língua Portuguesa especializada em ENEM. Trabalha argumentação, repertório sociocultural e revisão detalhada de textos.',
        'diploma': 'Mestra em Letras pela UFAL',
        'valor_hora_aula': 60.0,
        'ativo': 1,
      },
      {
        'id': 7,
        'pessoa_id': 7,
        'bio':
            'Professor de História e Geografia com aulas contextualizadas e materiais visuais. Atua na preparação para provas escolares, ENEM e vestibulares.',
        'diploma': 'Especialista em História do Brasil pela UFRPE',
        'valor_hora_aula': 68.0,
        'ativo': 1,
      },
      {
        'id': 8,
        'pessoa_id': 8,
        'bio':
            'Professora de Biologia e Química com experiência em ensino médio. Utiliza mapas mentais e questões comentadas para facilitar a aprendizagem.',
        'diploma': 'Mestra em Ciências Biológicas pela UFAL',
        'valor_hora_aula': 72.0,
        'ativo': 1,
      },
      {
        'id': 9,
        'pessoa_id': 9,
        'bio':
            'Professor de Geografia e História que relaciona os conteúdos com acontecimentos atuais. Oferece acompanhamento escolar e preparação para o ENEM.',
        'diploma': 'Licenciado em Geografia pela UNEAL',
        'valor_hora_aula': 66.0,
        'ativo': 1,
      },
      {
        'id': 10,
        'pessoa_id': 10,
        'bio':
            'Professora de Estatística e Cálculo para ensino médio e superior. Apresenta conceitos passo a passo e utiliza exemplos aplicados à realidade do aluno.',
        'diploma': 'Doutora em Estatística pela UFPE',
        'valor_hora_aula': 85.0,
        'ativo': 1,
      },
    ];

    const disciplines = [
      {
        'id': 1,
        'nome': 'Matemática',
        'descricao': 'Álgebra, geometria e fundamentos matemáticos.',
        'ativo': 1,
      },
      {
        'id': 2,
        'nome': 'Física',
        'descricao': 'Mecânica, eletricidade, óptica e termodinâmica.',
        'ativo': 1,
      },
      {
        'id': 3,
        'nome': 'Química',
        'descricao': 'Química geral, orgânica e físico-química.',
        'ativo': 1,
      },
      {
        'id': 4,
        'nome': 'Inglês',
        'descricao': 'Conversação, gramática e compreensão textual.',
        'ativo': 1,
      },
      {
        'id': 5,
        'nome': 'Programação',
        'descricao': 'Lógica, algoritmos e desenvolvimento de software.',
        'ativo': 1,
      },
      {
        'id': 6,
        'nome': 'Redação',
        'descricao': 'Produção textual, argumentação e redação do ENEM.',
        'ativo': 1,
      },
      {
        'id': 7,
        'nome': 'Biologia',
        'descricao': 'Citologia, genética, ecologia e fisiologia.',
        'ativo': 1,
      },
      {
        'id': 8,
        'nome': 'História',
        'descricao': 'História geral, do Brasil e contemporânea.',
        'ativo': 1,
      },
      {
        'id': 9,
        'nome': 'Geografia',
        'descricao': 'Geografia física, humana e geopolítica.',
        'ativo': 1,
      },
      {
        'id': 10,
        'nome': 'Português',
        'descricao': 'Gramática, literatura e interpretação de texto.',
        'ativo': 1,
      },
      {
        'id': 11,
        'nome': 'Estatística',
        'descricao': 'Probabilidade, análise de dados e inferência.',
        'ativo': 1,
      },
      {
        'id': 12,
        'nome': 'Cálculo',
        'descricao': 'Limites, derivadas e integrais.',
        'ativo': 1,
      },
    ];

    const professorDisciplines = [
      {'professor_id': 1, 'disciplina_id': 1},
      {'professor_id': 1, 'disciplina_id': 11},
      {'professor_id': 1, 'disciplina_id': 12},
      {'professor_id': 2, 'disciplina_id': 2},
      {'professor_id': 2, 'disciplina_id': 1},
      {'professor_id': 3, 'disciplina_id': 3},
      {'professor_id': 3, 'disciplina_id': 7},
      {'professor_id': 4, 'disciplina_id': 4},
      {'professor_id': 4, 'disciplina_id': 10},
      {'professor_id': 5, 'disciplina_id': 5},
      {'professor_id': 5, 'disciplina_id': 1},
      {'professor_id': 6, 'disciplina_id': 6},
      {'professor_id': 6, 'disciplina_id': 10},
      {'professor_id': 7, 'disciplina_id': 8},
      {'professor_id': 7, 'disciplina_id': 9},
      {'professor_id': 8, 'disciplina_id': 7},
      {'professor_id': 8, 'disciplina_id': 3},
      {'professor_id': 9, 'disciplina_id': 9},
      {'professor_id': 9, 'disciplina_id': 8},
      {'professor_id': 10, 'disciplina_id': 11},
      {'professor_id': 10, 'disciplina_id': 12},
      {'professor_id': 10, 'disciplina_id': 1},
    ];

    for (final address in addresses) {
      batch.insert(
        'endereco',
        address,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    for (final person in people) {
      batch.insert(
        'pessoa',
        person,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    for (var index = 0; index < 5; index++) {
      batch.insert('aluno', {
        'id': index + 1,
        'pessoa_id': index + 11,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    for (final professor in professors) {
      batch.insert(
        'professor',
        professor,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    for (final discipline in disciplines) {
      batch.insert(
        'disciplina',
        discipline,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    for (final relation in professorDisciplines) {
      batch.insert(
        'professor_disciplina',
        relation,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    const primaryDisciplineIds = [1, 2, 3, 4, 5, 6, 8, 7, 9, 11];
    const reviewScores = [5.0, 4.8, 4.6];
    const reviewComments = [
      'Excelente professor! Explica com clareza, tem paciência e adapta a aula às dificuldades do aluno.',
      'A aula foi muito organizada e prática. Os exemplos ajudaram bastante na compreensão do conteúdo.',
      'Ótima experiência. Recebi materiais complementares e orientações que melhoraram meu desempenho.',
      'Professor atencioso e pontual. Consegui tirar minhas dúvidas e avançar nos exercícios.',
      'Metodologia dinâmica e conteúdo bem explicado. Recomendo para quem busca acompanhamento individual.',
    ];

    var lessonId = 1;
    for (var professorId = 1; professorId <= professors.length; professorId++) {
      for (var reviewIndex = 0; reviewIndex < 3; reviewIndex++) {
        final studentId = ((professorId + reviewIndex - 1) % 5) + 1;
        final lessonDate = DateTime(2026, 7, lessonId);
        final lessonStart = DateTime(
          lessonDate.year,
          lessonDate.month,
          lessonDate.day,
          14 + reviewIndex,
        );
        final lessonEnd = lessonStart.add(const Duration(hours: 1));

        batch.insert('aula', {
          'id': lessonId,
          'aluno_id': studentId,
          'professor_id': professorId,
          'disciplina_id': primaryDisciplineIds[professorId - 1],
          'inicio': lessonStart.toIso8601String(),
          'fim': lessonEnd.toIso8601String(),
          'status': 'concluida',
          'modalidade': 'online',
          'observacao': 'Aula de demonstração criada pelo seed inicial.',
        }, conflictAlgorithm: ConflictAlgorithm.ignore);

        batch.insert('avaliacao', {
          'id': lessonId,
          'aula_id': lessonId,
          'aluno_id': studentId,
          'professor_id': professorId,
          'nota': reviewScores[reviewIndex],
          'comentario': reviewComments[(lessonId - 1) % reviewComments.length],
          'data_avaliacao': lessonDate.toIso8601String(),
        }, conflictAlgorithm: ConflictAlgorithm.ignore);

        lessonId++;
      }
    }

    var availabilityId = 1;
    for (var professorId = 1; professorId <= professors.length; professorId++) {
      for (var dayIndex = 0; dayIndex < 6; dayIndex++) {
        final startHour = 8 + ((professorId + dayIndex) % 5) * 2;
        final start = DateTime(2026, 8, 3 + dayIndex, startHour);
        final end = start.add(const Duration(hours: 1));

        batch.insert('disponibilidade', {
          'id': availabilityId,
          'professor_id': professorId,
          'inicio': start.toIso8601String(),
          'fim': end.toIso8601String(),
          'status': 'disponivel',
          'observacao': 'Horário para aula remota por videoconferência.',
        }, conflictAlgorithm: ConflictAlgorithm.ignore);

        availabilityId++;
      }
    }

    await batch.commit(noResult: true);
  }

  static Future<void> close() async {
    var currentDatabase = _database;
    final pendingDatabase = _databaseFuture;

    if (currentDatabase == null && pendingDatabase != null) {
      try {
        currentDatabase = await pendingDatabase;
      } catch (_) {
        _databaseFuture = null;
        return;
      }
    }

    if (currentDatabase == null) {
      return;
    }

    await currentDatabase.close();
    _database = null;
    _databaseFuture = null;
  }
}
