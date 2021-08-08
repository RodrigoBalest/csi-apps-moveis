import 'package:flutter/material.dart';
import 'package:pataka/components/main_drawer.dart';
import 'package:pataka/db/categoria_dao.dart';
import 'package:pataka/models/categoria.dart';
import 'package:pataka/screens/categoria_form.dart';

class Categorias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categorias')),
      drawer: MainDrawer(),
      body: _futureBuilderCategorias(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriaForm()));
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
          case ConnectionState.none:
            break;
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
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            final List<Categoria>? categorias = snapshot.data;
            if (categorias == null || categorias.length == 0) {
              return Center(
                child: Text('Nenhuma categoria encontrada.'),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final Categoria c = categorias[index];
                return CategoriaListItem(c);
              },
            );
            break;
        }
        return Text('Problemas ao gerar a lista de categorias.');
      }
    );
  }
}

class CategoriaListItem extends StatelessWidget {
  final Categoria _categoria;

  CategoriaListItem(this._categoria);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_categoria.nome),
    );
  }
}