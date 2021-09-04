import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pataka/components/main_drawer.dart';
import 'package:pataka/components/expandable_fab.dart';
import 'package:pataka/db/categoria_dao.dart';
import 'package:pataka/db/conta_dao.dart';
import 'package:pataka/db/movimentacao_dao.dart';
import 'package:pataka/models/movimentacao.dart';
import 'package:pataka/models/conta.dart';
import 'package:pataka/models/categoria.dart';
import 'movimentacao_form.dart';

class Movimentacoes extends StatefulWidget {
  final int _ano;
  final int _mes;

  Movimentacoes(this._ano, this._mes);

  @override
  _MovimentacoesState createState() => _MovimentacoesState(_ano, _mes);
}

class _MovimentacoesState extends State<Movimentacoes> {
  int _ano;
  int _mes;
  DateTime date;
  DateFormat fmt = DateFormat('MMMM y');
  List<String> _erros = <String>[];

  _MovimentacoesState(this._ano, this._mes) : date = DateTime(_ano, _mes);

  @override
  void initState() {
    super.initState();
    _getErros();
  }

  @override
  Widget build(BuildContext context) {
    date = DateTime(_ano, _mes);

    return Scaffold(
        appBar: AppBar(title: Text('Movimentações')),
        drawer: MainDrawer(),
        body: _erros.length > 0 ? _getErrosWidget(_erros) : _getMovimentacoesWidget(date),
        floatingActionButton: _erros.length == 0 ? _getFAB() : null
    );
  }

  // Verifica se existem contas e categorias e define
  // mensagens de erro de acordo.
  _getErros() async {
    ContaDao contaDao = ContaDao();
    CategoriaDao categoriaDao = CategoriaDao();
    var erros = <String>[];

    List<Conta> contas = await contaDao.getAll();
    if (contas.length == 0) {
      erros.add(
          'Não há contas cadastradas. Adicione ao menos uma para cadastrar movimentações.');
    }

    List<Categoria> cats = await categoriaDao.getAll();
    if (cats.length == 0) {
      erros.add(
          'Não há categorias cadastradas. Adicione ao menos uma para cadastrar movimentações.');
    }

    setState(() {
      _erros = erros;
    });
  }

  // Retorna os erros como um widget.
  Widget _getErrosWidget(List<String> erros) {
    return Column(
        children: [
          SizedBox(height: 20),
          ...erros.map<Widget>((s) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(s, style: TextStyle(color: Colors.red)),
            );
          }).toList()
        ]
    );
  }

  Widget _getFAB() {
    return ExpandableFab(
      distance: 75,
      children: [
        ActionButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovimentacaoForm(tipo: 'receita')));
              setState(() {});
            }
        ),
        ActionButton(
            icon: Icon(Icons.remove),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovimentacaoForm(tipo: 'despesa')));
              setState(() {});
            }
        ),
      ]
    );
  }

  // Retorna as movimentações como um widget
  Widget _getMovimentacoesWidget(DateTime date) {
    String nomeMes = toBeginningOfSentenceCase(fmt.format(date)).toString();

    return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white54
                )
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _btnAnterior(),
                Text(nomeMes, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                _btnProximo()
              ],
            ),
          ),
          Divider(height: 1,),
          _futureBuilderMovimentacoes()
        ],
      );
  }

  Widget _btnAnterior() {
    return IconButton(
        icon: const Icon(Icons.chevron_left),
        onPressed: () {
          setState(() {
            if (_mes == 1) {
              _mes = 12;
              _ano -= 1;
            } else {
              _mes -= 1;
            }
          });
        },
    );
  }

  Widget _btnProximo() {
    return IconButton(
      icon: const Icon(Icons.chevron_right),
      onPressed: () {
        setState(() {
          if (_mes == 12) {
            _mes = 1;
            _ano += 1;
          } else {
            _mes += 1;
          }
        });
      },
    );
  }

  Widget _futureBuilderMovimentacoes() {
    MovimentacaoDao movsDao = MovimentacaoDao();

    return FutureBuilder<List<Movimentacao>>(
      // Usa o DAO de categorias para popular o FutureBuilder.
        future: movsDao.getAllPorMes(_ano, _mes),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
          // Exibe um CircularProgressIndicator enquanto aguarda a conexão.
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text('Carregando...')
                  ],
                ),
              );
          // Constroi a lista com widgets para as categorias.
            case ConnectionState.done:
              final List<Movimentacao>? movs = snapshot.data;
              // Se não houverem movimentações, exibe uma mensagem para o usuário.
              if (movs == null || movs.length == 0) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text('Nenhuma movimentação encontrada.'),
                  ),
                );
              }
              return Expanded(child: _listaMovimentacoes(movs));
          // Em outros casos, exibe no log.
            default:
              debugPrint(snapshot.connectionState.toString());
              break;
          }
          return Text('Problemas ao gerar a lista de categorias.');
        }
    );
  }

  // Retorna um ListView com um widget para cada categoria.
  Widget _listaMovimentacoes(List<Movimentacao> movs) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: movs.length + 1,
      itemBuilder: (context, index) {
        if (index < movs.length) {
          final Movimentacao mov = movs[index];
          return MovimentacaoListItem(mov, this);
        }
        return _somatorioMovs(movs);
      },
    );
  }

  Widget _somatorioMovs(List<Movimentacao> movs) {
    final fmt = NumberFormat.simpleCurrency(locale: 'pt_BR');

    double total = 0;
    movs.forEach((mov) {
      if (mov.contaOrigemId != null) {
        total -= mov.valor;
      } else if (mov.contaDestinoId != null) {
        total += mov.valor;
      }
    });

    Color curColor = Colors.grey;
    if (total > 0) curColor = Colors.green;
    if (total < 0) curColor = Colors.red;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('Total: ',
            style: TextStyle(fontWeight: FontWeight.bold)
          ),
          Text(fmt.format(total),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: curColor,
              fontSize: 20
            ),
          )
        ]
      ),
    );
  }
}

