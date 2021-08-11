import 'package:flutter/material.dart';
import 'package:pataka/components/main_drawer.dart';
import 'package:pataka/db/categoria_dao.dart';
import 'package:pataka/models/categoria.dart';
import 'package:pataka/screens/categoria_form.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
      body: _futureBuilderCategorias(),
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
      future: categoriaDao.getAll(),
      builder: (context, snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Carregando')
                ],
              ),
            );
            break;
          case ConnectionState.done:
            final List<Categoria>? categorias = snapshot.data;
            if (categorias == null || categorias.length == 0) {
              return Center(
                child: Text('Nenhuma categoria encontrada.'),
              );
            }
            return ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final Categoria c = categorias[index];
                return CategoriaListItem(c, this);
              },
            );
            break;
          default:
            debugPrint(snapshot.connectionState.toString());
            break;
        }
        return Text('Problemas ao gerar a lista de categorias.');
      }
    );
  }
}

class CategoriaListItem extends StatelessWidget {
  final Categoria _categoria;
  final State<Categorias> _state;

  CategoriaListItem(this._categoria, this._state);

  @override
  Widget build(BuildContext context) {
    IconData iconData = IconData(int.parse(_categoria.icone), fontFamily: 'MaterialIcons');
    Color corBg = Color(int.parse(_categoria.cor));
    Color corFg = const Color(0xffffffff);

    Widget iconAvatar = CircleAvatar(
      child: Icon(iconData, color: corFg),
      backgroundColor: corBg,
    );

    return Column(
      children: [
        ListTile(
          leading: iconAvatar,
          title: Text(_categoria.nome + ' (' + _categoria.id.toString() + ')'),
          trailing: _menu(context, _state),
        ),
        Divider()
      ],
    );
  }

  Widget _menu(context, state) {
    return PopupMenuButton(
      onSelected: (ItensMenuCategoria selecionado) async {
        switch(selecionado) {
          case ItensMenuCategoria.editar:
            await Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriaForm(_categoria)));
            state.setState(() {});
            break;
          case ItensMenuCategoria.excluir:
            bool v = await _showAlertDialog(context);
            debugPrint('Fechou diálogo.' + v.toString());
            break;
        }
      },
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

  _showAlertDialog(BuildContext context) async {  // set up the buttons
    Widget btnNao = TextButton(
      child: Text("Não"),
      onPressed:  () {
        Navigator.of(context).pop(false);
      },
    );
    Widget btnSim = TextButton(
      child: Text("Sim"),
      onPressed:  () {
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