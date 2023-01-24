import 'package:admin_dashboard/models/profesor.dart';

import 'package:admin_dashboard/providers/providers.dart';
import 'package:admin_dashboard/services/notification_services.dart';
import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

/** este modal servira para actualizar una asignatura o crearla */
class ProfesorModal extends StatefulWidget {
  final Profesore? profesor;
  ProfesorModal({Key? key, this.profesor}) : super(key: key);

  @override
  _ProfesorModalState createState() => _ProfesorModalState();
}

class _ProfesorModalState extends State<ProfesorModal> {
  String nombre = '';
  String cedula = '';
  String contratacion = '';
  String observaciones = '';
  String? cargo;
  int? tope;
  int? horasAsi;
  List<Curso>? cursos = [];
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = widget.profesor?.uid;
    nombre = widget.profesor?.nombre ?? '';
    cedula = widget.profesor?.cedula ?? '';
    contratacion = widget.profesor?.contratacion ?? '';
    observaciones = widget.profesor?.observaciones ?? '';
    cargo = widget.profesor?.cargo ?? '';
    tope = widget.profesor?.tope ?? 0;
    horasAsi = widget.profesor?.horasAsi ?? 0;
    cursos = widget.profesor?.cursos ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final profesorProvider = Provider.of<ProfesoresProvider>(context, listen: false);

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
                widget.profesor?.nombre ?? 'Nuevo Profesor',
                style: CustomLabels.h1.copyWith(color: Colors.white),
              ),
              IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: Colors.white)),
            ],
          ),
          Divider(color: Colors.white.withOpacity(0.3)),
          SizedBox(height: 10),
          /** en caso de tener la categoria utiliza el nombre
           * onChanged: (value)=>nombre=value, no hacemos un setstate por que no vamos a redibujar
           */

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 150,
                        child: TextFormField(
                          initialValue: widget.profesor?.cedula,
                          onChanged: (value) => cedula = value,
                          decoration: CustomInput.authInputDecoration(
                            hint: 'Cédula',
                            label: 'Cédula',
                            icon: Icons.new_releases_outlined,
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 380,
                        child: TextFormField(
                          initialValue: widget.profesor?.nombre,
                          onChanged: (value) => nombre = value,
                          decoration: CustomInput.authInputDecoration(
                            hint: 'Nombre',
                            label: 'Profesor',
                            icon: Icons.new_releases_outlined,
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        width: 150,
                        child: TextFormField(
                          initialValue: widget.profesor?.contratacion,
                          onChanged: (value) => contratacion = value,
                          decoration: CustomInput.authInputDecoration(
                            hint: 'Contratación',
                            label: 'Tipo contrato',
                            icon: Icons.new_releases_outlined,
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 210,
                        child: TextFormField(
                          initialValue: widget.profesor?.cargo,
                          onChanged: (value) => cargo = value,
                          decoration: CustomInput.authInputDecoration(
                            hint: 'Cargo',
                            label: 'Cargo adtvo',
                            icon: Icons.new_releases_outlined,
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 150,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          initialValue: widget.profesor?.tope.toString() ?? '0',
                          onChanged: (value) {
                            if (value.isNotEmpty) tope = int.parse(value);
                          },
                          decoration: CustomInput.authInputDecoration(
                            hint: 'Tope Hrs Asignadas',
                            label: 'Tope Hrs',
                            icon: Icons.new_releases_outlined,
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
              Container(
                width: 400,
                // height: 160,
                // color: Colors.red,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  initialValue: widget.profesor?.observaciones,
                  onChanged: (value) => observaciones = value,
                  decoration: CustomInput.authInputDecoration(
                    hint: 'Observaciones',
                    label: 'Observaciones',
                    icon: Icons.new_releases_outlined,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
          // /** Boton en un coonteiner para ponerle margen */
          Container(
            margin: const EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: CustomOutLinedButton(
              text: 'Guardar',
              isTextWhite: true,
              // color: Colors.white,
              onPressed: () async {
                try {
                  // creando profesor
                  if (uid == null) {
                    await profesorProvider.newProfesor(
                        cedula: cedula,
                        nombre: nombre,
                        contratacion: contratacion,
                        cargo: cargo,
                        tope: tope,
                        observaciones: observaciones);
                    NotificationsService.showSnackBarOk('$nombre creado');
                    // mandar notificacion
                  } else {
                    // actualizar
                    await profesorProvider.updateProfesor(
                      id: uid!,
                      cedula: cedula,
                      nombre: nombre,
                      contratacion: contratacion,
                      cargo: cargo,
                      tope: tope,
                      cursos: cursos,
                      horasAsi: horasAsi,
                      observaciones: observaciones,
                    );
                    NotificationsService.showSnackBarOk('$nombre actualizado!');
                  }
                  Navigator.of(context).pop();
                } catch (e) {
                  print(e);
                  Navigator.of(context).pop();
                  NotificationsService.showSnackBarError('No se pudo guardar $nombre!');
                }
              },
            ),
          ),
          SizedBox(height: 20)
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
