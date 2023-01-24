import 'package:admin_dashboard/models/asignatura.dart';
import 'package:admin_dashboard/providers/providers.dart';
import 'package:admin_dashboard/ui/modals/asignatura_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AsignaturaDTS extends DataTableSource {
  final List<Asignatura> asignaturas;
  final BuildContext context;
  final bool isDelete;
  AsignaturaDTS({required this.asignaturas, required this.context, this.isDelete = true});
  @override
  DataRow getRow(int index) {
    final asignatura = this.asignaturas[index];
    final gpoPract = asignatura.grupPractica == 0 ? ' ' : '${asignatura.grupPractica}';
    final hrsPract = asignatura.grupPractica == 0 ? ' ' : '${asignatura.hPractica}';
    // Como se construye: implement getRow
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Container(width: 40, child: Text('${asignatura.codigo}'))),
        DataCell(Container(width: 30, child: Text('${asignatura.nombre}'))),
        DataCell(Text('${asignatura.hTeorica}')),
        DataCell(Text('${asignatura.grupTeoria}')),
        DataCell(Text('$hrsPract')),
        DataCell(Text('$gpoPract')),
        // botones
        DataCell(Row(
          children: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) => AsignaturaModal(asignatura: asignatura),
                  );
                },
                icon: Icon(Icons.edit_outlined)),
            if (isDelete)
              IconButton(
                  onPressed: () {
                    final dialog = AlertDialog(
                      title: Text('¿Estás seguro de borrarla?'),
                      content: Text('¿Borrar definitivamente ${asignatura.nombre}?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('No')),
                        // no se cerrar hasta que no elimine
                        TextButton(
                            onPressed: () async {
                              await Provider.of<AsignaturasProvider>(context, listen: false)
                                  .deleteAsignatura(asignatura.uid);
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
  int get rowCount => this.asignaturas.length;

  @override
  int get selectedRowCount => 0;
}
