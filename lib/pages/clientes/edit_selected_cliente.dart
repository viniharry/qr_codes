import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:qr_code_app/components/menu_drawer.dart';
import 'package:qr_code_app/constants/fonts.dart';

class EditSelectedCliente extends StatefulWidget {
  EditSelectedCliente({Key key, @required this.idCliente}) : super(key: key);

  final String idCliente;
  @override
  _EditSelectedClienteState createState() => _EditSelectedClienteState();
}

class _EditSelectedClienteState extends State<EditSelectedCliente> {
  TextEditingController _nome;
  TextEditingController _telefone1;
  TextEditingController _telefone2;
  TextEditingController _bairro;
  TextEditingController _rua;
  TextEditingController _numero;
  TextEditingController _cidade;
  TextEditingController _cpf;

  bool _isToastShown = false;

  GlobalKey<FormState> _form = GlobalKey<FormState>();

  var maskCpfFormatter = new MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  var maskPhoneFormatter = new MaskTextInputFormatter(
      mask: '(##)#####-####', filter: {"#": RegExp(r'[0-9]')});
  @override
  Widget build(BuildContext context) {
    var snapshots = FirebaseFirestore.instance
        .collection('clientes')
        .doc(widget.idCliente)
        .snapshots();
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text('Editar cliente'),
        actions: [
          IconButton(
              icon: Icon(Icons.arrow_back_outlined),
              onPressed: () => Navigator.of(context).pop())
        ],
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
                if (!snapshot.hasData || !snapshot.data.exists) {
                  return Center(
                    child: Text('Cliente não foi encontrado'),
                  );
                }
                var nome = snapshot.data['nome'];
                var cpf = snapshot.data['cpf'];
                var tel1 = snapshot.data['telefone1'];
                var tel2 = snapshot.data['telefone2'];
                var cidade = snapshot.data['cidade'];
                var bairro = snapshot.data['bairro'];
                var rua = snapshot.data['rua'];
                var numero = snapshot.data['numero'];

                _nome = TextEditingController(text: nome);
                _cpf = TextEditingController(text: cpf);
                _telefone1 = TextEditingController(text: tel1);
                _telefone2 = TextEditingController(text: tel2);
                _cidade = TextEditingController(text: cidade);
                _bairro = TextEditingController(text: bairro);
                _rua = TextEditingController(text: rua);
                _numero = TextEditingController(text: numero);

                return Form(
                  key: _form,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        "Dados",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _nome,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value.isEmpty) return 'Obrigatório';
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Nome*:",
                            labelText: 'Nome*:',
                            labelStyle: kPrimalStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _cpf,
                        inputFormatters: [maskCpfFormatter],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "CPF:",
                            labelText: 'CPF:',
                            labelStyle: kPrimalStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _telefone1,
                        inputFormatters: [maskPhoneFormatter],
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value.isEmpty) return 'Obrigatório';
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Telefone1*:",
                            labelText: 'Telefone1*:',
                            labelStyle: kPrimalStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _telefone2,
                        inputFormatters: [maskPhoneFormatter],
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            hintText: "Telefone2:",
                             labelText: "Telefone2:",
                             labelStyle: kPrimalStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _cidade,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "Cidade:",
                            labelText: 'Cidade:',
                            labelStyle: kPrimalStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _bairro,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "Bairro:",
                            labelText: 'Bairro:',
                            labelStyle: kPrimalStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _rua,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) return 'Obrigatório';
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Rua*:",
                            labelText: 'Rua*:',
                            labelStyle: kPrimalStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _numero,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) return 'Obrigatório';
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Número*:",
                            labelText: 'Número*:',
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
                                  .update({
                                'nome': _nome.text,
                                'telefone1': _telefone1.text,
                                'telefone2': _telefone2.text,
                                'cidade': _cidade.text,
                                'bairro': _bairro.text,
                                'rua': _rua.text,
                                'numero': _numero.text,
                                'cpf': _cpf.text,
                              });
                              if (_isToastShown) {
                                return;
                              }
                              _isToastShown = true;
                              _showAlert();
                              _isToastShown = false;
                            }

                            //   if(_isToastShown){
                            //       return;
                            //     }
                            //     _isToastShown = true;
                            //  await showFlash(
                            //     context: context,
                            //     duration: Duration(seconds: 3),
                            //     builder: (ctx, ctrl){
                            //       return Flash.bar(
                            //         controller: ctrl,
                            //         borderRadius: BorderRadius.all(Radius.circular(8)),
                            //         backgroundColor: Colors.green,

                            //         child: FlashBar(message: Text('Salvo com sucesso!', style: kPrimalStyle.copyWith(color: Colors.white),))
                            //         );
                            //     });
                            //  _isToastShown = false;
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
