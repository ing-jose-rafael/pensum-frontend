import 'dart:math';

import 'package:admin_dashboard/api/pdf_api.dart';
import 'package:admin_dashboard/models/asignatura.dart';
import 'package:admin_dashboard/models/pdf_info_curso.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

const PdfColor lightGreen = PdfColor.fromInt(0xffcdf1e7);
const PdfColor blue = PdfColor.fromInt(0xff2f487c);

class PdfCursos {
  // List<PdfInfCurso> lisData;

  // PdfCursos(this.lisData);

  static Future generete(List<PdfInfCurso> data) async {
    final pdf = Document();
    final pageTheme = await _myPageTheme(PdfPageFormat.a4);

    final infProfesores = data.map(
      (pdfInfCurso) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        _buildTitleInf(pdfInfCurso.curso.nombre),
        _BuildTable(pdfInfCurso.curso, pdfInfCurso.profesores),
      ]),
    );

    // crear contenido pdf
    pdf.addPage(pw.MultiPage(
      pageTheme: pageTheme,
      build: (pw.Context context) => [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          // encabezado
          _BuildHeaderDoc(),
          //Tabla
          ...infProfesores,
        ]),
      ],
    ));

    await PdfApi.saveDocument(name: 'Informe_Curso.pdf', pdf: pdf);
  }

  static pw.Container _buildTitleInf(String title) {
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
}

class _BuildHeaderDoc extends pw.StatelessWidget {
  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text(
          'Universidad del Atlántico',
          style: pw.Theme.of(context).defaultTextStyle.copyWith(fontWeight: pw.FontWeight.bold),
          // textScaleFactor: 2,
        ),
        pw.SizedBox(height: 1 * PdfPageFormat.mm),
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
      ]),
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
}

class _BuildTable extends pw.StatelessWidget {
  _BuildTable(this.curso, this.pdfPrpfe);
  final Asignatura curso;
  final List<PdfCursoProf> pdfPrpfe;
  final baseColor = PdfColors.cyan;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: <pw.Widget>[
      // pw.Text(profesor.contratacion),
      builTextAndPoint(1, context),
      if (curso.grupPractica != 0) builTextAndPoint(2, context),
      SizedBox(height: 1 * PdfPageFormat.mm),
      pw.Container(
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: <pw.Widget>[
          buidTable(),
        ]),
      ),
    ]);
  }

  pw.Widget buidTable() {
    const tableHeaders = [
      'Docente',
      // 'Curso',
      'Grps Teoría',
      'Hrs Teoría',
      'Grps Práctica',
      'Hrs Práctica',
    ];
    final data = pdfPrpfe.map((item) {
      final gP = item.grupoPractica != 0 ? item.grupoPractica : '';
      final gT = item.grupoTeoria != 0 ? item.grupoTeoria : '';
      final hT = item.grupoTeoria != 0 ? curso.hTeorica * item.grupoTeoria : '';
      final hP = item.grupoPractica != 0 ? curso.hPractica! * item.grupoPractica! : '';
      return [
        item.nombre,
        gT,
        hT,
        gP,
        hP,
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
        0: pw.FlexColumnWidth(8),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(2),
        3: pw.FlexColumnWidth(2),
        4: pw.FlexColumnWidth(2),
      },
    );
  }

  pw.Widget builTextAndPoint(int value, pw.Context context) {
    final String valueGrp = value == 1 ? curso.grupTeoria.toString() : curso.grupPractica.toString();
    final String valueHrs = value == 1 ? curso.hTeorica.toString() : curso.hPractica.toString();
    final String textHora = value == 1 ? 'Horas Teoría' : 'Horas Práctica';
    final String text = value == 1 ? 'Grupos Teoría' : 'Grupos Práctica';

    return pw.Container(
      width: 280,
      child: pw.Row(
        // mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Container(
            width: 6,
            height: 6,
            margin: const pw.EdgeInsets.only(top: 5.5, left: 2, right: 5),
            decoration: const pw.BoxDecoration(
              color: blue,
              shape: pw.BoxShape.circle,
            ),
          ),
          pw.Expanded(
              child:
                  pw.Text(text, style: pw.Theme.of(context).defaultTextStyle.copyWith(fontWeight: pw.FontWeight.bold))),
          pw.Text(valueGrp),
          pw.SizedBox(width: 10 * PdfPageFormat.mm),
          pw.Expanded(
              child: pw.Text(textHora,
                  style: pw.Theme.of(context).defaultTextStyle.copyWith(fontWeight: pw.FontWeight.bold))),
          // pw.Text(textHora),
          pw.Text(valueHrs),
        ],
      ),
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
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
  static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';
}
