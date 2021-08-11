import 'package:flutter/material.dart';
import 'package:pataka/components/main_drawer.dart';
import 'package:pataka/db/categoria_dao.dart';
import 'package:pataka/models/categoria.dart';
import 'package:pataka/screens/categoria_form.dart';

// Esta classe representa a tela de cadastro de categorias.
class Categorias extends StatefulWidget {
  @override
  _CategoriasState createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categorias')),
      drawer: MainDrawer(),
      // Para construir o body, foi usado um FutureBuilder, já que as categorias
      // vêm do banco de dados.
      body: _futureBuilderCategorias(),
      // O FAB deste scaffold abre o formulário de criação de nova categoria.
      // Ao retornar dele, o estado do widget é atualizado.
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriaForm()));
          setState(() {});
        }
      ),
    );
  }

  Widget _futureBuilderCategorias() {
    CategoriaDao categoriaDao = CategoriaDao();

    return FutureBuilder<List<Categoria>>(
      // Usa o DAO de categorias para popular o FutureBuilder.
      future: categoriaDao.getAll(),
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
            break;
          // Constroi a lista com widgets para as categorias.
          case ConnectionState.done:
            final List<Categoria>? categorias = snapshot.data;
            // Se não houverem categorias, exibe uma mensagem para o usuário.
            if (categorias == null || categorias.length == 0) {
              return Center(
                child: Text('Nenhuma categoria encontrada.'),
              );
            }
            // Retorna um ListView com um widget para cada categoria.
            return ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final Categoria c = categorias[index];
                return CategoriaListItem(c, this);
              },
            );
            break;
          // Em outros casos, exibe no log.
          default:
            debugPrint(snapshot.connectionState.toString());
            break;
        }
        return Text('Problemas ao gerar a lista de categorias.');
      }
    );
  }
}

// Esta classe representa um widget para cada categoria.
class CategoriaListItem extends StatelessWidget {
  // Armazena a categoria.
  final Categoria _categoria;

  // Armazena o State, para podemos usar seu método setState().
  final State<Categorias> _state;

  CategoriaListItem(this._categoria, this._state);

  @override
  Widget build(BuildContext context) {
    // Cria os dados e as cores para o ícone da categoria.
    IconData iconData = IconData(int.parse(_categoria.icone), fontFamily: 'MaterialIcons');
    Color corBg = Color(int.parse(_categoria.cor));
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
          contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 5),
          leading: iconAvatar,
          title: Text(_categoria.nome),
          trailing: _menu(context, _state, _categoria),
        ),
        Divider()
      ],
    );
  }

  // Retorna um PopupMenu para a categoria.
  Widget _menu(context, state, categoria) {
    return PopupMenuButton(
      onSelected: (ItensMenuCategoria selecionado) async {
        switch(selecionado) {
          // Caso a opção de editar seja selecionada, navega para o formulário
          // da categoria, passando-a como parâmetro.
          // Ao retornar, atualiza o estado do State.
          case ItensMenuCategoria.editar:
            await Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriaForm(_categoria)));
            state.setState(() {});
            break;
          // Caso a opção excluir seja selecionada, exibe uma janela de
          // confirmação. Se confirmado, exclui a categoria e atualiza o State.
          case ItensMenuCategoria.excluir:
            bool confirmed = await _showDeleteConfirm(context);
            if (confirmed) {
              state.setState(() {
                CategoriaDao dao = CategoriaDao();
                dao.delete(categoria);
              });
            }
            break;
        }
      },
      // Constroi o PopupMenu.
      itemBuilder: (BuildContext context) => <PopupMenuItem<ItensMenuCategoria>>[
        const PopupMenuItem(
          value: ItensMenuCategoria.editar,
          child: Text('Editar')
        ),
        const PopupMenuItem(
            value: ItensMenuCategoria.excluir,
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
      content: Text("Deseja mesmo excluir esta categoria?"),
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

enum ItensMenuCategoria { editar, excluir }