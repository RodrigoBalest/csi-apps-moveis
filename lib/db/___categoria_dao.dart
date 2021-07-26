import 'package:pataka/db/db.dart';
import 'package:pataka/models/categoria.dart';
import 'package:sqflite/sqflite.dart';

class CategoriaDao {
  static const String table = 'categorias';

  static void save(Categoria cat) async {
    final db = await DB.getDB();
    await db.insert(table, cat.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  
  static void update(Categoria cat) async {
    final db = await DB.getDB();
    await db.update(table, cat.toMap(), where: 'id = ?', whereArgs: [cat.id]);
  }

  static Future<Categoria?> get(int id) async {
    final db = await DB.getDB();
    List<Map<String, dynamic>> maps = await db.query(table, where:'id = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return Categoria.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<Categoria>> getAll() async {
    final db = await DB.getDB();
    List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (i) {
      return Categoria.fromMap(maps[i]);
    });
  }

  static void delete(Categoria cat) async {
    final db = await DB.getDB();
    await db.delete(table, where: 'id = ?', whereArgs: [cat.id]);
  }
}