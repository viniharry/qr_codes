import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_app/components/dialog_qr.dart';
import 'package:qr_code_app/constants/colors.dart';
import 'package:qr_code_app/constants/fonts.dart';
import 'package:qr_code_app/constants/size_config.dart';
import 'package:qr_code_app/model/pdf_model.dart';
import 'package:qr_code_app/pages/clientes/edit_selected_qr.dart';
import 'package:pdf/widgets.dart' as pw;

class SelectedQr extends StatefulWidget {
  SelectedQr(
      {Key key,
      @required this.idCliente,
      @required this.idQr,
      this.nomeCLiente})
      : super(key: key);

  final String idCliente;
  final String idQr;

  final String nomeCLiente;

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
            //mainAxisAlignment: MainAxisAlignment.center,
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
                   if(!snapshot.hasData || !snapshot.data.exists){
                     return Center(child: CircularProgressIndicator());
                   }

                    var serv = snapshot.data['servico'];
                    var modelo = snapshot.data['modelo'];
                    var valor = snapshot.data['valor'];
                    var validade = snapshot.data['validade'];
                    var data = snapshot.data['data'];

                    

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
                        UIHelper.verticalSpace(45),
                        Column(
                          children: [
                            Row(
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
                                        builder: (context) => DialogQr(
                                              title: 'Excluir Serviço',
                                              descreption:
                                                  'Deseja realmente excluir esse serviço?',
                                              ok: 'Sim!',
                                              cancel: 'Cancelar',
                                              okColor: primaryColor,
                                              cancelColor: colorRed,
                                              okFun: () async {
                                                await _deletarQr(context)
                                                    .then((value) {
                                                  return Navigator.of(context)
                                                      .pop();
                                                });
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
                                            builder: (context) =>
                                                EditSelectedQr(
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
                            ),
                            UIHelper.verticalSpace(25),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(15),
                                primary: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () async {
                                final pdfFile = await PdfModel.generate(
                                    modelo, serv, valor, validade, widget.nomeCLiente, data);

                                PdfModel.openFile(pdfFile);
                              },
                              child: Text(
                                "Criar PDF",
                                style: TextStyle(fontSize: 28),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  }),
            ],
          ),
        ));
  }

  Future<void> _createPdf(
      String modelo, String servico, String valor, String validade) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
          build: (context) => [
                pw.Table.fromTextArray(data: <List<String>>[
                  <String>['Modelo', 'servico', 'valor', 'validade'],
                  [modelo, servico, valor, validade]
                ])
              ]),
    );
    final String dir = (await getExternalStorageDirectory()).path;
    final String path = '$dir/validade.pdf';
    final file = File(path);
    file.writeAsBytesSync(await pdf.save());

    print(file);
  }

  Future _deletarQr(BuildContext context) async {
    FirebaseFirestore.instance
        .collection('clientes')
        .doc(widget.idCliente)
        .collection('qr_codes')
        .doc(widget.idQr)
        .delete();
    FirebaseFirestore.instance.collection('qr_codes').doc(widget.idQr).delete();

    return true;
  }
}
