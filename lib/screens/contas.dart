import 'package:flutter/material.dart';
import 'package:pataka/components/main_drawer.dart';

class Contas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('Contas');
    return Scaffold(
      appBar: AppBar(title: Text('Contas')),
      drawer: MainDrawer()
    );
  }
}
