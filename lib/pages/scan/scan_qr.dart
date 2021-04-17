import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScanQR extends StatefulWidget {
  final String id;
  ScanQR({
    Key key,
    @required this.id,
  }) : super(key: key);
  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var snapshots = db.collection('qr_codes').doc(widget.id).snapshots();

    var snap = db
        .collection('clientes')
        .doc()
        .collection('qr_codes')
        .doc(widget.id)
        .snapshots();

    return Scaffold(
        appBar: AppBar(
          title: Text("Resultado"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //Message displayed over here
              Text(
                "Cliente",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              SizedBox(
                height: 50,
              ),
              //Text(item['nome']),
              StreamBuilder(
                  stream: snapshots,
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    if(!snapshot.hasData || !snapshot.data.exists){
                      return Center(
                        child:Text('Qr Code não foi encontrado'),
                      );
                    }
                  
                    var nome = snapshot.data['nome'];
                    var tel = snapshot.data['tel'];
                    var serv = snapshot.data['servico'];
                    var modelo = snapshot.data['modelo'];
                    var valor = snapshot.data['valor'];
                    var validade = snapshot.data['validade'];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Nome: $nome'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Telefone: $tel'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Modelo: $modelo'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Serviço: $serv'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Valor: R\$$valor'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Validade: $validade'),
                        ),
                      ],
                    );
                  }),

              Expanded(
                child: SizedBox(),
              ),
            ],
          ),
        ));
  }
}
