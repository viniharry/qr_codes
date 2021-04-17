


import 'package:cloud_firestore/cloud_firestore.dart';

class Client{
  String nome;
  String telefone1;
  String telefone2;
  String cidade;
  String bairro;
  String rua;
  String numero;
  String cpf;



  Client({
  this.bairro,
  this.cidade,
  this.cpf,
  this.nome,
  this.numero,
  this.rua,
  this.telefone1,
  this.telefone2
  
  });

  Client.fromSnapshot(DocumentSnapshot snapshot):

  nome = snapshot['nome'],
  telefone1 = snapshot['telefone1'],
  telefone2 = snapshot['telefone2'],
  cidade = snapshot['cidade'],
  bairro = snapshot['bairro'],
  rua = snapshot['rua'],
  numero = snapshot['numero'],
  cpf = snapshot['cpf'];


}