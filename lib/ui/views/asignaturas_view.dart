import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/providers/providers.dart';
// import 'package:admin_dashboard/providers/categories_provider.dart';
// import 'package:admin_dashboard/datatable/categories_datasource.dart';
import 'package:admin_dashboard/datatable/asignaturas_datasource.dart';
import 'package:admin_dashboard/ui/buttons/custom_icon_botton.dart';
import 'package:admin_dashboard/ui/modals/asignatura_modal.dart';
// import 'package:admin_dashboard/ui/modals/categorie_modal.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';

/** es StatefulWidget por que tenemos que manejar el estado  */
class AsignaturasView extends StatefulWidget {
  @override
  _AsignaturasViewState createState() => _AsignaturasViewState();
}

class _AsignaturasViewState extends State<AsignaturasView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    super.initState();
    // como el context esta global
    Provider.of<AsignaturasProvider>(context, listen: false).getAsignaturas();
  }

  @override
  Widget build(BuildContext context) {
    final asignaturas = Provider.of<AsignaturasProvider>(context).asignaturas;

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
              DataColumn(label: Text('Acciones')),
            ],
            source: AsignaturaDTS(asignaturas: asignaturas, context: context),
            header: Text(
              'Cursos Disponibles',
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
                    builder: (_) => AsignaturaModal(),
                  );
                },
                text: 'Crear',
                icon: Icons.add_outlined,
              ),
              // TextButton(
              //     onPressed: () {
              //       // llamando el modal
              //       showModalBottomSheet(context: context, builder: (_) => CategoryModal());
              //     },
              //     child: Text('Hola')),
            ],
          )
        ],
      ),
    );
  }
}
