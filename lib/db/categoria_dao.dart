import 'package:pataka/db/dao.dart';
import 'package:pataka/models/categoria.dart';

class CategoriaDao extends Dao<Categoria> {
  CategoriaDao() : super(table: 'categorias', fromMapCreator: (map) => Categoria.fromMap(map));
}