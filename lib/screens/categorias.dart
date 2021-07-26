import 'package:flutter/material.dart';
import 'package:pataka/components/main_drawer.dart';

class Categorias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: Text('Categorias')),
        drawer: MainDrawer(),
        body: Center(
          child: Text('TODO: Categorias.'),
        ),
    );
  }

}