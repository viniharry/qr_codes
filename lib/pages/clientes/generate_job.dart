import 'dart:async';

import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:qr_code_app/constants/fonts.dart';

class GenerateJob extends StatefulWidget {
  GenerateJob(
      {Key key, @required this.idCliente, this.nomeCliente, this.telCliente})
      : super(key: key);

  final String idCliente;
  final String nomeCliente;
  final String telCliente;

  @override
  _GenerateJobState createState() => _GenerateJobState();
}

class _GenerateJobState extends State<GenerateJob> {
  final _modelo = TextEditingController();
  final _servico = TextEditingController();
  final _valor = TextEditingController();
  final _validade = TextEditingController();

DateTime dataAtual = new DateTime.now();
  DateFormat formatter = new DateFormat('dd/MM/yyyy');
  String dataFormatada;

  GlobalKey<FormState> _form = GlobalKey<FormState>();

  bool _isToastShown = false;

  var maskDateFormatter = new MaskTextInputFormatter(
      mask: '##/##/##', filter: {"#": RegExp(r'[0-9]')});
  var maskPhoneFormatter = new MaskTextInputFormatter(
      mask: '(##)#####-####', filter: {"#": RegExp(r'[0-9]')});

  String qrCodeResult = "Nenhum Qr Code";
  String qrResult = 'Nenhum Qr Code';

  Future _qrs() async {
    await FirebaseFirestore.instance.collection('qr_codes').get().then((value) {
      value.docs.forEach((element) {
        return element.id;
      });
    });
  }

  @override
  void initState() {
    dataFormatada = formatter.format(dataAtual);
    print(dataFormatada);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future snapshots =
        FirebaseFirestore.instance.collection('qr_codes').get().then((value) {
      value.docs.forEach((element) {
        return element.id;
      });
    });
    print(snapshots);
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
                Text(widget.nomeCliente),
                SizedBox(height: 10),
                Text(widget.telCliente),
                SizedBox(height: 10),
                TextFormField(
                  controller: _modelo,
                  validator: (value) {
                    if (value.isEmpty) return 'Obrigatório';
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "Modelo:",
                      labelText: 'Modelo:',
                       labelStyle: kPrimalStyle,
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
                      labelText: 'Serviço:',
                       labelStyle: kPrimalStyle,
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
                      labelText: 'Valor:',
                       labelStyle: kPrimalStyle,
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
                      labelText: 'Validade:',
                       labelStyle: kPrimalStyle,
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
                          'nome': widget.nomeCliente,
                          'tel': widget.telCliente,
                          'servico': _servico.text,
                          'modelo': _modelo.text,
                          'valor': _valor.text,
                          'data': dataFormatada,
                          'validade': _validade.text,
                        });

                        await FirebaseFirestore.instance
                            .collection('qr_codes')
                            .doc(qrCodeResult)
                            .set({
                          'id': qrCodeResult,
                          'nome': widget.nomeCliente,
                          'tel': widget.telCliente,
                          'servico': _servico.text,
                          'modelo': _modelo.text,
                          'valor': _valor.text,
                          'data': dataFormatada,
                          'validade': _validade.text,
                        });

                        setState(() {
                          qrCodeResult = '4';
                        });
                        if (_isToastShown) {
                          return;
                        }
                        _isToastShown = true;
                        _showAlert();
                        _isToastShown = false;
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

  Future _showAlert() async {
    await showFlash(
        context: context,
        duration: Duration(seconds: 3),
        builder: (ctx, ctrl) {
          return Flash.dialog(
              controller: ctrl,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              backgroundColor: Colors.green,
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Salvo com sucesso!',
                  style: kPrimalStyle.copyWith(color: Colors.white),
                ),
              ));
        });
  }
}
