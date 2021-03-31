import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_app/scan_qr.dart';

class CameraScan extends StatefulWidget {
  CameraScan({
    Key key,
  }) : super(key: key);

  @override
  _CameraScanState createState() => _CameraScanState();
}

class _CameraScanState extends State<CameraScan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Câmera"),
      ),
      body: Container(
        width: 600,
        child: Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              scan(); //barcode scnner
            },
            child: Text(
              "Câmera",
              style: TextStyle(fontSize: 28),
            ),
          ),
        ),
      ),
    );
  }

  Future scan() async {
    try {
      await BarcodeScanner.scan().then((value) {
        Navigator.of(context)
            .push(PageRouteBuilder(pageBuilder: (ctx, ani, __) {
          return FadeTransition(
            opacity: ani,
            child: ScanQR(id: value),
          );
        }));
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        return 'The user did not grant the camera permission! ${e.code}';
      } else {
        return 'Unknown error: $e';
      }
    } on FormatException {
      return 'null (User returned using the "back"-button before scanning anything. Result)';
    } catch (e) {
      return 'Unknown error: $e';
    }
  }
}
