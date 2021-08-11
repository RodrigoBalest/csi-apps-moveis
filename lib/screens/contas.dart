import 'package:flutter/material.dart';
import 'package:pataka/components/main_drawer.dart';

// Esta classe representa a tela de cadastro de contas.
// TODO. Ainda não está implementada.
class Contas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contas')),
      drawer: MainDrawer(),
      body: Center(
        child: Text('TODO: Contas.'),
      ),
    );
  }
}
