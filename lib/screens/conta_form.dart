import 'package:flutter/material.dart';
import 'package:pataka/components/conta_icone_selector.dart';
import 'package:pataka/components/decimal_text_input_formatter.dart';
import 'package:pataka/db/conta_dao.dart';
import 'package:pataka/models/conta.dart';

// Esta classe representa o formulário de criação/edição de conta.
class ContaForm extends StatefulWidget {

  final Conta _conta;

  // Se foi passada uma conta para o formulário, ela é atribuída à variável
  // _conta. Caso contrário, uma conta com valores definidos é criada.
  // Esta conta é passada para o State deste Widget.
  ContaForm([Conta? c]):
        _conta = c ?? Conta(nome: '', icone: 'carteira', valorInicial: 0);

  @override
  _ContaFormState createState() => _ContaFormState(_conta);
}

// Esta classe representa o estado do formulário.
class _ContaFormState extends State<ContaForm> {
  final TextEditingController _nomeController;
  final TextEditingController _valorInicialController;
  final _formKey = GlobalKey<FormState>();
  final String _titulo;
  String _nome;
  double _valorInicial;
  String _icone;
  Conta _conta;

  // Inicializa as propriedades da classe de acordo com a conta informada.
  _ContaFormState(Conta c) :
        _conta = c, // Atribui a conta
        _titulo = (c.getId() == null) ? 'Nova conta' : 'Editar conta', // Define o título do widget
        _nome = c.nome, // Define o valor da propriedade nome
        _icone = c.icone,
        _valorInicial = c.valorInicial,
        _valorInicialController = TextEditingController(text: c.valorInicial.toStringAsFixed(2)),
        _nomeController = TextEditingController(text: c.nome); // Define o controller do texto do formulário com o valor inicial.

  @override
  Widget build(BuildContext context) {
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
              TextFormField(
                decoration: InputDecoration( labelText: 'Valor inicial'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                controller: _valorInicialController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O valor inicial é obrigatório';
                  }
                  return null;
                },
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('Ícone')
              ),
              ContaIconeSelector(_icone),
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
                        _valorInicial = double.parse(_valorInicialController.text.replaceAll(',', '.'));
                        _saveConta();
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

  // Usa o CategoriaDao para salvar as alterações.
  _saveConta() {
    ContaDao dao = ContaDao();
    _conta.nome = _nome;
    _conta.icone = _icone;
    _conta.valorInicial = _valorInicial;
    _conta.getId() == null ? dao.save(_conta) : dao.update(_conta);
  }
}