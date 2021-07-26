import 'package:flutter/material.dart';
import 'package:pataka/components/main_drawer.dart';

class Fixas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('Fixas');
    return Scaffold(
      appBar: AppBar(title: Text('Receitas e despesas fixas')),
      drawer: MainDrawer(),
      body: Center(
        child: Text('TODO: Receitas e despesas fixas.'),
      ),
    );
  }
}
