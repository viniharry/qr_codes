import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/components/menu_drawer.dart';
import 'package:qr_code_app/model/client_model.dart';
import 'package:qr_code_app/pages/clientes/selected_cliente.dart';

class ClientesScreen extends StatefulWidget {
  @override
  _ClientesScreenState createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  bool isSearching = false;

  TextEditingController _searchController = TextEditingController();

  Future resultsLoads;
  List _allClients = [];
  List _resultFilter = [];

  _onSearchChanged() {
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var clientSnapshot in _allClients) {
        String nome = Client.fromSnapshot(clientSnapshot).nome.toLowerCase();
        String rua = Client.fromSnapshot(clientSnapshot).rua.toLowerCase();
        if (nome.contains(_searchController.text.toLowerCase()) ||
            rua.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapshot);
        }
      }
    } else {
      showResults = List.from(_allClients);
    }
    setState(() {
      _resultFilter = showResults;
    });
  }

  getClientesSnapshots() async {
    var snapshots =
        await FirebaseFirestore.instance.collection('clientes').get();

    setState(() {
      _allClients = snapshots.docs;
    });
    searchResultList();
    return 'ok';
  }

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoads = getClientesSnapshots();
  }

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
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    suffixIcon: InkWell(onTap: (){}, child: Icon(Icons.clear)),
                      hintText: 'Pesquisar', prefixIcon: Icon(Icons.search)),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _resultFilter.length,
                    itemBuilder: (context, index) {
                      var nome = _resultFilter[index].data()['nome'];
                      var rua = _resultFilter[index].data()['rua'];

                      return Card(
                        child: ListTile(
                            title: Text(nome),
                            subtitle: Text(rua),
                            trailing: Icon(Icons.keyboard_control_rounded),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectedCliente(
                                          idCliente: _resultFilter[index].id,
                                        )))),
                      );
                    }),
              ),
            ],
          ),
        ));
    //  StreamBuilder(
    //     stream: snapshots,
    //     builder: (ctx, snapshot) {
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.none:
    //         case ConnectionState.waiting:
    //           return Center(
    //             child: CircularProgressIndicator(),
    //           );
    //         default:
    //           List<DocumentSnapshot> documents = snapshot.data.docs;

    //           return ListView.builder(
    //               itemCount: documents.length,
    //               itemBuilder: (ctx, i) {
    //                 var nome = documents[i].data()['nome'];
    //                 var rua = documents[i].data()['rua'];

    //                 return Card(
    //                   child: ListTile(
    //                       title: Text(nome),
    //                       subtitle: Text(rua),
    //                       trailing: Icon(Icons.keyboard_control_rounded),
    //                       onTap: () => Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                               builder: (context) => SelectedCliente(
    //                                     idCliente: documents[i].id,
    //                                   )))),
    //                 );
    //               });
    //       }
    //     })
  }
}
