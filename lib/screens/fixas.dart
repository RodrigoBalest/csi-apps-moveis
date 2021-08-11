import 'package:flutter/material.dart';
import 'package:pataka/components/main_drawer.dart';

// Esta classe representa a tela de cadastro das receitas e despesas fixas.
// TODO. Ainda não está implementada.
class Fixas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Receitas e despesas fixas')),
      drawer: MainDrawer(),
      body: Center(
        child: Text('TODO: Receitas e despesas fixas.'),
      ),
    );
  }
}
