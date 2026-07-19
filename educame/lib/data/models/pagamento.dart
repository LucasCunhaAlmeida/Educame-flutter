class Pagamento {
  final int? id;
  final int aulaId;
  final int alunoId;
  final double valor;
  final String status;
  final DateTime dataVencimento;
  final DateTime? dataPagamento;
  final String? metodoPagamento;
  final String? referenciaExterna;

  Pagamento({
    this.id,
    required this.aulaId,
    required this.alunoId,
    required this.valor,
    required this.status,
    required this.dataVencimento,
    this.dataPagamento,
    this.metodoPagamento,
    this.referenciaExterna,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'aula_id': aulaId,
      'aluno_id': alunoId,
      'valor': valor,
      'status': status,
      'data_vencimento': dataVencimento.toIso8601String(),
      'data_pagamento': dataPagamento?.toIso8601String(),
      'metodo_pagamento': metodoPagamento,
      'referencia_externa': referenciaExterna,
    };
  }

  factory Pagamento.fromMap(Map<String, dynamic> map) {
    return Pagamento(
      id: map['id'],
      aulaId: map['aula_id'],
      alunoId: map['aluno_id'],
      valor: (map['valor'] as num).toDouble(),
      status: map['status'],
      dataVencimento: DateTime.parse(
        map['data_vencimento'],
      ),
      dataPagamento: map['data_pagamento'] != null
          ? DateTime.parse(map['data_pagamento'])
          : null,
      metodoPagamento: map['metodo_pagamento'],
      referenciaExterna: map['referencia_externa'],
    );
  }
}
