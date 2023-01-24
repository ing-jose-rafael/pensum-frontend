import 'package:admin_dashboard/models/asignatura.dart';
import 'package:admin_dashboard/providers/providers.dart';
import 'package:admin_dashboard/services/notification_services.dart';
import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

/** este modal servira para actualizar una asignatura o crearla */
class AsignaturaModal extends StatefulWidget {
  final Asignatura? asignatura;
  AsignaturaModal({Key? key, this.asignatura}) : super(key: key);

  @override
  _AsignaturaModalState createState() => _AsignaturaModalState();
}

class _AsignaturaModalState extends State<AsignaturaModal> {
  String? uid;
  String nombre = '';
  String codigo = '';
  int hTeorica = 0;
  int? hPractica;
  int grupTeoria = 0;
  int? grupPractica;
  int grupPracticaAsig = 0;
  int grupTeoriaAsig = 0;
  List<String>? profesores = [];

  @override
  void initState() {
    super.initState();
    uid = widget.asignatura?.uid;
    nombre = widget.asignatura?.nombre ?? '';
    codigo = widget.asignatura?.codigo ?? '';
    hTeorica = widget.asignatura?.hTeorica ?? 0;
    hPractica = widget.asignatura?.hPractica ?? 0;
    grupTeoria = widget.asignatura?.grupTeoria ?? 0;
    grupPractica = widget.asignatura?.grupPractica ?? 0;
    grupPracticaAsig = widget.asignatura?.grupPracticaAsig ?? 0;
    grupTeoriaAsig = widget.asignatura?.grupPracticaAsig ?? 0;
    profesores = widget.asignatura?.profesores ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<AsignaturasProvider>(context, listen: false);
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
                widget.asignatura?.nombre ?? 'Nueva asignatura',
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
            children: [
              Container(
                width: 150,
                child: TextFormField(
                  initialValue: widget.asignatura?.codigo,
                  onChanged: (value) => codigo = value,
                  decoration: CustomInput.authInputDecoration(
                    hint: 'Código de la Asignatura',
                    label: 'Código',
                    icon: Icons.new_releases_outlined,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 20),
              Container(
                width: 510,
                child: TextFormField(
                  initialValue: widget.asignatura?.nombre,
                  onChanged: (value) => nombre = value,
                  decoration: CustomInput.authInputDecoration(
                    hint: 'Nombre de la Asignatura',
                    label: 'Asignatura',
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
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  initialValue: widget.asignatura?.hTeorica.toString(),
                  onChanged: (value) {
                    if (value.isNotEmpty) hTeorica = int.parse(value);
                  },
                  decoration: CustomInput.authInputDecoration(
                    hint: 'Hrs Teoricas',
                    label: 'Horas Teoricas',
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
                  initialValue: widget.asignatura?.grupTeoria.toString(),
                  onChanged: (value) {
                    if (value.isNotEmpty) grupTeoria = int.parse(value);
                  },
                  decoration: CustomInput.authInputDecoration(
                    hint: 'Grps Teoria',
                    label: 'Grupos Teorias',
                    icon: Icons.new_releases_outlined,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 40),
              Container(
                width: 150,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  initialValue: widget.asignatura?.hPractica.toString() ?? '0',
                  onChanged: (value) {
                    if (value.isNotEmpty) hPractica = int.parse(value);
                  },
                  decoration: CustomInput.authInputDecoration(
                    hint: 'Hrs Práctica',
                    label: 'Horas Práctica',
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
                  initialValue: widget.asignatura?.grupPractica.toString(),
                  onChanged: (value) {
                    if (value.isNotEmpty) grupPractica = int.parse(value);
                  },
                  decoration: CustomInput.authInputDecoration(
                    hint: 'Grps Práctica',
                    label: 'Grps Práctica',
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
                  if (uid == null) {
                    // creando asignatura
                    await categoryProvider.newAsignatura(
                      cod: codigo,
                      name: nombre,
                      hTeorica: hTeorica,
                      hPractica: hPractica,
                      grupTeoria: grupTeoria,
                      grupPractica: grupPractica,
                    );
                    NotificationsService.showSnackBarOk('$nombre creado');
                    // mandar notificacion
                  } else {
                    // actualizar
                    await categoryProvider.updateAsignatura(
                        id: uid!,
                        name: nombre,
                        cod: codigo,
                        hTeorica: hTeorica,
                        hPractica: hPractica,
                        grupTeoria: grupTeoria,
                        grupPractica: grupPractica,
                        grupTeoriaAsig: grupTeoriaAsig,
                        grupPracticaAsig: grupPracticaAsig,
                        profesores: profesores);
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
