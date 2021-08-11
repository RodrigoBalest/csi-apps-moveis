import 'package:pataka/db/dao.dart';
import 'package:pataka/models/categoria.dart';

// Define a classe CategoriaDao.
// Utiliza os métodos herdados de Dao.
// É necessário apenas informar o nome da tabela no BD e uma função
// que cria uma Categoria a partir de um map.
class CategoriaDao extends Dao<Categoria> {
  CategoriaDao() : super(table: 'categorias', fromMapCreator: (map) => Categoria.fromMap(map));
}