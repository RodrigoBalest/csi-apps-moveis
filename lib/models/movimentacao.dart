import 'package:pataka/models/categoria.dart';

import 'conta.dart';
import 'model.dart';

// Esta classe representa o modela da movimentacao.
// A interface Model é utilizada no DAO.
class Movimentacao implements Model {
  int? id;
  String nome;
  double valor;
  String vencimento;
  int categoriaId;
  int? contaOrigemId;
  int? contaDestinoId;
  late Categoria categoria;
  late Conta? contaOrigem;
  late Conta? contaDestino;

  Movimentacao({
    this.id,
    required this.nome,
    required this.valor,
    required this.vencimento,
    required this.categoriaId,
    this.contaOrigemId,
    this.contaDestinoId
  });

  Movimentacao.fromMap(Map<String, dynamic> map):
      id = map['id'],
      nome = map['nome'],
      valor = map['valor'],
      vencimento = map['vencimento'],
      categoriaId = map['categoria_id'],
      contaOrigemId = map['conta_origem_id'],
      contaDestinoId = map['conta_destino_id'];

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
      'valor': valor,
      'vencimento': vencimento,
      'categoria_id': categoriaId,
      'conta_origem_id': contaOrigemId,
      'conta_destino_id': contaDestinoId
    };
  }

  @override
  String toString() {
    return 'Movimentacao{id: $id, nome: $nome, valor: $valor, vencimento: $vencimento, categoriaId: $categoriaId, contaOrigemId: $contaOrigemId, contaDestinoId: $contaDestinoId}';
  }
}