class Endereco {
  final int? id;
  final String rua;
  final String numero;
  final String? complemento;
  final String bairro;
  final String cidade;
  final String estado;
  final String cep;
  final String pais;

  Endereco({
    this.id,
    required this.rua,
    required this.numero,
    this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.cep,
    required this.pais,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rua': rua,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'cep': cep,
      'pais': pais,
    };
  }

  factory Endereco.fromMap(Map<String, dynamic> map) {
    return Endereco(
      id: map['id'],
      rua: map['rua'],
      numero: map['numero'],
      complemento: map['complemento'],
      bairro: map['bairro'],
      cidade: map['cidade'],
      estado: map['estado'],
      cep: map['cep'],
      pais: map['pais'],
    );
  }
}
