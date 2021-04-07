import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class GenerateJob extends StatefulWidget {
  GenerateJob({Key key, @required this.idCliente}) : super(key: key);

  final String idCliente;

  @override
  _GenerateJobState createState() => _GenerateJobState();
}

class _GenerateJobState extends State<GenerateJob> {
  final _modelo = TextEditingController();
  final _servico = TextEditingController();
  final _valor = TextEditingController();
  final _validade = TextEditingController();
  GlobalKey<FormState> _form = GlobalKey<FormState>();

  var maskDateFormatter = new MaskTextInputFormatter(
      mask: '##/##/##', filter: {"#": RegExp(r'[0-9]')});
  var maskPhoneFormatter = new MaskTextInputFormatter(
      mask: '(##)#####-####', filter: {"#": RegExp(r'[0-9]')});

  String qrCodeResult = "Nenhum Qr Code";
  String qrResult = 'Nenhum Qr Code';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gerar Qr Code"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80,
                      child: Text(
                        qrCodeResult,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () async {
                            String codeSanner = await BarcodeScanner.scan();
                            setState(() {
                              qrCodeResult = codeSanner;
                              print(codeSanner);
                              print(qrCodeResult);
                            });
                          },
                          child: Icon(
                            Icons.photo_camera,
                            size: 80,
                            color: Colors.indigo[900],
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Serviço",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                SizedBox(height: 10),
                TextFormField(
                  controller: _modelo,
                  validator: (value) {
                    if (value.isEmpty) return 'Obrigatório';
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "Modelo:",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _servico,
                  validator: (value) {
                    if (value.isEmpty) return 'Obrigatório';
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "Serviço:",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _valor,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) return 'Obrigatório';
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "Valor:",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _validade,
                  inputFormatters: [maskDateFormatter],
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value.isEmpty) return 'Obrigatório';
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "Validade:",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      if (_form.currentState.validate()) {
                        await FirebaseFirestore.instance
                            .collection('clientes')
                            .doc(widget.idCliente)
                            .collection('qr_codes')
                            .doc(qrCodeResult)
                            .set({
                          'id': qrCodeResult,
                          'servico': _servico.text,
                          'modelo': _modelo.text,
                          'valor': _valor.text,
                          'data': DateTime.now(),
                          'validade': _validade.text,
                        });
                        setState(() {
                          qrCodeResult = qrResult;
                        });

                        _servico.clear();
                        _modelo.clear();
                        _valor.clear();
                        _validade.clear();
                      }
                    },
                    child: Text(
                      "Salvar",
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}