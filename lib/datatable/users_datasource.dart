import 'package:admin_dashboard/models/usuario_model.dart';

import 'package:admin_dashboard/services/navigation_services.dart';

import 'package:flutter/material.dart';

class UsersDTS extends DataTableSource {
  final List<Usuario> users;
  UsersDTS(this.users);
  @override
  DataRow? getRow(int index) {
    final usuario = users[index];
    final image = (usuario.img == null)
        ? Image(image: AssetImage('assets/no-image.jpg'), width: 35, height: 35)
        : FadeInImage.assetNetwork(placeholder: 'assets/loader.gif', image: usuario.img!, width: 35, height: 35);
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(ClipOval(child: image)),
        DataCell(Text(usuario.nombre)),
        DataCell(Text(usuario.correo)),
        DataCell(Text(usuario.uid)),
        DataCell(Row(
          children: [
            IconButton(
                onPressed: () {
                  // TODO: NAVEGAR A  una nueva pantalla con el /uid
                  NavigationService.navigatorTo('/dashboard/users/${usuario.uid}');
                },
                icon: Icon(Icons.edit_outlined)),
          ],
        )),
      ],
    );
  }

  // isRowCountApproximate => false; cuando el dato es exacto
  @override
  bool get isRowCountApproximate => false;

  @override
  // cantidad de row
  int get rowCount => this.users.length;

  @override
  int get selectedRowCount => 0;
}
