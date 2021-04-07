import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/components/dialog_qr.dart';
import 'package:qr_code_app/constants/colors.dart';
import 'package:qr_code_app/constants/fonts.dart';
import 'package:qr_code_app/constants/size_config.dart';
import 'package:qr_code_app/pages/clientes/edit_selected_qr.dart';

class SelectedQr extends StatefulWidget {
  SelectedQr({Key key, @required this.idCliente, @required this.idQr})
      : super(key: key);

  final String idCliente;
  final String idQr;

  @override
  _SelectedQrState createState() => _SelectedQrState();
}

class _SelectedQrState extends State<SelectedQr> {
  @override
  Widget build(BuildContext context) {
    var snapshots = FirebaseFirestore.instance
        .collection('clientes')
        .doc(widget.idCliente)
        .collection('qr_codes')
        .doc(widget.idQr)
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
                "Serviço",
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
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    var serv = snapshot.data['servico'];
                    var modelo = snapshot.data['modelo'];
                    var valor = snapshot.data['valor'];
                    var validade = snapshot.data['validade'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Modelo: $modelo', style: kPrimalStyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Serviço: $serv', style: kPrimalStyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Valor: R\$$valor', style: kPrimalStyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Text('Validade: $validade', style: kPrimalStyle),
                        ),
                      ],
                    );
                  }),

              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15),
                      primary: Colors.red[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => DialogQr(
                                title: 'Excluir Serviço',
                                descreption:
                                    'Deseja realmente excluir esse serviço?',
                                ok: 'Sim!',
                                cancel: 'Cancelar',
                                okColor: primaryColor,
                                cancelColor: colorRed,
                                okFun: () async {
                                  await FirebaseFirestore.instance
                                      .collection('clientes')
                                      .doc(widget.idCliente)
                                      .collection('qr_codes')
                                      .doc(widget.idQr)
                                      .delete();
                                },
                              ));
                    },
                    child: Text(
                      "Excluir",
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditSelectedQr(
                                    idCliente: widget.idCliente,
                                    idQr: widget.idQr,
                                  )));
                    },
                    child: Text(
                      "Editar",
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ));
  }
}
