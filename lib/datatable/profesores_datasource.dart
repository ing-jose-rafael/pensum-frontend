import 'package:admin_dashboard/models/profesor.dart';
import 'package:admin_dashboard/providers/profesores_provider.dart';
import 'package:admin_dashboard/providers/providers.dart';
import 'package:admin_dashboard/ui/modals/profesor_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfesorDTS extends DataTableSource {
  final List<Profesore> profesores;

  final BuildContext context;
  ProfesorDTS(this.profesores, this.context);
  @override
  DataRow getRow(int index) {
    final profesor = this.profesores[index];
    // final gpoPract = asignatura.grupPractica == 0 ? ' ' : '${asignatura.grupPractica}';
    // final hrsPract = asignatura.grupPractica == 0 ? ' ' : '${asignatura.hPractica}';
    // Como se construye: implement getRow
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text('${profesor.cedula}')),
        DataCell(Text('${profesor.nombre}')),
        DataCell(Text('${profesor.contratacion}')),
        DataCell(Text('${profesor.cargo}')),
        DataCell(Text('${profesor.tope}')),
        DataCell(Text('${profesor.horasAsi}')),
        // DataCell(Text('$hrsPract')),
        // DataCell(Text('$gpoPract')),
        // botones
        DataCell(Row(
          children: [
            // editar
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) => ProfesorModal(profesor: profesor),
                  );
                },
                icon: Icon(Icons.edit_outlined)),
            // eliminar
            IconButton(
                onPressed: () {
                  final dialog = AlertDialog(
                    title: Text('¿Estás seguro de borrarla?'),
                    content: Text('¿Borrar definitivamente ${profesor.nombre}?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No')),
                      // no se cerrar hasta que no elimine
                      TextButton(
                          onPressed: () async {
                            await Provider.of<ProfesoresProvider>(context, listen: false).deleteProfesor(profesor.uid);
                            Navigator.of(context).pop();
                          },
                          child: Text('Si, borrar')),
                    ],
                  );
                  // Mostrando el showDialog
                  showDialog(context: context, builder: (_) => dialog);
                },
                icon: Icon(Icons.delete_outline, color: Colors.red.withOpacity(0.8)))
          ],
        )),
      ],
    );
  }

  @override
  // por si no se tiene el mumero exacto de columnas
  bool get isRowCountApproximate => false;

  @override
  // Numero de elementos
  int get rowCount => this.profesores.length;

  @override
  int get selectedRowCount => 0;
}
