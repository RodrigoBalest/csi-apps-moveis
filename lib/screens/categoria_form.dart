import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:pataka/db/categoria_dao.dart';
import 'package:pataka/models/categoria.dart';

// Esta classe representa o formulário de criação/edição de categoria.
// Para o seletor de cor foi usado o pacote flutter_colorpicker
// e para o seletor de ícones, o pacote flutter_iconpicker.
class CategoriaForm extends StatefulWidget {

  final Categoria _categoria;

  // Se foi passada uma categoria para o formulário, ela é atribuída à variável
  // _categoria. Caso contrário, uma categoria com valores definidos é criada.
  // Esta categoria é passada para o State deste Widget.
  CategoriaForm([Categoria? c]):
        _categoria = c ?? Categoria(nome: '', icone: 58208.toString(), cor: 0xFF42A5F5.toString());

  @override
  _CategoriaFormState createState() => _CategoriaFormState(_categoria);
}

// Esta classe representa o estado do formulário.
class _CategoriaFormState extends State<CategoriaForm> {
  final TextEditingController _nomeController;
  final _formKey = GlobalKey<FormState>();
  final String _titulo;
  String _nome;
  Color _cor;
  Icon _icone;
  Categoria _categoria;

  // Inicializa as propriedades da classe de acordo com a categoria informada.
  _CategoriaFormState(Categoria c) :
        _categoria = c, // Atribui a categoria
        _titulo = (c.getId() == null) ? 'Nova categoria' : 'Editar categoria', // Define o título do widget
        _nome = c.nome, // Define o valor da propriedade nome
        _cor = Color(int.parse(c.cor)), // Define a cor
        _icone = Icon(IconData(int.parse(c.icone), fontFamily: 'MaterialIcons')), // Define o ícone
        _nomeController = TextEditingController(text: c.nome); // Define o controller do texto do formulário com o valor inicial.

  @override
  Widget build(BuildContext context) {
    // Define o estilo dos botões do formulário
    // de acordo com a propriedade _cor.
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
                    // Exibe o botão que abre o seletor de cores.
                    ElevatedButton(
                      onPressed: () {
                        _openColorPicker(context);
                      },
                      child: Text('Cor'),
                      style: colorBtnStyle,
                    ),
                    // Exibe o botão que abre o seletor de ícones.
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
                // Exibe o botão que salva as edições caso o nome seja válido.
                // Como a cor e o ícone já vêm com um valor padrão, não é possível
                // que eles fiquem sem valor.
                child: ElevatedButton(
                  // Salva a categoria e retorna à tela anterior.
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

  // Exibe o seletor de cor.
  void _openColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Escolha uma cor.'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _cor,
            onColorChanged: (Color color) {
              // Ao selecionar uma cor, atualiza o State e fecha o seletor.
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

  // Exibe o seletor de ícones.
  _openIconPicker() async {
    IconData? iconData = await FlutterIconPicker.showIconPicker(context, iconPackMode: IconPack.material);
    if (iconData != null) {
      // Ao selecionar um ícone, atualiza o State. O seletor fecha por conta.
      setState(() {
        _icone = Icon(iconData);
      });
    }
  }

  // Usa o CategoriaDao para salvar as alterações.
  _saveCategoria() {
    CategoriaDao dao = CategoriaDao();
    _categoria.nome = _nome;
    _categoria.icone = _icone.icon!.codePoint.toString();
    _categoria.cor = _cor.value.toString();
    _categoria.getId() == null ? dao.save(_categoria) : dao.update(_categoria);
  }
}