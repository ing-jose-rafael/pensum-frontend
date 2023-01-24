import 'dart:io';
import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;

// import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future saveDocument({
    required String name,
    required Document pdf,
  }) async {
    //Create PDF in Bytes
    final Uint8List pdfInBytes = await pdf.save();

    // final dir = await getApplicationDocumentsDirectory();
    // final file = File('${dir.path}/$name');

    // await file.writeAsBytes(bytes);

    // return file;

    //Create blob and link from bytes
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '$name';
    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  // static Future openFile(File file) async {
  //   final url = file.path;

  //   await OpenFile.open(url);
  // }
}
