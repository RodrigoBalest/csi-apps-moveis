import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pataka/components/decimal_text_input_formatter.dart';
import 'package:pataka/db/categoria_dao.dart';
import 'package:pataka/db/conta_dao.dart';
import 'package:pataka/db/movimentacao_dao.dart';
import 'package:pataka/models/movimentacao.dart';

// Esta classe representa o formulário de criação/edição de movimentação.
class MovimentacaoForm extends StatefulWidget {

  final Movimentacao? _mov;
  late final String _tipo;

  MovimentacaoForm({Movimentacao? movimentacao, String? tipo}): _mov = movimentacao {
    if (_mov != null) {
      _tipo = _mov?.contaOrigemId != null ? 'despesa' : 'receita';
    } else {
      _tipo = tipo!;
    }
  }

  @override
  _MovimentacaoFormState createState() => _MovimentacaoFormState(_mov, _tipo);
}

// Esta classe representa o estado do formulário.
class _MovimentacaoFormState extends State<MovimentacaoForm> {
  final _formKey = GlobalKey<FormState>();
  Movimentacao? _mov;
  final String _tipo;
  final String _titulo;
  final TextEditingController _nomeController;
  final TextEditingController _valorController;
  final TextEditingController _dataController;
  List<DropdownMenuItem<int>> _categorias = <DropdownMenuItem<int>>[];
  int? _categoriaId;
  List<DropdownMenuItem<int>> _contas= <DropdownMenuItem<int>>[];
  int? _contaId;
  String? _nome;
  double? _valor;
  DateTime _data = DateTime.now();
  DateFormat _fmt = DateFormat('dd-MM-yyyy');

  // Inicializa as propriedades da classe de acordo com a conta informada.
  _MovimentacaoFormState(this._mov, this._tipo) :
        _titulo = ((_mov == null) ? 'Nova ' : 'Editar ') + _tipo, // Define o título do widget
        _valorController = TextEditingController(text: _mov != null ? _mov.valor.toStringAsFixed(2) : '0.00'),
        _nomeController = TextEditingController(text: _mov != null ? _mov.nome : ''), // Define o controller do texto do formulário com o valor inicial.
        _dataController = TextEditingController() {
    _dataController.text = _fmt.format(_data);
  }

  _carregaCategorias() async {
    CategoriaDao dao = CategoriaDao();
    var cats = await dao.getAll();
    setState(() {
      _categorias = cats.map<DropdownMenuItem<int>>((cat) =>
          DropdownMenuItem(
            child: Text(cat.nome),
            value: cat.getId(),
          )
      ).toList();
    });
  }

  _carregaContas() async {
    ContaDao dao = ContaDao();
    var contas = await dao.getAll();
    setState(() {
      _contas = contas.map<DropdownMenuItem<int>>((conta) =>
          DropdownMenuItem(
            child: Text(conta.nome),
            value: conta.getId(),
          )
      ).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _carregaCategorias();
    _carregaContas();
  }

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
          child: SingleChildScrollView(
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
                  decoration: InputDecoration( labelText: 'Valor'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                  controller: _valorController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O valor é obrigatório';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<int>(
                    value: _categoriaId,
                    items: _categorias,
                    hint: Text('Categoria'),
                    onChanged: (value) {
                      setState(() {
                        _categoriaId = value;
                      });
                    },
                ),
                DropdownButtonFormField<int>(
                  value: _contaId,
                  items: _contas,
                  hint: Text('Conta'),
                  onChanged: (value) {
                    setState(() {
                      _contaId = value;
                    });
                  },
                ),
                TextFormField(
                  controller: _dataController,
                  readOnly: true,
                  onTap: () { _openDatePicker(context); },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'A data é obrigatória';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: ElevatedButton(
                    // Salva a movimentação e retorna à tela anterior.
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _nome = _nomeController.text;
                          _valor = double.parse(_valorController.text);
                          _saveMovimentacao();
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
        ),
      )
    );
  }

  _openDatePicker(context) {
    showDatePicker(
        context: context,
        initialDate: _data,
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now().add(const Duration(days: 365))
    ).then((date) {
      setState(() {
        _data = date!;
        _dataController.text = _fmt.format(_data);
      });
    });
  }

  // Usa o MovimentacaoDao para salvar as alterações.
  _saveMovimentacao() {
    MovimentacaoDao dao = MovimentacaoDao();
    DateFormat fmt = DateFormat('yyyy-MM-dd');
    Movimentacao m = Movimentacao(
        nome: _nome!,
        valor: _valor!,
        vencimento: fmt.format(_data),
        categoriaId: _categoriaId!
    );

    if (_tipo == 'receita') {
      m.contaDestinoId = _contaId!;
    } else {
      m.contaOrigemId = _contaId;
    }

    if (_mov != null && _mov!.getId() != null) {
      int? id = _mov!.getId();
      m.setId(id!);
    }
    m.getId() == null ? dao.save(m) : dao.update(m);
  }
}