import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/components/menu_drawer.dart';
import 'package:qr_code_app/pages/clientes/selected_cliente.dart';

class ClientesScreen extends StatefulWidget {
  @override
  _ClientesScreenState createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  @override
  Widget build(BuildContext context) {
    var snapshots =
        FirebaseFirestore.instance.collection('clientes').snapshots();

    return Scaffold(
        drawer: MenuDrawer(),
        appBar: AppBar(
          title: Text('Clientes'),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () =>
                    Navigator.pushNamed(context, '/add_cliente_page'))
          ],
        ),
        body: StreamBuilder(
            stream: snapshots,
            builder: (ctx, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  List<DocumentSnapshot> documents = snapshot.data.docs;

                  return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (ctx, i) {
                        var nome = documents[i].data()['nome'];
                        var rua = documents[i].data()['rua'];

                        return Card(
                          child: ListTile(
                              title: Text(nome),
                              subtitle: Text(rua),
                              trailing: Icon(Icons.keyboard_control_rounded),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SelectedCliente(
                                            idCliente: documents[i].id,
                                          )))
                                          ),
                        );
                      });
              }
            }));
  }
}
