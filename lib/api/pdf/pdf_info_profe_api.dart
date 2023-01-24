import 'dart:math';

import 'package:admin_dashboard/api/pdf_api.dart';
import 'package:admin_dashboard/models/invoice_pdf.dart';
import 'package:admin_dashboard/models/profesor.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
// import 'package:flutter/material.dart' as material;

const PdfColor blue = PdfColor.fromInt(0xff2f487c);
const PdfColor orange = PdfColor.fromInt(0xffdd9e55);
const PdfColor lightGreen = PdfColor.fromInt(0xffcdf1e7);
const PdfColor lightGrey = PdfColor.fromInt(0xfff1f3f4);
const baseColor = PdfColors.cyan;
const sep = 120.0;

class PdfProfesorApi {
  static Future generate(Invoice invoice, List<Profesore> profesores) async {
    final pdf = Document();
    final pageTheme = await _myPageTheme(PdfPageFormat.a4);

    // final dataTable = invoice.dataChart;
    // final pageTheme = await _myPageTheme(format);
    // pdf.addPage(MultiPage(
    //   build: (context) => [
    //     buildHeader(invoice),
    //     SizedBox(height: 3 * PdfPageFormat.cm),
    //     buildTitle(invoice),
    //     buildInvoice(invoice),
    //     Divider(),
    //     // buildTotal(invoice),
    //   ],
    //   footer: (context) => buildFooter(invoice),
    // ));
    final cursos = profesores.map((p) {
      return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        buildTitleInf(p.nombre),
        _BuildTable(p),
        if (p.observaciones!.isNotEmpty) _BuildBlockText(p),
        pw.SizedBox(height: 17),
      ]);
    });

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (pw.Context context) => [
          pw.Partitions(
            children: [
              pw.Partition(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    buildEncabezado(context),
                    ...cursos,
                    pw.SizedBox(height: 20),
                    pw.Align(
                        alignment: pw.Alignment.center,
                        child: pw.Container(
                            height: 90 * PdfPageFormat.mm,
                            width: 120 * PdfPageFormat.mm,
                            child: builChart(invoice.dataChart))),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );

    await PdfApi.saveDocument(name: 'Informe_Profesor.pdf', pdf: pdf);
  }

  static pw.Container buildEncabezado(pw.Context context) {
    return pw.Container(
      // padding: const pw.EdgeInsets.only(left: 30, bottom: 20),
      padding: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Text(
            // textScaleFactor: 2,
            'Universidad del Atlántico',
            style: pw.Theme.of(context).defaultTextStyle.copyWith(fontWeight: pw.FontWeight.bold),
          ),
          // pw.Padding(padding: const pw.EdgeInsets.only(top: 5)),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          // pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
          pw.Text('Puerto Colombia, Atlántico, Colombia'),
          pw.SizedBox(height: 2 * PdfPageFormat.mm),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: <pw.Widget>[
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text('Programa de Farmacia', style: pw.TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.2),
                pw.Text('Asignación Académica', style: pw.TextStyle(fontWeight: FontWeight.bold)),
                pw.Text('Periodo: 2023-1'),
              ]),
              pw.SizedBox(height: 2 * PdfPageFormat.cm),
              buildInfPrograma(),
            ],
          ),
          // pw.Text('Programa de farmacia',
          //     textScaleFactor: 1.2,
          //     style: pw.Theme.of(context).defaultTextStyle.copyWith(fontWeight: pw.FontWeight.bold, color: orange)),
          // pw.Text('Periodo 2022-1',
          //     textScaleFactor: 1.2,
          //     style: pw.Theme.of(context).defaultTextStyle.copyWith(fontWeight: pw.FontWeight.bold, color: orange)),
          // pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
          // pw.Row(
          //   crossAxisAlignment: pw.CrossAxisAlignment.start,
          //   // mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          //   children: <pw.Widget>[
          //     pw.Column(
          //       crossAxisAlignment: pw.CrossAxisAlignment.start,
          //       children: <pw.Widget>[
          //         pw.Text('Duración:'),
          //         pw.Text('Metodología:'),
          //         pw.Text('Número de créditos:'),
          //       ],
          //     ),
          //     pw.Column(
          //       crossAxisAlignment: pw.CrossAxisAlignment.start,
          //       children: <pw.Widget>[
          //         pw.Text('Diez (10) semestres'),
          //         pw.Text('Presencial'),
          //         pw.Text('180'),
          //         // _UrlText('p.charlesbois@yahoo.com', 'mailto:p.charlesbois@yahoo.com'),
          //         // _UrlText('wholeprices.ca', 'https://wholeprices.ca'),
          //       ],
          //     ),
          //     pw.Padding(padding: pw.EdgeInsets.zero),
          //   ],
          // ),
        ],
      ),
    );
  }

  static pw.Column buildInfPrograma() {
    final date = DateTime.now();
    final titles = <String>['Duración:', 'Metodología:', 'Número de créditos:', 'Fecha de impresión:'];
    final data = <String>['Diez (10) semestres', 'Presencial', '180', Utils.formatDate(date)];
    final dataContaine = List.generate(
      titles.length,
      (index) {
        final title = titles[index];
        final value = data[index];
        return pw.Container(
          width: 200,
          child: pw.Row(
            children: [
              pw.Expanded(child: pw.Text(title, style: pw.TextStyle(fontWeight: FontWeight.bold))),
              pw.Text(value),
            ],
          ),
        );
      },
    );
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        ...dataContaine,
      ],
    );
  }

  static pw.Container buildTitleInf(String title) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        color: lightGreen,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      margin: const pw.EdgeInsets.only(bottom: 7, top: 20),
      padding: const pw.EdgeInsets.fromLTRB(10, 4, 10, 4),
      child: pw.Text(
        title,
        // textScaleFactor: 1.1,
      ),
    );
  }

  static pw.Column buildBlock({required pw.Context context, required String title}) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: <pw.Widget>[
      pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: <pw.Widget>[
        pw.Container(
          width: 6,
          height: 6,
          margin: const pw.EdgeInsets.only(top: 5.5, left: 2, right: 5),
          decoration: const pw.BoxDecoration(
            color: blue,
            shape: pw.BoxShape.circle,
          ),
        ),
        pw.Text(title, style: pw.Theme.of(context).defaultTextStyle.copyWith(fontWeight: pw.FontWeight.bold)),
        pw.Spacer(),
        // if (icon != null) pw.Icon(icon, color: lightGreen, size: 18),
      ]),
      pw.Container(
        decoration: const pw.BoxDecoration(border: pw.Border(left: pw.BorderSide(color: blue, width: 2))),
        padding: const pw.EdgeInsets.only(left: 10, top: 5, bottom: 5),
        margin: const pw.EdgeInsets.only(left: 5),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: <pw.Widget>[
          //TODO: construir la tabla
          pw.Lorem(length: 20),
        ]),
      ),
    ]);
  }

  static pw.Widget builChart(List<List<Object>> dataTable) {
    final expense = dataTable.map((e) => e[1] as num).reduce((value, element) => value + element);
    const chartColors = [
      PdfColors.blue300,
      PdfColors.green300,
      PdfColors.amber300,
      PdfColors.purple300,
      PdfColors.pink300,
      PdfColors.lime300,
      PdfColors.cyan300,
    ];
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Flexible(
          child: pw.Chart(
            title: pw.Text(
              'Distribución de Horas por Tipo de Contratación',
              style: pw.TextStyle(
                color: baseColor,
                fontSize: 20,
              ),
            ),
            grid: pw.PieGrid(),
            datasets: List<pw.Dataset>.generate(dataTable.length, (index) {
              final data = dataTable[index];
              final color = chartColors[index % chartColors.length];
              final value = (data[1] as num).toDouble();
              final pct = (value / expense * 100).round();
              return pw.PieDataSet(
                legend: '${data[0]}\n$pct%',
                value: value,
                color: color,
                legendStyle: const pw.TextStyle(fontSize: 10),
              );
            }),
          ),
        ),
      ],
    );
  }
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  final bgShape = await rootBundle.loadString('assets/fondo.svg');
  // final PdfPageFormat format2= PdfPageFormat.a4;
  format = format.applyMargin(
      left: 2.0 * PdfPageFormat.cm,
      top: 2.0 * PdfPageFormat.cm,
      right: 2.0 * PdfPageFormat.cm,
      bottom: 2.0 * PdfPageFormat.cm);
  return pw.PageTheme(
    pageFormat: format,
    // theme: pw.ThemeData.withFont(
    //   base:GoogleFonts.latoTextTheme,
    //   // base: await GoogleFonts.openSansRegular(),
    //   bold: await PdfGoogleFonts.openSansBold(),
    //   icons: await PdfGoogleFonts.materialIcons(),
    // ),
    buildBackground: (pw.Context context) {
      return pw.FullPage(
        ignoreMargins: true,
        // //TODO:diseño de fondo
        child: pw.Stack(
          children: [
            pw.Positioned(
              child: pw.SvgImage(svg: bgShape),
              left: 0,
              top: 0,
            ),
            pw.Positioned(
              child: pw.Transform.rotate(angle: pi, child: pw.SvgImage(svg: bgShape)),
              right: 0,
              bottom: 0,
            ),
          ],
        ),
      );
    },
  );
}

