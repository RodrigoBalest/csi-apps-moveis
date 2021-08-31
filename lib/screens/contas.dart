import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pataka/components/main_drawer.dart';
import 'package:pataka/db/conta_dao.dart';
import 'package:pataka/models/conta.dart';
import 'conta_form.dart';

// Esta classe representa a tela de cadastro de contas.
class Contas extends StatefulWidget {
  @override
  _ContasState createState() => _ContasState();
}

class _ContasState extends State<Contas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contas')),
      drawer: MainDrawer(),
      // Para construir o body, foi usado um FutureBuilder, já que as categorias
      // vêm do banco de dados.
      body: _futureBuilderContas(),
      // O FAB deste scaffold abre o formulário de criação de nova categoria.
      // Ao retornar dele, o estado do widget é atualizado.
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.push(
                context, MaterialPageRoute(builder: (context) => ContaForm()));
            setState(() {});
          }
      ),
    );
  }

  Widget _futureBuilderContas() {
    ContaDao contaDao = ContaDao();

    return FutureBuilder<List<Conta>>(
      // Usa o DAO de contas para popular o FutureBuilder.
        future: contaDao.getAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
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
              break;
          // Constroi a lista com widgets para as contas.
            case ConnectionState.done:
              final List<Conta>? contas = snapshot.data;
              // Se não houverem contas, exibe uma mensagem para o usuário.
              if (contas == null || contas.length == 0) {
                return Center(
                  child: Text('Nenhuma conta encontrada.'),
                );
              }
              // Retorna um ListView com um widget para cada categoria.
              return ListView.builder(
                itemCount: contas.length,
                itemBuilder: (context, index) {
                  final Conta c = contas[index];
                  return ContaListItem(c, this);
                },
              );
              break;
          // Em outros casos, exibe no log.
            default:
              debugPrint(snapshot.connectionState.toString());
              break;
          }
          return Text('Problemas ao gerar a lista de contas.');
        }
    );
  }
}


class ContaListItem extends StatelessWidget {

  final Conta _c;
  final State<Contas> _state;
  final fmt = NumberFormat.simpleCurrency(locale: 'pt_BR');

  ContaListItem(this._c, this._state);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: SvgPicture.asset('logos/' + _c.icone + '.svg', width: 50, height: 50),
          title: Text(_c.nome, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          subtitle: _dadosConta(),
          trailing: _menu(context, _state, _c),
        ),
      )
    );
  }

  Widget _dadosConta() {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Valor inicial:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(fmt.format(_c.valorInicial))
            ]
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Valor atual:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(fmt.format(0))
          ],
        ),
      ],
    );
  }

  // Retorna um PopupMenu para a categoria.
  Widget _menu(context, state, conta) {
    return PopupMenuButton(
        onSelected: (ItensMenuConta selecionado) async {
          switch(selecionado) {
            // Caso a opção de editar seja selecionada, navega para o formulário
            // da conta, passando-a como parâmetro.
            // Ao retornar, atualiza o estado do State.
            case ItensMenuConta.editar:
              await Navigator.push(context, MaterialPageRoute(builder: (context) => ContaForm(_c)));
              state.setState(() {});
              break;
            // Caso a opção excluir seja selecionada, exibe uma janela de
            // confirmação. Se confirmado, exclui a conta e atualiza o State.
            case ItensMenuConta.excluir:
              bool confirmed = await _showDeleteConfirm(context);
              if (confirmed) {
                state.setState(() {
                  ContaDao dao = ContaDao();
                  dao.delete(conta);
                });
              }
              break;
          }
        },
        // Constroi o PopupMenu.
        itemBuilder: (BuildContext context) => <PopupMenuItem<ItensMenuConta>>[
          const PopupMenuItem(
              value: ItensMenuConta.editar,
              child: Text('Editar')
          ),
          const PopupMenuItem(
              value: ItensMenuConta.excluir,
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
      content: Text("Deseja mesmo excluir esta conta?"),
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

enum ItensMenuConta { editar, excluir }