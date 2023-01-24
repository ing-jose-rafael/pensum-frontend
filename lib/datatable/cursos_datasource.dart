import 'package:flutter/material.dart';

class CursoDTS extends DataTableSource {
  final List<Map<String, dynamic>> asignaturas;
  final BuildContext context;
  CursoDTS(this.asignaturas, this.context);
  @override
  DataRow getRow(int index) {
    final asignatura = this.asignaturas[index];
    late Color checkColor;
    late IconData checkIcon;
    switch (asignatura['color']) {
      case 1:
        checkColor = Colors.green;
        checkIcon = Icons.check;
        break;
      case 2:
        checkColor = Colors.amber;
        checkIcon = Icons.remove;
        break;
      case 3:
        checkColor = Colors.red;
        checkIcon = Icons.clear;
        break;
      default:
        checkColor = Colors.green;
        checkIcon = Icons.check;
    }
    // final gpoPract = asignatura.grupPractica == 0 ? ' ' : '${asignatura.grupPractica}';
    // final hrsPract = asignatura.grupPractica == 0 ? ' ' : '${asignatura.hPractica}';
    // Como se construye: implement getRow
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text('${asignatura['codigo']}')),
        DataCell(Text(asignatura['curso'])),
        DataCell(Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: checkColor),
          child: Icon(
            checkIcon,
            size: 20.0,
            color: Colors.white,
          ),
        )),
        // DataCell(Text('${asignatura.nombre}')),
        // DataCell(Text('${asignatura.hTeorica}')),
        // DataCell(Text('${asignatura.grupTeoria}')),
        // DataCell(Text('$hrsPract')),
        // DataCell(Text('$gpoPract')),
        // botones
        // DataCell(Row(
        //   children: [
        //     IconButton(
        //         onPressed: () {
        //           // showModalBottomSheet(
        //           //   backgroundColor: Colors.transparent,
        //           //   context: context,
        //           //   builder: (_) => AsignaturaModal(asignatura: asignatura),
        //           // );
        //         },
        //         icon: Icon(Icons.edit_outlined)),
        //     IconButton(
        //         onPressed: () {
        //           final dialog = AlertDialog(
        //             title: Text('¿Estás seguro de borrarla?'),
        //             content: Text('¿Borrar definitivamente?'),
        //             actions: [
        //               TextButton(
        //                   onPressed: () {
        //                     Navigator.of(context).pop();
        //                   },
        //                   child: Text('No')),
        //               // no se cerrar hasta que no elimine
        //               TextButton(
        //                   onPressed: () async {
        //                     // await Provider.of<AsignaturasProvider>(context, listen: false)
        //                     //     .deleteAsignatura(asignatura.uid);
        //                     Navigator.of(context).pop();
        //                   },
        //                   child: Text('Si, borrar')),
        //             ],
        //           );
        //           // Mostrando el showDialog
        //           showDialog(context: context, builder: (_) => dialog);
        //         },
        //         icon: Icon(Icons.delete_outline, color: Colors.red.withOpacity(0.8)))
        //   ],
        // )),
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
