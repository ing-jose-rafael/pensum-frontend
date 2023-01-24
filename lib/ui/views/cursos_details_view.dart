import 'package:admin_dashboard/api/pdf/pdf_curso.dart';
import 'package:admin_dashboard/models/pdf_info_curso.dart';
import 'package:admin_dashboard/models/profesor.dart';
import 'package:admin_dashboard/ui/modals/asignatura_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/datatable/cursos_datasource.dart';
import 'package:admin_dashboard/ui/buttons/custom_icon_botton.dart';

import 'package:admin_dashboard/providers/providers.dart';
// import 'package:admin_dashboard/providers/categories_provider.dart';
// import 'package:admin_dashboard/datatable/categories_datasource.dart';
// import 'package:admin_dashboard/datatable/asignaturas_datasource.dart';
// import 'package:admin_dashboard/ui/buttons/custom_icon_botton.dart';
// import 'package:admin_dashboard/ui/modals/asignatura_modal.dart';
// import 'package:admin_dashboard/ui/modals/categorie_modal.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';

/** es StatefulWidget por que tenemos que manejar el estado  */
class CursosDetailsView extends StatefulWidget {
  @override
  _CursosDetailsViewState createState() => _CursosDetailsViewState();
}

class _CursosDetailsViewState extends State<CursosDetailsView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    super.initState();
    // como el context esta global
    Provider.of<AsignaturasProvider>(context, listen: false).getAsignaturas();
    Provider.of<ProfesoresProvider>(context, listen: false).getProfesores();
  }

  @override
  Widget build(BuildContext context) {
    final asignaturaProvider = Provider.of<AsignaturasProvider>(context);
    final asignaturas = asignaturaProvider.getCursosEstado();
    final profesoresProv = Provider.of<ProfesoresProvider>(context).profesores;
    // print(profesoresProv.length);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('Cursos', style: CustomLabels.h1),
          SizedBox(height: 10),
          PaginatedDataTable(
            columns: [
              DataColumn(label: Text('Codigo')),
              DataColumn(label: Text('Curso')),
              DataColumn(label: Text('Estado')),
              // DataColumn(label: Text('Gpos Teoría')),
              // DataColumn(label: Text('Hrs Prácticas')),
              // DataColumn(label: Text('Gpos Prácticas')),
              // DataColumn(label: Text('Acciones')),
            ],
            source: CursoDTS(asignaturas, context),
            header: Text(
              'Cursos Disponibles',
              maxLines: 2,
            ),
            onRowsPerPageChanged: (value) => setState(() {
              _rowsPerPage = value ?? 10;
            }),
            rowsPerPage: _rowsPerPage,
            // actions: [CustomIconBotton(onPressed: () {}, text: 'text', icon: Icons.picture_as_pdf_outlined)],
            actions: [
              CustomIconBotton(
                color: Colors.blue,
                onPressed: () async {
                  //TODO:
                  final resp = asignaturaProvider.asignaturas.map((curso) {
                    List<PdfCursoProf> listProf = [];

                    curso.profesores!.forEach((idp) {
                      final tempP = profesoresProv.firstWhere((element) => element.uid == idp);

                      final cursoP = tempP.cursos!.firstWhere((item) => item.codigo == curso.codigo);

                      final dataTemo = new PdfCursoProf(
                          nombre: tempP.nombre, grupoTeoria: cursoP.grupoTeoria, grupoPractica: cursoP.grupoPractica);

                      listProf.add(dataTemo);
                    });

                    return PdfInfCurso(curso: curso, profesores: listProf);
                  }).toList();
                  await PdfCursos.generete(resp);
                },
                text: 'Descargar',
                icon: Icons.picture_as_pdf_outlined,
              ),
            ],
          )
        ],
      ),
    );
  }
}
