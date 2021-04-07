import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_app/pages/clientes/add_cliente.dart';
import 'package:qr_code_app/pages/clientes/selected_cliente.dart';

import 'pages/clientes/clientes_screen.dart';
import 'constants/colors.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qr Scaner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primaryColor
      ),
      routes: {
        '/': (context) => HomePage(),
        '/clientes_page':(context)=> ClientesScreen(),
        "/add_cliente_page": (context)=> AddCienteScreen(),
        '/selected_cliente_page':(context)=> SelectedCliente(idCliente: '',),
      },
    );
  }
}
