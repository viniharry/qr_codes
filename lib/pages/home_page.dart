import 'package:flutter/material.dart';
import 'package:qr_code_app/pages/scan/camera_scan.dart';
import 'package:qr_code_app/components/menu_drawer.dart';

import 'scan/generate_qr.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(title: Text('Qr_Code'),),
        body: Container(
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CameraScan()));
            },
            child: Text(
              "Escanear",
              style: TextStyle(fontSize: 28),
            ),
          ),
          // SizedBox(height: 100),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     padding: EdgeInsets.all(15),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(20),
          //     ),
          //   ),
          //   onPressed: () {
          //     Navigator.of(context)
          //         .push(MaterialPageRoute(builder: (context) => GenerateQR()));
          //   },
          //   child: Text(
          //     "Gerar",
          //     style: TextStyle(fontSize: 28),
          //   ),
          // ),
        ],
      ),
    ));
  }
}
