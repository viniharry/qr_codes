import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfModel {
  static Future<File> generate(String modelo, String servico, String valor,
      String validade, String nome, String data) async {
    final pdf = Document();

    final logo =
        (await rootBundle.load('assets/Logo.png')).buffer.asUint8List();
    final selo =
        (await rootBundle.load('assets/selo.png')).buffer.asUint8List();

    pdf.addPage(MultiPage(
        build: (context) => <Widget>[
              Image(
                MemoryImage(logo),
                width: 200,
              ),
              Header(child: Text('Certificado de validade: $nome.    Execução: $data')),
              Table.fromTextArray(data: <List<String>>[
                <String>['Modelo', 'Serviço', 'Valor', 'Validade'],
                [modelo, servico, valor,validade]
              ]),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: Image(
                  MemoryImage(selo),
                  width: 100,
                ),
              ))
            ]));

    return saveDocument(name: 'validade.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    String name,
    Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
