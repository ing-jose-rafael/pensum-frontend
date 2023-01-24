import 'package:admin_dashboard/models/profesor.dart';
import 'package:admin_dashboard/providers/providers.dart';
import 'package:admin_dashboard/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';

/** este modal servira para actualizar una categoria o crearla */
class CursoModal extends StatefulWidget {
  final Curso curso;
  final String idProfesor;

  CursoModal({Key? key, required this.curso, required this.idProfesor}) : super(key: key);

  @override
  _CursoModalState createState() => _CursoModalState();
}

class _CursoModalState extends State<CursoModal> {
  @override
  void initState() {
    super.initState();
    // en caso que tenga la categoria, caso contrario será nul
  }

  @override
  Widget build(BuildContext context) {
    final asignarCPProvider = Provider.of<AsignarCPProvider>(context, listen: false);
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
              Container(
                width: 700,
                child: Text(
                  widget.curso.asignatura.nombre,
                  style: CustomLabels.h1.copyWith(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: Colors.white)),
            ],
          ),
          Divider(color: Colors.white.withOpacity(0.3)),
          SizedBox(height: 20),
          /** en caso de tener la categoria utiliza el nombre
           * onChanged: (value)=>nombre=value, no hacemos un setstate por que no vamos a redibujar
           */

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  initialValue: widget.curso.grupoTeoria.toString(),
                  onChanged: (value) {
                    if (value.isNotEmpty) widget.curso.grupoTeoria = int.parse(value);
                  },
                  decoration: CustomInput.authInputDecoration(
                    hint: 'Grupos Teoria',
                    label: 'Grupos Teoria',
                    icon: Icons.new_releases_outlined,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 15),
              Container(
                width: 150,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  initialValue: widget.curso.grupoPractica.toString(),
                  onChanged: (value) {
                    if (value.isNotEmpty) widget.curso.grupoPractica = int.parse(value);
                  },
                  decoration: CustomInput.authInputDecoration(
                    hint: 'Grupos Practica',
                    label: 'Grupos Practica',
                    icon: Icons.new_releases_outlined,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          /** Boton en un coonteiner para ponerle margen */
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: CustomOutLinedButton(
                  text: 'Eliminar',
                  color: Colors.red.withOpacity(0.8),
                  isTextWhite: true,
                  // color: Colors.white,
                  onPressed: () async {
                    // try {
                    //   final resp = await asignarCPProvider.editarAsignacion(widget.idProfesor,
                    //       widget.curso.asignatura.id, widget.curso.grupoTeoria, widget.curso.grupoPractica!);

                    //   if (resp) {
                    //     NotificationsService.showSnackBarOk('${widget.curso.asignatura.nombre} actualizado!');
                    //   } else {
                    //     NotificationsService.showSnackBarError(
                    //         'No se pudo actualizar ${widget.curso.asignatura.nombre}!');
                    //   }

                    //   Navigator.of(context).pop();
                    // } catch (e) {
                    //   Navigator.of(context).pop();
                    //   NotificationsService.showSnackBarError(
                    //       'No se pudo actualizar ${widget.curso.asignatura.nombre}!');
                    // }
                    final dialog = AlertDialog(
                      title: Text('¿Estás seguro de borrar?'),
                      content: Text('¿Borrar definitivamente esta Asinación?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('No')),
                        // no se cerrar hasta que no elimine
                        TextButton(
                            onPressed: () async {
                              await asignarCPProvider.eliminarAsignacion(widget.idProfesor, widget.curso.asignatura.id);
                              // Provider.of<AsignaturasProvider>(context, listen: false)
                              //     .deleteAsignatura(widget.curso.asignatura.id);
                              Navigator.of(context).pop();
                            },
                            child: Text('Si, borrar')),
                      ],
                    );
                    // Mostrando el showDialog
                    await showDialog(context: context, builder: (_) => dialog);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              SizedBox(width: 20),
              Container(
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: CustomOutLinedButton(
                  text: 'Guardar',
                  isTextWhite: true,
                  // color: Colors.white,
                  onPressed: () async {
                    try {
                      final resp = await asignarCPProvider.editarAsignacion(widget.idProfesor,
                          widget.curso.asignatura.id, widget.curso.grupoTeoria, widget.curso.grupoPractica!);

                      if (resp) {
                        NotificationsService.showSnackBarOk('${widget.curso.asignatura.nombre} actualizado!');
                      } else {
                        NotificationsService.showSnackBarError(
                            'No se pudo actualizar ${widget.curso.asignatura.nombre}!');
                      }

                      Navigator.of(context).pop();
                    } catch (e) {
                      Navigator.of(context).pop();
                      NotificationsService.showSnackBarError(
                          'No se pudo actualizar ${widget.curso.asignatura.nombre}!');
                    }
                  },
                ),
              ),
            ],
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
