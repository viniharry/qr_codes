import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:qr_code_app/constants/fonts.dart';

class EditSelectedQr extends StatefulWidget {
  EditSelectedQr({Key key, @required this.idCliente, @required this.idQr})
      : super(key: key);

  final String idCliente;
  final String idQr;

  @override
  _EditSelectedQrState createState() => _EditSelectedQrState();
}

class _EditSelectedQrState extends State<EditSelectedQr> {
  TextEditingController _modelo;
  TextEditingController _servico;
  TextEditingController _valor;
  TextEditingController _validade;
  GlobalKey<FormState> _form = GlobalKey<FormState>();

  bool _isToastShown = false;

  var maskDateFormatter = new MaskTextInputFormatter(
      mask: '##/##/##', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
  }

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
        title: Text("Gerar Qr Code"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: StreamBuilder(
              stream: snapshots,
              builder: (context, snapshot) {
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

                _modelo = TextEditingController(text: modelo);
                _servico = TextEditingController(text: serv);
                _valor = TextEditingController(text: valor);
                _validade = TextEditingController(text: validade);

                return Form(
                  key: _form,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                            hintText: "Modelo: ",
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
                                  .doc(widget.idQr)
                                  .update({
                                'servico': _servico.text,
                                'modelo': _modelo.text,
                                'valor': _valor.text,
                                'validade': _validade.text,
                              });

                              if (_isToastShown) {
                                return;
                              }
                              _isToastShown = true;
                              await showFlash(
                                  context: context,
                                  duration: Duration(seconds: 3),
                                  builder: (ctx, ctrl) {
                                    return Flash.dialog(
                                        controller: ctrl,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        backgroundColor: Colors.green,
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            'Salvo com sucesso!',
                                            style: kPrimalStyle.copyWith(
                                                color: Colors.white),
                                          ),
                                        ));
                                  });
                              _isToastShown = false;
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
                );
              }),
        ),
      ),
    );
  }
}
