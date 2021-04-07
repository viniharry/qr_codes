import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/components/dialog_qr.dart';
import 'package:qr_code_app/components/menu_drawer.dart';
import 'package:qr_code_app/constants/colors.dart';
import 'package:qr_code_app/constants/fonts.dart';
import 'package:qr_code_app/constants/size_config.dart';
import 'package:qr_code_app/pages/clientes/edit_selected_cliente.dart';
import 'package:qr_code_app/pages/clientes/generate_job.dart';
import 'package:qr_code_app/pages/clientes/selected_qr.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectedCliente extends StatefulWidget {
  SelectedCliente({Key key, @required this.idCliente}) : super(key: key);

  final String idCliente;

  @override
  _SelectedClienteState createState() => _SelectedClienteState();
}

class _SelectedClienteState extends State<SelectedCliente> {
  @override
  Widget build(BuildContext context) {
    var snapshots = FirebaseFirestore.instance
        .collection('clientes')
        .doc(widget.idCliente)
        .snapshots();
    var snapshots2 = FirebaseFirestore.instance
        .collection('clientes')
        .doc(widget.idCliente)
        .collection('qr_codes')
        .snapshots();
    return StreamBuilder(
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
          var nome = snapshot.data['nome'];
          var cpf = snapshot.data['cpf'];
          var tel1 = snapshot.data['telefone1'];
          var tel2 = snapshot.data['telefone2'];
          var cidade = snapshot.data['cidade'];
          var bairro = snapshot.data['bairro'];
          var rua = snapshot.data['rua'];
          var numero = snapshot.data['numero'];
          return Scaffold(
            drawer: MenuDrawer(),
            appBar: AppBar(
              title: Text(nome),
              actions: [
                IconButton(
                    icon: Icon(Icons.arrow_back_outlined),
                    onPressed: () => Navigator.of(context).pop())
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.verticalSpace(15),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Nome: $nome',
                              style: kPrimalStyle,
                            ),
                          ),
                          cpf == ''
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('CPF: $cpf', style: kPrimalStyle),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text('Telefone1: $tel1', style: kPrimalStyle),
                                UIHelper.horizontalSpace(20),
                                InkWell(
                                  onTap: ()async{
                                    String tel = 'tel:+55$tel1';
                                    if(await canLaunch(tel)){
                                      await launch(tel);
                                    }else{
                                      throw "Não ligou para $tel";
                                    }
                                  },
                                  child: Icon(Icons.call))
                              ],
                            ),
                          ),
                          tel2 == ''
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('Telefone2: $tel2',
                                          style: kPrimalStyle),
                                      UIHelper.horizontalSpace(20),
                                      InkWell(
                                  onTap: ()async{
                                    String tel = 'tel:+55$tel2';
                                    if(await canLaunch(tel)){
                                      await launch(tel);
                                    }else{
                                      throw "Não ligou para $tel";
                                    }
                                  },
                                  child: Icon(Icons.call))
                                    ],
                                  ),
                                ),
                          cidade == ''
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Cidade: $cidade',
                                      style: kPrimalStyle),
                                ),
                          bairro == ''
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Bairro: $bairro',
                                      style: kPrimalStyle),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Rua: $rua', style: kPrimalStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Número: $numero', style: kPrimalStyle),
                          ),
                          UIHelper.verticalSpace(15),
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
                                      builder: (ctx) => DialogQr(
                                            title: 'Excluir Cliente',
                                            descreption:
                                                'Deseja realmente excluir esse cliente?',
                                            ok: 'Sim!',
                                            cancel: 'Cancelar',
                                            okColor: primaryColor,
                                            cancelColor: colorRed,
                                            okFun: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('clientes')
                                                  .doc(widget.idCliente)
                                                  .delete();
                                            },
                                          ));
                                },
                                child: Text(
                                  "Excluir",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                child: ElevatedButton(
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
                                                EditSelectedCliente(
                                                  idCliente: widget.idCliente,
                                                )));
                                  },
                                  child: Text(
                                    "Editar",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Serviços', style: kPrimalStyle),
                    ),
                    StreamBuilder(
                        stream: snapshots2,
                        builder: (ctx, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            default:
                              List<DocumentSnapshot> documents =
                                  snapshot.data.docs;

                              return Container(
                                height: 200,
                                child: ListView.builder(
                                    itemCount: documents.length,
                                    itemBuilder: (ctx, i) {
                                      var nome = documents[i].data()['modelo'];
                                      var data = documents[i]
                                          .data()['data']
                                          .toString();
                                      var id = documents[i].data()['id'];

                                      //print(documents[i].data()['id']);

                                      return Card(
                                        child: ListTile(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SelectedQr(
                                                        idCliente:
                                                            widget.idCliente,
                                                        idQr: id,
                                                      ))),
                                          title: Text(nome),
                                          subtitle: Text(data),
                                          trailing: Icon(
                                              Icons.keyboard_control_rounded),
                                        ),
                                      );
                                    }),
                              );
                          }
                        }),
                    UIHelper.verticalSpace(25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => GenerateJob(
                                  idCliente: widget.idCliente,
                                )));
                      },
                      child: Text(
                        "Adicionar serviço",
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
