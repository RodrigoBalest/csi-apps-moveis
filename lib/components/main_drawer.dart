import 'package:flutter/material.dart';
import 'package:pataka/screens/categorias.dart';
import 'package:pataka/screens/contas.dart';
import 'package:pataka/screens/fixas.dart';
import 'package:pataka/screens/inicio.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child: Image.asset('imagens/logo.png')
          ),
          ListTile(
            title: Text('Início'),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Inicio()));
            },
          ),
          ListTile(
            title: Text('Contas'),
            leading: Icon(Icons.account_balance_wallet),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Contas()));
            },
          ),
          ListTile(
            title: Text('Categorias'),
            leading: Icon(Icons.label),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Categorias()));
            },
          ),
          ListTile(
            title: Text('Receitas e despesas fixas'),
            leading: Icon(Icons.push_pin),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Fixas()));
            },
          )
        ],
      ),
    );
  }
  
}