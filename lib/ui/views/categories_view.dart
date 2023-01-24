import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/providers/categories_provider.dart';
import 'package:admin_dashboard/datatable/categories_datasource.dart';
import 'package:admin_dashboard/ui/buttons/custom_icon_botton.dart';
import 'package:admin_dashboard/ui/modals/categorie_modal.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';

/** es StatefulWidget por que tenemos que manejar el estado  */
class CategoriesView extends StatefulWidget {
  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    super.initState();
    // como el context esta global
    Provider.of<CategoriesProvider>(context, listen: false).getCategories();
  }

  @override
  Widget build(BuildContext context) {
    final categorias = Provider.of<CategoriesProvider>(context).categories;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('Categorías', style: CustomLabels.h1),
          SizedBox(height: 10),
          PaginatedDataTable(
            columns: [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Categoria')),
              DataColumn(label: Text('Creado por')),
              DataColumn(label: Text('Acciones')),
            ],
            source: CategoriesDTS(categorias, context),
            header: Text(
              'Categorías Disponibles',
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
                    builder: (_) => CategoryModal(),
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
