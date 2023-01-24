import 'dart:html';
import 'dart:typed_data';

import 'package:admin_dashboard/api/pdf/pdf_info_profe_api.dart';
import 'package:admin_dashboard/api/pdf_api.dart';
import 'package:admin_dashboard/api/pdf_invoice_api.dart';
import 'package:admin_dashboard/models/invoice_pdf.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'dart:convert';
// import 'dart:html';

// import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

//Local imports
// import 'save_file_mobile.dart' if (dart.library.html) 'save_file_web.dart';

import 'package:admin_dashboard/providers/providers.dart';

import 'package:admin_dashboard/datatable/profesores_datasource.dart';

import 'package:admin_dashboard/ui/buttons/custom_icon_botton.dart';
import 'package:admin_dashboard/ui/modals/profesor_modal.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';

/** es StatefulWidget por que tenemos que manejar el estado  */
class ProfesoresView extends StatefulWidget {
  @override
  _ProfesoresViewState createState() => _ProfesoresViewState();
}

class _ProfesoresViewState extends State<ProfesoresView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    super.initState();
    // como el context esta global
    Provider.of<ProfesoresProvider>(context, listen: false).getProfesores();
  }

  @override
  Widget build(BuildContext context) {
    final providerProfe = Provider.of<ProfesoresProvider>(context);
    final profesores = providerProfe.profesores;
    final dtaChart = providerProfe.getDocentTipoContrato();
    // final profesoresSort = Provider.of<ProfesoresProvider>(context).getProfesoresSort();
    // print(profesoresSort);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('Profesores', style: CustomLabels.h1),
          SizedBox(height: 10),
          PaginatedDataTable(
            columns: [
              DataColumn(label: Text('Cédula')),
              DataColumn(label: Text('Nombre')),
              DataColumn(label: Text('Contratacion')),
              DataColumn(label: Text('Cargo')),
              DataColumn(label: Text('Tope')),
              DataColumn(label: Text('Hrs Asignadas')),
              DataColumn(label: Text('Acciones')),
            ],
            source: ProfesorDTS(profesores, context),
            header: Text(
              'Profesores Disponibles',
              maxLines: 2,
            ),
            onRowsPerPageChanged: (value) => setState(() {
              _rowsPerPage = value ?? 10;
            }),
            rowsPerPage: _rowsPerPage,
            actions: [
              CustomIconBotton(
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) => ProfesorModal(),
                  );
                },
                text: 'Nuevo',
                icon: Icons.add_outlined,
              ),
              CustomIconBotton(
                  color: Colors.blue,
                  //TODO: pdf
                  onPressed: () async {
                    final date = DateTime.now();
                    // final dueDate = date.add(Duration(days: 7));
                    /** *
                    //Create a PDF document.
                    PdfDocument document = PdfDocument();
                    //Add a page and draw text
                    document.pages.add().graphics.drawString(
                        'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 20),
                        brush: PdfSolidBrush(PdfColor(0, 0, 0)), bounds: Rect.fromLTWH(20, 60, 150, 30));
                    //Save the document
                    List<int> bytes = document.save();
                    //Download the output file
                    AnchorElement(href: "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
                      ..setAttribute("download", "output.pdf")
                      ..click();
                    //Dispose the document
                    document.dispose();
                     */

                    final data = profesores
                        .map(
                          (profe) => InvoiceItem(
                            nombre: profe.nombre,
                            cedula: profe.cedula,
                            hrsAsig: profe.horasAsi ?? 0,
                            vinculacio: profe.contratacion,
                            unitPrice: 5.99,
                          ),
                        )
                        .toList();
                    final invoice = Invoice(
                      supplier: Supplier(
                        name: 'Universidad del Atlántico',
                        address: 'Puerto Colombia, Atlántico, Colombia',
                        paymentInfo: 'https://www.uniatlantico.edu.co/uatlantico/node/635',
                      ),
                      customer: Customer(
                        name: 'Programa de Farmacia.',
                        address: 'Codigo SNIES, 91329',
                      ),
                      info: InvoiceInfo(
                        number: 'Diez (10) semestres',
                        dueDate: 'Presencial',
                        credito: '180',
                        date: date,
                        description: '',
                      ),
                      items: data,
                      dataChart: dtaChart,
                      // items: [
                      //   InvoiceItem(
                      //     nombre: 'Coffee',
                      //     cedula: 1,
                      //     hrsAsig: 3,
                      //     vat: 0.19,
                      //     unitPrice: 5.99,
                      //   ),
                      //   InvoiceItem(
                      //     nombre: 'Water',
                      //     cedula: 1,
                      //     hrsAsig: 8,
                      //     vat: 0.19,
                      //     unitPrice: 0.99,
                      //   ),
                      //   InvoiceItem(
                      //     nombre: 'Orange',
                      //     cedula: 1,
                      //     hrsAsig: 3,
                      //     vat: 0.19,
                      //     unitPrice: 2.99,
                      //   ),
                      //   InvoiceItem(
                      //     nombre: 'Apple',
                      //     cedula: 1,
                      //     hrsAsig: 8,
                      //     vat: 0.19,
                      //     unitPrice: 3.99,
                      //   ),
                      //   InvoiceItem(
                      //     nombre: 'Mango',
                      //     cedula: 1,
                      //     hrsAsig: 1,
                      //     vat: 0.19,
                      //     unitPrice: 1.59,
                      //   ),
                      //   InvoiceItem(
                      //     nombre: 'Blue Berries',
                      //     cedula: 1,
                      //     hrsAsig: 5,
                      //     vat: 0.19,
                      //     unitPrice: 0.99,
                      //   ),
                      //   InvoiceItem(
                      //     nombre: 'Lemon',
                      //     cedula: 1,
                      //     hrsAsig: 4,
                      //     vat: 0.19,
                      //     unitPrice: 1.29,
                      //   ),
                      // ],
                    );

                    // await PdfInvoiceApi.generate(invoice);
                    await PdfProfesorApi.generate(invoice, profesores);

                    // PdfApi.openFile(pdfFile);

                    // final pdf = pw.Document();
                    // pdf.addPage(pw.Page(
                    //     pageFormat: PdfPageFormat.a4,
                    //     build: (pw.Context context) {
                    //       return pw.Center(
                    //         child: pw.Text('Hello World'),
                    //       );
                    //     }));

                    // //Create PDF in Bytes
                    // Uint8List pdfInBytes = await pdf.save();
                    // //Create blob and link from bytes
                    // final blob = html.Blob([pdfInBytes], 'application/pdf');
                    // final url = html.Url.createObjectUrlFromBlob(blob);
                    // final anchor = html.document.createElement('a') as html.AnchorElement
                    //   ..href = url
                    //   ..style.display = 'none'
                    //   ..download = 'Informe_Profesor.pdf';
                    // html.document.body?.children.add(anchor);
                    // anchor.click();
                    // html.document.body?.children.remove(anchor);
                    // html.Url.revokeObjectUrl(url);
                  },
                  text: 'Reporte',
                  icon: Icons.picture_as_pdf_outlined),
            ],
          )
        ],
      ),
    );
  }
}
