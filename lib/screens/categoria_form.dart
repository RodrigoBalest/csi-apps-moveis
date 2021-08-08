import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:pataka/models/categoria.dart';

class CategoriaForm extends StatefulWidget {

  late String _titulo;
  late String _nome;
  late Color _cor;
  late Icon _icone;

  CategoriaForm([Categoria? c]) {
    if (c == null) {
      _titulo = 'Nova categoria';
      _nome = '';
      _cor = Color.fromARGB(0xFF, 0x42, 0xA5, 0xF5);
      IconData iconData = IconData(0xe3af, fontFamily: 'MaterialIcons');
      _icone = Icon(iconData);
    } else {
      _titulo = 'Editar categoria';
      _nome = c.nome;
      _cor = Color(int.parse(c.cor, radix: 16));
      IconData iconData = IconData(int.parse(c.icone, radix: 16), fontFamily: 'MaterialIcons');
      _icone = Icon(iconData);
    }
  }

  @override
  _CategoriaFormState createState() => _CategoriaFormState();
}

class _CategoriaFormState extends State<CategoriaForm> {
  final TextEditingController _nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorBtnStyle = ElevatedButton.styleFrom(
      primary: widget._cor,
      fixedSize: Size(56, 56),
      textStyle: TextStyle(
        color: useWhiteForeground(widget._cor)
            ? const Color(0xffffffff)
            : const Color(0xff000000)
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget._titulo)
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration( labelText: 'Nome'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _openColorPicker(context);
                    },
                    child: Text('Cor'),
                    style: colorBtnStyle,
                  ),
                  ElevatedButton(
                    onPressed: _openIconPicker,
                    child: widget._icone,
                    style: colorBtnStyle,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                onPressed: () {
                  debugPrint('Salvar categoria');
                },
                child: Text('Salvar'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(56, 12, 56, 12),
                  textStyle: TextStyle(
                    fontSize: 24
                  )
                )
              ),
            )
          ],
        ),
      )
    );
  }

  void _openColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Escolha uma cor.'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: widget._cor,
            onColorChanged: (Color color) {
              setState(() => widget._cor = color);
              Navigator.of(context).pop();
            },
          ),
        ),
      )
    );
  }

  _openIconPicker() async {
    IconData? iconData = await FlutterIconPicker.showIconPicker(context, iconPackMode: IconPack.cupertino);
    if (iconData != null) {
      setState(() => widget._icone = Icon(iconData) );
    }
  }
}