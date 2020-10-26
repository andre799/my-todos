import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbRepository{
  
  Database db;
  String tasksTable = 'tasks';
  String userTable = 'users';

  // Verifica existencia do arquivo do banco (cria quando não existente) e retorna seu diretório  
  Future<String> getDatabasePath() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "my_tasks.db");

    //make sure the folder exists
    if (!(await Directory(dirname(path)).exists())) {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  // Cria tabela de tarefas caso não exista
  Future<void> createTaskssTable(Database db) async {
    final taskSql = '''CREATE TABLE IF NOT EXISTS $tasksTable
    (
      id INTEGER PRIMARY KEY,
      userId INTEGER NOT NULL,
      nome TEXT NOT NULL,
      dataEntrega TEXT NOT NULL,
      dataConclusao TEXT
    )''';

    await db.execute(taskSql);
  }

  // Cria tabela de usuários caso não exista
  Future<void> createUserTables(Database db) async {
    final taskSql = '''CREATE TABLE IF NOT EXISTS $userTable
    (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      birthdate TEXT NOT NULL,
      cpf TEXT,
      cep TEXT,
      address TEXT,
      number TEXT,
      email TEXT NOT NULL,
      password TEXT NOT NULL
    )''';

    await db.execute(taskSql);
  }

  // Inicia o banco de dados
  Future<void> initDatabase() async {
    final path = await getDatabasePath();
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print(db);
  }

  // Função chamada ao criar bd
  Future<void> onCreate(Database db, int version) async {
    await createTaskssTable(db);
    await createUserTables(db);
  }

}