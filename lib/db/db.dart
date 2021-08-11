import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Esta classe realiza as operações com o banco de dados.
class DB {
  static const int _version = 1;

  static void _onCreate(db, version) {
    db.execute('CREATE TABLE categorias (id INTEGER PRIMARY KEY, nome TEXT, icone TEXT, cor TEXT)');
  }

  static Future<Database> getDB() async {
    final String path = join(await getDatabasesPath(), 'pataka.db');

    return openDatabase(path, version:_version, onCreate: _onCreate);
  }
}

