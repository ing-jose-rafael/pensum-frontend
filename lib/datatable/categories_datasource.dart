import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/models/categoria.dart';
import 'package:admin_dashboard/providers/categories_provider.dart';
import 'package:admin_dashboard/ui/modals/categorie_modal.dart';

class CategoriesDTS extends DataTableSource {
  final List<Categoria> categorias;
  final BuildContext context;
  CategoriesDTS(this.categorias, this.context);
  @override
  DataRow getRow(int index) {
    final categoria = this.categorias[index];
    // Como se construye: implement getRow
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text('${categoria.id}')),
        DataCell(Text('${categoria.nombre}')),
        DataCell(Text('${categoria.usuario.nombre}')),
        // botones
        DataCell(Row(
          children: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) => CategoryModal(categoria: categoria),
                  );
                },
                icon: Icon(Icons.edit_outlined)),
            IconButton(
                onPressed: () {
                  final dialog = AlertDialog(
                    title: Text('¿Estás seguro de borrarlo?'),
                    content: Text('¿Borrar definitivamente ${categoria.nombre}?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No')),
                      // no se cerrar hasta que no elimine
                      TextButton(
                          onPressed: () async {
                            await Provider.of<CategoriesProvider>(context, listen: false).deleteCategoria(categoria.id);
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
  int get rowCount => this.categorias.length;

  @override
  int get selectedRowCount => 0;
}
