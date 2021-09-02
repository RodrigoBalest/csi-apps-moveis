import 'package:pataka/db/dao.dart';
import 'package:pataka/models/movimentacao.dart';
import 'db.dart';

// Define a classe MovimentacaoDao.
// Utiliza os métodos herdados de Dao.
// É necessário apenas informar o nome da tabela no BD e uma função
// que cria uma Movimentacao a partir de um map.
class MovimentacaoDao extends Dao<Movimentacao> {
  MovimentacaoDao() : super(table: 'movimentacoes', fromMapCreator: (map) => Movimentacao.fromMap(map));

  Future<List<Movimentacao>> getAllPorMes(int ano, int mes) async {
    String anoStr = ano.toString();
    String mesStr = mes.toString().padLeft(2, '0');
    String anoMes = anoStr + '-' + mesStr + '-';

    final db = await DB.getDB();
    List<Map<String, dynamic>> maps = await db.query(table, orderBy: 'vencimento ASC', where: 'vencimento LIKE  ?', whereArgs: [anoMes+'%']);

    return List.generate(maps.length, (i) {
      return fromMapCreator(maps[i]);
    });
  }
}