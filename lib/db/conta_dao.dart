import 'package:pataka/db/dao.dart';
import 'package:pataka/models/conta.dart';

// Define a classe ContaDao.
// Utiliza os métodos herdados de Dao.
// É necessário apenas informar o nome da tabela no BD e uma função
// que cria uma Conta a partir de um map.
class ContaDao extends Dao<Conta> {
  ContaDao() : super(table: 'contas', fromMapCreator: (map) => Conta.fromMap(map));
}