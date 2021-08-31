import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Esta classe realiza as operações com o banco de dados.
class DB {
  static const int _version = 2;

  static void _onCreate(db, version) async {
    var batch = db.batch();
    batch.execute('CREATE TABLE categorias (id INTEGER PRIMARY KEY, nome TEXT, icone TEXT, cor TEXT)');
    batch.execute('CREATE TABLE contas (id INTEGER PRIMARY KEY, nome TEXT, icone TEXT, valor_inicial REAL)');
    await batch.commit();
  }

  static void _onUpgrade(db, oldVersion, newVersion) async {
    var batch = db.batch();
    if (oldVersion == 1) {
      batch.execute('CREATE TABLE contas (id INTEGER PRIMARY KEY, nome TEXT, icone TEXT, valor_inicial REAL)');
    }
    await batch.commit();
  }

  static Future<Database> getDB() async {
    final String path = join(await getDatabasesPath(), 'pataka.db');

    return openDatabase(path, version:_version, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }
}

