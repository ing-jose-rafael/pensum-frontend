/** Cacaron para crear vistas*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_dashboard/datatable/users_datasource.dart';
import 'package:admin_dashboard/providers/users_provider.dart';
import 'package:admin_dashboard/ui/cards/white_card.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';

// class UsersView extends StatefulWidget {
//   @override
//   _UsersViewState createState() => _UsersViewState();
// }

class UsersView extends StatelessWidget {
  // @override
  // void initState() {
  //   Provider.of<UsersProvider>(context, listen: false).getUsers(); // obteniendo los usuarios
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);
    final sourceUser = new UsersDTS(usersProvider.users);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('Informacion de los Usuarios', style: CustomLabels.h1),
          SizedBox(height: 10),
          WhitrCard(
            title: 'Users Statistics',
            child: PaginatedDataTable(
              sortAscending: usersProvider.ascending,
              sortColumnIndex: usersProvider.sortColumnIdex,
              columns: [
                DataColumn(label: Text('Avatar')),
                DataColumn(
                    label: Text('Nombre'),
                    onSort: (colIndex, asc) {
                      usersProvider.sortColumnIdex = colIndex;
                      usersProvider.sort<String>((user) => user.nombre);
                    }),
                DataColumn(
                    label: Text('Email'),
                    onSort: (colIndex, asc) {
                      usersProvider.sortColumnIdex = colIndex;
                      usersProvider.sort<String>((user) => user.correo);
                    }),
                DataColumn(label: Text('UID')),
                DataColumn(label: Text('Acciones')),
              ],
              source: sourceUser,
              //cuando la pagina de la tabla cambia
              onPageChanged: (page) {
                print(page);
              },
              header: Text(
                'Usuarios Disponibles',
                maxLines: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
