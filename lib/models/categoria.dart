import 'model.dart';

class Categoria implements Model {
  int? id;
  String nome;
  String icone;
  String cor;

  Categoria({this.id, required this.nome, required this.icone, required this.cor});

  Categoria.fromMap(Map<String, dynamic> map):
    id = map['id'],
    nome = map['nome'],
    icone = map['icone'],
    cor = map['cor'];

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
      'cor': cor
    };
  }

  @override
  String toString() {
    return 'Categoria{id: $id, nome: $nome, icone: $icone, cor: $cor}';
  }
}