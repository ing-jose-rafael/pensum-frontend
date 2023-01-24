import 'package:admin_dashboard/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/models/categoria.dart';

import 'package:admin_dashboard/providers/categories_provider.dart';

import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';

/** este modal servira para actualizar una categoria o crearla */
class CategoryModal extends StatefulWidget {
  final Categoria? categoria; // si esto es null es por que se va crear una categoria
  CategoryModal({Key? key, this.categoria}) : super(key: key);

  @override
  _CategoryModalState createState() => _CategoryModalState();
}

class _CategoryModalState extends State<CategoryModal> {
  String nombre = '';
  String? id;
  @override
  void initState() {
    super.initState();
    // en caso que tenga la categoria, caso contrario será null
    id = widget.categoria?.id;
    nombre = widget.categoria?.nombre ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoriesProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(20),
      height: 500,
      width: 300, // se va expandir
      decoration: buildBoxDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.categoria?.nombre ?? 'Nueva Categoria',
                style: CustomLabels.h1.copyWith(color: Colors.white),
              ),
              IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: Colors.white)),
            ],
          ),
          Divider(color: Colors.white.withOpacity(0.3)),
          SizedBox(height: 20),
          /** en caso de tener la categoria utiliza el nombre
           * onChanged: (value)=>nombre=value, no hacemos un setstate por que no vamos a redibujar
           */
          TextFormField(
            initialValue: widget.categoria?.nombre,
            onChanged: (value) => nombre = value,
            decoration: CustomInput.authInputDecoration(
              hint: 'Nombre de la categoría',
              label: 'Categoría',
              icon: Icons.new_releases_outlined,
            ),
            style: TextStyle(color: Colors.white),
          ),
          /** Boton en un coonteiner para ponerle margen */
          Container(
            margin: const EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: CustomOutLinedButton(
              text: 'Guardar',
              isTextWhite: true,
              // color: Colors.white,
              onPressed: () async {
                try {
                  if (id == null) {
                    // creando categoria
                    await categoryProvider.newCategory(nombre);
                    NotificationsService.showSnackBarOk('$nombre creado');
                    // mandar notificacion
                  } else {
                    // actualizar
                    await categoryProvider.updateCategory(id!, nombre);
                    NotificationsService.showSnackBarOk('$nombre actualizado!');
                  }
                  Navigator.of(context).pop();
                } catch (e) {
                  Navigator.of(context).pop();
                  NotificationsService.showSnackBarError('No se pudo guardar $nombre!');
                }
              },
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
        color: Color(0xff0F2041),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black26),
        ],
      );
}
