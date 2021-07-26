import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pataka/components/main_drawer.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Inicio extends StatelessWidget {
  Widget _getTitleTile(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text('Balanço dos próximos meses',
          style: Theme.of(ctx).textTheme.headline6),
    );
  }

  Widget _getMonthTile(BuildContext ctx, int index) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month + index);
    DateFormat fmt = DateFormat('MMMM y');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              toBeginningOfSentenceCase(fmt.format(date)).toString(),
              textAlign: TextAlign.center,
              style: Theme.of(ctx).textTheme.headline6,
            ),
            Row(
              children: [
                Text('Receitas:', style: TextStyle(height: 1.35))
              ]
            ),
            Row(
              children: [
                Text('Despesas:', style: TextStyle(height: 1.35))
              ],
            ),
            Row(
              children: [
                Text('BALANÇO:', style: Theme.of(ctx).textTheme.bodyText1!.merge(TextStyle(height: 1.5)))
              ],
            ),
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'pt_BR';
    initializeDateFormatting();

    return Scaffold(
      appBar: AppBar(title: Text('Início')),
      drawer: MainDrawer(),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: List<Widget>.generate(13, (index) {
          return index == 0
            ? _getTitleTile(context)
            : _getMonthTile(context, index - 1);
        }),
      )
    );
  }
}
