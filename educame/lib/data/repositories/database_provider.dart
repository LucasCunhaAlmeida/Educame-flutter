import 'package:sqflite/sqflite.dart';

import '../app_database.dart';

typedef DatabaseProvider = Future<Database> Function();

Future<Database> appDatabaseProvider() => AppDatabase.database;