class Utils {
  static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat('d/M/y').format(date);
}

class _BuildBlockText extends pw.StatelessWidget {
  _BuildBlockText(this.profe);

  final Profesore profe;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: <pw.Widget>[
      pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: <pw.Widget>[
        pw.Container(
          width: 6,
          height: 6,
          margin: const pw.EdgeInsets.only(top: 5.5, left: 2, right: 5),
          decoration: const pw.BoxDecoration(
            color: blue,
            shape: pw.BoxShape.circle,
          ),
        ),
        pw.Text('Observación', style: pw.Theme.of(context).defaultTextStyle.copyWith(fontWeight: pw.FontWeight.bold)),
        pw.Spacer(),
        // if (icon != null) pw.Icon(icon, color: lightGreen, size: 18),
      ]),
      pw.Container(
        decoration: const pw.BoxDecoration(
          // border: pw.Border(left: pw.BorderSide(color: blue, width: 2)),
          color: lightGrey,
        ),
        padding: const pw.EdgeInsets.only(left: 10, top: 5, bottom: 5),
        margin: const pw.EdgeInsets.only(left: 5),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: <pw.Widget>[
          //TODO: construir la tabla
          // pw.Lorem(length: 20)
          pw.Text(profe.observaciones ?? ''),
        ]),
      ),
    ]);
  }
}

