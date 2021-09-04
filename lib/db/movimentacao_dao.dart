import 'package:pataka/db/dao.dart';
import 'package:pataka/db/conta_dao.dart';
import 'package:pataka/db/categoria_dao.dart';
import 'package:pataka/models/movimentacao.dart';
import 'db.dart';

// Define a classe MovimentacaoDao.
// Utiliza os métodos herdados de Dao.
// É necessário apenas informar o nome da tabela no BD e uma função
// que cria uma Movimentacao a partir de um map.
class MovimentacaoDao extends Dao<Movimentacao> {
  CategoriaDao catDao = CategoriaDao();
  ContaDao contaDao = ContaDao();

  /// Construtor.
  MovimentacaoDao() : super(table: 'movimentacoes', fromMapCreator: (map) => Movimentacao.fromMap(map));

  /// Busca uma movimentação.
  Future<Movimentacao?> get(int id) async {
    Movimentacao? mov = await super.get(id);
    if (mov != null) {
      mov = await _getRelations(mov);
    }

    return mov;
  }

  /// Busca todas movimentações.
  Future<List<Movimentacao>> getAll() async {
    List<Movimentacao> movs = await super.getAll();
    for (int i = 0; i < movs.length; i++) {
      movs[i] = await _getRelations(movs[i]);
    }

    return movs;
  }

  /// Busca movimentações por ano e mês.
  Future<List<Movimentacao>> getAllPorMes(int ano, int mes) async {
    String anoStr = ano.toString();
    String mesStr = mes.toString().padLeft(2, '0');
    String anoMes = anoStr + '-' + mesStr + '-';

    final db = await DB.getDB();
    List<Map<String, dynamic>> maps = await db.query(
        table,
        orderBy: 'vencimento ASC',
        where: 'vencimento LIKE  ?',
        whereArgs: [anoMes + '%']
    );

    List<Movimentacao> movs = List.generate(maps.length, (i) {
      return fromMapCreator(maps[i]);
    });

    if (movs.length == 0) return movs;

    for (int i = 0; i < movs.length; i++) {
      movs[i] = await _getRelations(movs[i]);
    }

    return movs;
  }

  /// Adiciona models relacionados à movimentação.
  Future<Movimentacao> _getRelations(Movimentacao mov) async {
    mov.categoria = (await catDao.get(mov.categoriaId))!;

    if (mov.contaOrigemId != null) {
      mov.contaOrigem = await contaDao.get(mov.contaOrigemId!);
    }

    if (mov.contaDestinoId != null) {
      mov.contaDestino = await contaDao.get(mov.contaDestinoId!);
    }

    return mov;
  }
}
