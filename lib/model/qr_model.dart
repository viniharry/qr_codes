class QrModel {
  String id;
  String nome;
  String phone;
  String servico;
  String valor;
  DateTime validade;

  QrModel(
      {this.id,
      this.validade,
      this.nome,
      this.phone,
      this.servico,
      this.valor});

  QrModel.map(dynamic qr) {
    this.id = qr['id'];
    this.servico = qr['servico'];
    this.valor = qr['valor'];
    this.validade = qr['validade'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['servico'] = servico;
    map['valor'] = valor;
    map['validade'] = validade;

    return map;
  }

  QrModel.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.servico = map['servico'];
    this.valor = map['valor'];
    this.validade = map['validade'];
  }
}
