import 'package:pataka/db/db.dart';
import 'package:pataka/models/model.dart';
import 'package:sqflite/sqflite.dart';

abstract class Dao<M extends Model> {
  final String table;
  final M Function(Map<String, dynamic>) fromMapCreator;

  Dao({required this.table, required this.fromMapCreator});

  Future<M> save(M model) async {
    final db = await DB.getDB();
    int id = await db.insert(table, model.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    model.setId(id);
    return model;
  }

  Future<M> update(M model) async {
    final db = await DB.getDB();
    await db.update(table, model.toMap(), where: 'id = ?', whereArgs: [model.getId()]);
    return model;
  }

  Future<M?> get(int id) async {
    final db = await DB.getDB();
    List<Map<String, dynamic>> maps = await db.query(table, where: 'id = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return fromMapCreator(maps.first);
    }
    return null;
  }

  Future<List<M>> getAll() async {
    final db = await DB.getDB();
    List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (i) {
      return fromMapCreator(maps[i]);
    });
  }

  void delete(M model) async {
    final db = await DB.getDB();
    await db.delete(table, where: 'id = ?', whereArgs: [model.getId()]);
  }
}