class _BuildTable extends pw.StatelessWidget {
  _BuildTable(this.profesor);
  final baseColor = PdfColors.cyan;
  final Profesore profesor;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: <pw.Widget>[
      pw.Text(profesor.contratacion),
      if (profesor.cargo!.isNotEmpty || profesor.cargo != '') pw.Text(profesor.cargo!),
      pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: <pw.Widget>[
        // pw.Container(
        //   width: 6,
        //   height: 6,
        //   margin: const pw.EdgeInsets.only(top: 5.5, left: 2, right: 5),
        //   decoration: const pw.BoxDecoration(
        //     color: blue,
        //     shape: pw.BoxShape.circle,
        //   ),
        // ),
        pw.Text('Total Horas Asignadas:'),
        SizedBox(width: 1 * PdfPageFormat.mm),
        pw.Text(profesor.horasAsi.toString(),
            style: pw.Theme.of(context).defaultTextStyle.copyWith(fontWeight: pw.FontWeight.bold)),
        pw.Spacer(),
        // if (icon != null) pw.Icon(icon, color: lightGreen, size: 18),
      ]),
      SizedBox(height: 1 * PdfPageFormat.mm),
      pw.Container(
        // decoration: const pw.BoxDecoration(border: pw.Border(left: pw.BorderSide(color: blue, width: 2))),
        // padding: const pw.EdgeInsets.only(left: 10, top: 5, bottom: 5),
        // margin: const pw.EdgeInsets.only(left: 5),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: <pw.Widget>[
          //TODO: construir la tabla
          // buildHearder(),
          buidTable(),
        ]),
      ),
    ]);
  }

  pw.Widget buidTable() {
    const tableHeaders = [
      'Código',
      'Curso',
      'Hrs Teoría',
      'Grps Teoría',
      'Hrs Práctica',
      'Grps Práctica',
    ];
    final data = profesor.cursos!.map((item) {
      final ht = item.grupoTeoria != 0 ? item.horaTeoria : '';
      final gt = item.grupoTeoria != 0 ? item.grupoTeoria : '';
      final hp = item.grupoPractica != 0 ? item.horaPractica : '';
      final gp = item.grupoPractica != 0 ? item.grupoPractica : '';
      return [
        item.codigo,
        item.asignatura.nombre,
        ht,
        gt,
        hp,
        gp,
      ];
    }).toList();
    return pw.Table.fromTextArray(
      headers: tableHeaders,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontWeight: pw.FontWeight.bold,
      ),
      headerDecoration: pw.BoxDecoration(
        color: baseColor,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: baseColor,
            width: .5,
          ),
        ),
      ),
      cellAlignment: pw.Alignment.center,
      cellAlignments: {0: pw.Alignment.centerLeft, 1: pw.Alignment.centerLeft},
      columnWidths: {
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(7),
        2: pw.FlexColumnWidth(2),
        3: pw.FlexColumnWidth(2),
        4: pw.FlexColumnWidth(2),
        5: pw.FlexColumnWidth(2),
      },
    );
  }

  pw.Container buildHearder() {
    return pw.Container(
      // height: 40,
      child: pw.Row(
        children: [
          buildHearderTitle('Código', 17),
          buildHearderTitle('Curso', 37),
          buildHearderTitle('Hrs Teoría', 24),
          buildHearderTitle('Grps Teoría', 24),
          buildHearderTitle('Hrs Practíca', 24),
          buildHearderTitle('Grps Practíca', 24),
        ],
      ),
    );
  }

  pw.Container buildHearderTitle(String texto, double ancho) {
    // pw.SizedBox(height: 1 * PdfPageFormat.mm),
    return pw.Container(
      width: ancho * PdfPageFormat.mm,
      // padding: const pw.EdgeInsets.all(15),
      decoration: const pw.BoxDecoration(border: pw.Border(left: pw.BorderSide(color: blue, width: 2))),
      child: pw.Text(
        texto,
        style: pw.TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
