import 'dart:async';

import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScanQR extends StatefulWidget {
  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  String qrCodeResult = "Nenhum resultado";

  var db = FirebaseFirestore.instance;

  Future qr() async {
    DocumentSnapshot result =
        await db.collection('qr_codes').doc(qrCodeResult).get();
    print(result.id);
    print(result.data()['nome']);
  }

  // @override
  // void initState() async {
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var snapshots =
        db.collection('qr_codes').doc(qrCodeResult).get().asStream();

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
                  builder: (context, snapshot) {
                    //print(snapshot.data['nome']);
                    //var nome = snapshot.data['nome'];
                    // var tel = snapshot.data['nome'];
                    // var serv = snapshot.data['nome'];
                    // var valor = snapshot.data['nome'];
                    // var validade = snapshot.data['nome'];

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
                    return Column(
                      children: [
                        Text('Telefone:'),
                        Text('Serviço:'),
                        Text('Valor:'),
                        Text('Validade:'),
                      ],
                    );
                  }),

              Expanded(
                child: SizedBox(),
              ),

              //Button to scan QR code
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
                    print(codeSanner);
                    print(qrCodeResult);

                    qr();
                  });
                },
                child: Text(
                  "Câmera",
                  style: TextStyle(fontSize: 28),
                ),
              ),
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