// Esta classe representa um widget para cada movimentação.
class MovimentacaoListItem extends StatelessWidget {
  // Armazena a categoria.
  final Movimentacao _mov;

  // Armazena o State, para podemos usar seu método setState().
  final State<Movimentacoes> _state;

  MovimentacaoListItem(this._mov, this._state);

  @override
  Widget build(BuildContext context) {
    final curFmt = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final dayFmt = DateFormat('d - E');
    Color curColor = _mov.contaOrigemId != null ? Colors.red : Colors.green;

    // Cria os dados e as cores para o ícone da categoria.
    IconData iconData = IconData(int.parse(_mov.categoria.icone), fontFamily: 'MaterialIcons');
    Color corBg = Color(int.parse(_mov.categoria.cor));
    Color corFg = const Color(0xffffffff);

    // Cria um CircleAvatar com os dados acima.
    Widget iconAvatar = CircleAvatar(
      child: Icon(iconData, color: corFg),
      backgroundColor: corBg,
    );

    // Retorna um ListTile representando a categoria.
    // É exibido o avatar, o nome, e um PopupMenu.
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(20, 0, 10, 0),
          leading: iconAvatar,
          title: Text(_mov.nome),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(curFmt.format(_mov.valor), style: TextStyle(color: curColor)),
              Text(dayFmt.format(DateTime.parse(_mov.vencimento)))
            ],
          ),
          trailing: _menu(context, _state, _mov),
        ),
        Divider(height: 1,)
      ],
    );
  }

  // Retorna um PopupMenu para a categoria.
  Widget _menu(context, state, mov) {
    return PopupMenuButton(
        onSelected: (ItensMenuMovimentacao selecionado) async {
          switch(selecionado) {
          // Caso a opção de editar seja selecionada, navega para o formulário
          // da categoria, passando-a como parâmetro.
          // Ao retornar, atualiza o estado do State.
            case ItensMenuMovimentacao.editar:
              await Navigator.push(context, MaterialPageRoute(builder: (context) => MovimentacaoForm(movimentacao: _mov, tipo: 'receita')));
              state.setState(() {});
              break;
          // Caso a opção excluir seja selecionada, exibe uma janela de
          // confirmação. Se confirmado, exclui a categoria e atualiza o State.
            case ItensMenuMovimentacao.excluir:
              bool confirmed = await _showDeleteConfirm(context);
              if (confirmed) {
                state.setState(() {
                  MovimentacaoDao dao = MovimentacaoDao();
                  dao.delete(mov);
                });
              }
              break;
          }
        },
        // Constroi o PopupMenu.
        itemBuilder: (BuildContext context) => <PopupMenuItem<ItensMenuMovimentacao>>[
          const PopupMenuItem(
              value: ItensMenuMovimentacao.editar,
              child: Text('Editar')
          ),
          const PopupMenuItem(
              value: ItensMenuMovimentacao.excluir,
              child: Text('Excluir')
          )
        ]
    );
  }

  // Exibe a janela de confirmação e aguarda o usuário selecionar uma opção.
  _showDeleteConfirm(BuildContext context) async {  // set up the buttons
    Widget btnNao = TextButton(
      child: Text("Não"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    Widget btnSim = TextButton(
      child: Text("Sim"),
      onPressed: () {
        Navigator.of(context).pop(true);
      },
    );  // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Atenção"),
      content: Text("Deseja mesmo excluir esta movimentação?"),
      actions: [
        btnNao,
        btnSim,
      ],
    );  // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

enum ItensMenuMovimentacao { editar, excluir }