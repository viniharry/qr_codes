import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:qr_code_app/components/menu_drawer.dart';
import 'package:qr_code_app/constants/fonts.dart';

class AddCienteScreen extends StatefulWidget {
  AddCienteScreen({Key key}) : super(key: key);

  @override
  _AddCienteScreenState createState() => _AddCienteScreenState();
}

class _AddCienteScreenState extends State<AddCienteScreen> {
  final _nome = TextEditingController();
  final _telefone1 = TextEditingController();
  final _telefone2 = TextEditingController();
  final _bairro = TextEditingController();
  final _rua = TextEditingController();
  final _numero = TextEditingController();
  final _cidade = TextEditingController();
  final _cpf = TextEditingController();

  bool _isToastShown = false;

  GlobalKey<FormState> _form = GlobalKey<FormState>();

  var maskCpfFormatter = new MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  var maskPhoneFormatter = new MaskTextInputFormatter(
      mask: '(##)#####-####', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text('Cadastrar Clientes'),
        actions: [
          IconButton(
              icon: Icon(Icons.arrow_back_outlined),
              onPressed: () => Navigator.of(context).pop())
        ],
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
                      labelText: 'Telefone2:',
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
                      labelText: "Bairro:",
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
                            .doc()
                            .set({
                          'nome': _nome.text,
                          'telefone1': _telefone1.text,
                          'telefone2': _telefone2.text,
                          'cidade': _cidade.text,
                          'bairro': _bairro.text,
                          'rua': _rua.text,
                          'numero': _numero.text,
                          'cpf': _cpf.text,
                        });
                        _nome.clear();
                        _telefone1.clear();
                        _telefone2.clear();
                        _cidade.clear();
                        _bairro.clear();
                        _rua.clear();
                        _numero.clear();
                        _cpf.clear();

                        if (_isToastShown) {
                          return;
                        }
                        _isToastShown = true;
                        _showAlert();
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
