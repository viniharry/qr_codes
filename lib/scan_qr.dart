import 'dart:async';

import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScanQR extends StatefulWidget {
  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  String qrCodeResult = '0';

  var db = FirebaseFirestore.instance;

  Future qr() async {
    DocumentSnapshot result =
        await db.collection('qr_codes').doc(qrCodeResult).get();
    print(result.id);
    print(result.data()['nome']);
  }

  //Future<DocumentSnapshot> qrCode;

  @override
  void initState() {
    //qrCode = db.collection('qr_codes').doc(qrCodeResult).get();
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var snapshots = db.collection('qr_codes').doc(qrCodeResult).snapshots();

    var snap = db.collection('qr_codes').snapshots();

    return Scaffold(
        appBar: AppBar(
          title: Text("Ler Qr Code"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //Message displayed over here
              Text(
                "Resultado",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              Text(
                qrCodeResult,
                style: TextStyle(
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data == null) {
                      return Text('null');
                    }
                     if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.data == null) {
                        return Text('data');
                      } 
                    }else{
                      return Center(child: CircularProgressIndicator(),);
                    }
                    var nome = snapshot.data['nome'];
                    var tel = snapshot.data['telefone'];
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

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  String codeSanner =
                      await BarcodeScanner.scan(); //barcode scnner
                  setState(() {
                    qrCodeResult = codeSanner;
                  });
                },
                child: Text(
                  "Câmera",
                  style: TextStyle(fontSize: 28),
                ),
              ),

              //Button to scan QR code

              // FlatButton(
              //   padding: EdgeInsets.all(15),
              //   onPressed: () async {
              //     String codeSanner =
              //         await BarcodeScanner.scan(); //barcode scnner
              //     setState(() {
              //       qrCodeResult = codeSanner;
              //       print(codeSanner);
              //       print(qrCodeResult);
              //     });
              //   },
              //   child: Text(
              //     "Câmera",
              //     style: TextStyle(color: Colors.indigo[900], fontSize: 28),
              //   ),
              //   //Button having rounded rectangle border
              //   shape: RoundedRectangleBorder(
              //     side: BorderSide(color: Colors.indigo[900]),
              //     borderRadius: BorderRadius.circular(20.0),
              //   ),
              // ),
            ],
          ),
        ));
  }
}
