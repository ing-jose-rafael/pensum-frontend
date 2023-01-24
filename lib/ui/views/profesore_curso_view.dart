/** Cacaron para crear vistas*/
import 'package:admin_dashboard/datatable/asignaturas_datasource.dart';
import 'package:admin_dashboard/datatable/consulta_profe_datasource.dart';
import 'package:admin_dashboard/models/asignatura.dart';
import 'package:admin_dashboard/models/profesor.dart';
import 'package:admin_dashboard/providers/providers.dart';
import 'package:admin_dashboard/ui/modals/curso_modal.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard/ui/cards/white_card.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfesorCursosView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profesorProvider = Provider.of<ProfesoresProvider>(context);
    final asignarCPProvider = Provider.of<AsignarCPProvider>(context);
    final existData = asignarCPProvider.existProf;
    final profesor = existData ? asignarCPProvider.profesor : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('Consultar Docente', style: CustomLabels.h1),
          SizedBox(height: 10),
          // DropdownSearch profesor
          WhitrCard(
            // title: 'Blank Statistics',
            child: Container(
              // width: 400,
              child: DropdownSearch<Profesore>(
                // items: [...profesorProvider.profesores],

                maxHeight: 300,
                onFind: (String? filter) async {
                  await profesorProvider.getProfesores();
                  return profesorProvider.profesores;
                  // return await profesorProvider.getData(termino: filter!);
                  // return profesorProvider.getData(termino: filter!);
                },
                // onFind: (String? filter) => getData(filter),
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Selecione un Profesor(a)",
                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                  border: OutlineInputBorder(),
                ),
                onChanged: (data) {
                  asignarCPProvider.profesor = data;
                },
                showSearchBox: true,
                showClearButton: true,
                showSelectedItems: true,
                compareFn: (i, s) => i?.isEqual(s!) ?? false,

                // dropdownBuilder: _customDropDownExample,
                popupItemBuilder: _customPopupItemBuilderExample2,
              ),
            ),
          ),
          // tablas con cursos
          // WhitrCard(
          //   title: existData ? asignarCPProvider.profesor.nombre : 'Información del Docente',
          //   child: Container(
          //     // margin: const EdgeInsets.only(left: 80, right: 93),
          //     child: Column(
          //       children: [
          //         Container(
          //           height: 50,
          //           child: Row(
          //             children: [
          //               EncabezadosText(texto: 'Codigo', ancho: 90),
          //               EncabezadosText(texto: 'Curso', ancho: 170),
          //               EncabezadosText(texto: 'Hrs Teoría', ancho: 141),
          //               EncabezadosText(texto: 'Grps Teorías', ancho: 141),
          //               EncabezadosText(texto: 'Hrs Practíca', ancho: 141),
          //               EncabezadosText(texto: 'Grps Practícas', ancho: 141),
          //               // EncabezadosText(texto: 'Observaciones', ancho: 170),
          //             ],
          //           ),
          //         ),
          //         ColumTablCurso(
          //           data: existData ? profesor!.cursos! : [],
          //           idProfesor: existData ? profesor!.uid : '',
          //         ),
          //         Divider(),
          //         Container(
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Container(
          //                 // height: 42,
          //                 width: 560,
          //                 color: Colors.grey.withOpacity(0.07),
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Text('Observaciones:'),
          //                     Text(existData ? profesor!.observaciones ?? ' ' : ' '),
          //                   ],
          //                 ),
          //               ),
          //               SizedBox(width: 65),
          //               Text(
          //                 'Total Hrs Asignadas:',
          //                 style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
          //               ),
          //               // SizedBox(width: 5),
          //               Text(
          //                 existData ? profesor!.horasAsi.toString() : '',
          //                 style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
          //               ),
          //             ],
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          WhitrCard(child: _TablaConsultaCursos(asignaturas: existData ? profesor!.cursos! : [])),
        ],
      ),
    );
  }

  Widget _customPopupItemBuilderExample2(BuildContext context, Profesore? item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.nombre ?? ''),
        subtitle: Text(item?.horasAsi?.toString() ?? ''),
        leading: CircleAvatar(
            // this does not work - throws 404 error
            // backgroundImage: NetworkImage(item.avatar ?? ''),
            ),
      ),
    );
  }
}

