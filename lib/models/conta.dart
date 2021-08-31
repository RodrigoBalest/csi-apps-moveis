import 'model.dart';

// Esta classe representa o modela da conta.
// A interface Model é utilizada no DAO.
class Conta implements Model {
  int? id;
  String nome;
  String icone;
  double valorInicial;

  Conta({this.id, required this.nome, required this.icone, required this.valorInicial});

  Conta.fromMap(Map<String, dynamic> map):
    id = map['id'],
    nome = map['nome'],
    icone = map['icone'],
    valorInicial = map['valor_inicial'];

  @override
  int? getId() {
    return id;
  }

  @override
  void setId(int v) {
    id = v;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'icone': icone,
      'valor_inicial': valorInicial
    };
  }

  @override
  String toString() {
    return 'Conta{id: $id, nome: $nome, icone: $icone, valorInicial: $valorInicial}';
  }
}