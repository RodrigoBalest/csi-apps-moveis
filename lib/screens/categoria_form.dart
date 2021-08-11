import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:pataka/db/categoria_dao.dart';
import 'package:pataka/models/categoria.dart';

class CategoriaForm extends StatefulWidget {

  final Categoria _categoria;

  CategoriaForm([Categoria? c]):
        _categoria = c ?? Categoria(nome: '', icone: 58208.toString(), cor: 0xFF42A5F5.toString());

  @override
  _CategoriaFormState createState() => _CategoriaFormState(_categoria);
}

class _CategoriaFormState extends State<CategoriaForm> {
  final TextEditingController _nomeController;
  final _formKey = GlobalKey<FormState>();
  final String _titulo;
  String _nome;
  Color _cor;
  Icon _icone;
  Categoria _categoria;

  _CategoriaFormState(Categoria c) :
        _categoria = c,
        _titulo = (c.getId() == null) ? 'Nova categoria' : 'Editar categoria',
        _nome = c.nome,
        _cor = Color(int.parse(c.cor)),
        _icone = Icon(IconData(int.parse(c.icone), fontFamily: 'MaterialIcons')),
        _nomeController = TextEditingController(text: c.nome);

  @override
  Widget build(BuildContext context) {
    final colorBtnStyle = ElevatedButton.styleFrom(
      primary: _cor,
      fixedSize: Size(56, 56),
      textStyle: TextStyle(
        color: const Color(0xffffffff)
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_titulo)
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration( labelText: 'Nome'),
                controller: _nomeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O nome é obrigatório';
                  }
                  return null;
                },
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
                      child: _icone,
                      style: colorBtnStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _nome = _nomeController.text;
                      _saveCategoria();
                      Navigator.pop(context);
                    }
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
            pickerColor: _cor,
            onColorChanged: (Color color) {
              setState(() {
                _cor = color;
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      )
    );
  }

  _openIconPicker() async {
    IconData? iconData = await FlutterIconPicker.showIconPicker(context, iconPackMode: IconPack.material);
    if (iconData != null) {
      setState(() {
        _icone = Icon(iconData);
      });
    }
  }

  _saveCategoria() {
    CategoriaDao dao = CategoriaDao();
    _categoria.nome = _nome;
    _categoria.icone = _icone.icon!.codePoint.toString();
    _categoria.cor = _cor.value.toString();
    _categoria.getId() == null ? dao.save(_categoria) : dao.update(_categoria);
  }
}