class _TablaConsultaCursos extends StatelessWidget {
  final List<Curso> asignaturas;

  _TablaConsultaCursos({required this.asignaturas});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('Cursos', style: CustomLabels.h1),
          SizedBox(height: 10),
          PaginatedDataTable(
            columns: [
              DataColumn(label: Text('Cod')),
              DataColumn(label: Text('Curso')),
              DataColumn(label: Text('Hrs Teoría')),
              DataColumn(label: Text('Gpos Teoría')),
              DataColumn(label: Text('Hrs Prácticas')),
              DataColumn(label: Text('Gpos Prácticas')),
              // DataColumn(label: Text('Acciones')),
            ],
            source: ConsultaProfeDTS(asignaturas: asignaturas, context: context),
            header: Text(
              'Cursos Disponibles',
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }
}

class ColumTablCurso extends StatelessWidget {
  final String idProfesor;
  ColumTablCurso({
    Key? key,
    required this.data,
    required this.idProfesor,
  }) : super(key: key);
  final List<Curso> data;
  final boxDecoration = BoxDecoration(border: Border.all(color: Colors.black87.withOpacity(0.09)));

  @override
  Widget build(BuildContext context) {
    final double tam = data.length * 41.0;

    return Container(
      height: tam,
      // width: 700,
      child: ListView(
        children: _crearItem(context),
      ),
    );
  }

  List<Widget> _crearItem(BuildContext context) {
    return data.map((curso) {
      final grpTeori = (curso.grupoTeoria == 0) ? '' : curso.grupoTeoria.toString();
      final grpPract = (curso.grupoPractica == 0) ? '' : curso.grupoPractica.toString();

      final hrsTeori = (curso.grupoTeoria == 0) ? '' : curso.horaTeoria.toString();
      final hrsPract = (curso.grupoPractica == 0) ? '' : curso.horaPractica.toString();

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (_) => CursoModal(
              curso: curso,
              idProfesor: idProfesor,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                width: 90,
                height: 41,
                decoration: boxDecoration,
                child: Align(
                  alignment: Alignment.center,
                  child: CuerpoText(texto: curso.codigo),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 170,
                height: 41,
                decoration: boxDecoration,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CuerpoText(texto: curso.asignatura.nombre),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 141,
                height: 41,
                decoration: boxDecoration,
                child: Align(
                  alignment: Alignment.center,
                  child: CuerpoText(texto: hrsTeori),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 141,
                height: 41,
                decoration: boxDecoration,
                child: Align(
                  alignment: Alignment.center,
                  child: CuerpoText(texto: grpTeori),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 141,
                height: 41,
                decoration: boxDecoration,
                child: Align(
                  alignment: Alignment.center,
                  child: CuerpoText(texto: hrsPract),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 141,
                height: 41,
                decoration: boxDecoration,
                child: Align(
                  alignment: Alignment.center,
                  child: CuerpoText(texto: grpPract),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class EncabezadosText extends StatelessWidget {
  final String texto;
  final double ancho;
  const EncabezadosText({Key? key, required this.texto, required this.ancho}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: ancho,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.purpleAccent,
        border: Border.all(color: Colors.black.withOpacity(0.5)),
      ),
      child: FittedBox(
          child: Text(
        texto,
        style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
      )),
    );
  }
}

class CuerpoText extends StatelessWidget {
  final String texto;
  // final double ancho;
  const CuerpoText({
    Key? key,
    required this.texto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Text(
        texto,
        style: GoogleFonts.roboto(fontSize: 13),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}
