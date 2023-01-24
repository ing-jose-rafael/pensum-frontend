/** Cacaron para crear vistas*/
import 'package:admin_dashboard/models/asignatura.dart';
import 'package:admin_dashboard/models/profesor.dart';
import 'package:admin_dashboard/providers/providers.dart';
import 'package:admin_dashboard/services/notification_services.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:admin_dashboard/ui/cards/white_card.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AsignarCursoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('Asinar', style: CustomLabels.h1),
          SizedBox(height: 10),
          Wrap(
            children: [
              WhitrCard(
                title: 'Asignar curso profesor',
                child: _Body(),
                width: 500,
              ),
              WhitrCard(
                title: 'Información',
                child: Container(
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoProfesorSelected(),
                      Divider(),
                      _InfoCurso(),
                    ],
                  ),
                ),
                width: 500,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCurso extends StatelessWidget {
  const _InfoCurso({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final asignarCPProvider = Provider.of<AsignarCPProvider>(context);
    final nombre = asignarCPProvider.existAsig ? asignarCPProvider.asignatura.codigo : '------  ';

    return Container(
      // height: 142,
      child: Column(
        children: [
          Text('Información Asignatura'),
          SizedBox(height: 5),
          Row(
            children: [
              Text('Codigo:'),
              SizedBox(width: 5),
              LabelText(text: nombre),
              SizedBox(width: 60),
              Text('Nombre:'),
              SizedBox(width: 5),
              // TODO:
              Container(
                width: 240,
                height: 20,
                // height: 10,
                // color: Colors.blue,
                // child: Text(
                //   'Lorem Ipsum is simply dummy text of the printing',
                //   overflow: TextOverflow.ellipsis,
                // ),
                child: LabelText(text: asignarCPProvider.existAsig ? asignarCPProvider.asignatura.nombre : ' '),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Gurpo Teoria:'),
              Text('Grup Teoria Asignados:'),
              Text('Horas Teórica:'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  padding: const EdgeInsets.only(right: 60),
                  child: LabelText(
                      text: asignarCPProvider.existAsig ? asignarCPProvider.asignatura.grupTeoria.toString() : ' ')),
              LabelText(
                  text: asignarCPProvider.existAsig ? asignarCPProvider.asignatura.grupTeoriaAsig.toString() : ' '),
              Container(
                child: LabelText(
                    text: asignarCPProvider.existAsig ? asignarCPProvider.asignatura.hTeorica.toString() : ' '),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Grp Práctica:'),
              Text('Grp Práctica Asignados:'),
              Text('Horas Práctica:'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  padding: const EdgeInsets.only(right: 60),
                  child: LabelText(
                      text: asignarCPProvider.existAsig ? asignarCPProvider.asignatura.grupPractica.toString() : ' ')),
              LabelText(
                  text: asignarCPProvider.existAsig ? asignarCPProvider.asignatura.grupPracticaAsig.toString() : ' '),
              Container(
                  child: LabelText(
                      text: asignarCPProvider.existAsig ? asignarCPProvider.asignatura.hPractica.toString() : ' ')),
            ],
          ),
        ],
      ),
    );
  }
}

class LabelText extends StatelessWidget {
  final String text;
  const LabelText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.bold),
      overflow: TextOverflow.ellipsis,
      // maxLines: 2,
    );
  }
}

class _InfoProfesorSelected extends StatelessWidget {
  const _InfoProfesorSelected({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final asignarCPProvider = Provider.of<AsignarCPProvider>(context);
    return Container(
      // height: 142,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text('Información Profesor')),
          SizedBox(height: 2),
          buildLabelProf('Nombre', asignarCPProvider.existProf ? asignarCPProvider.profesor.nombre : ' '),
          buildLabelProf('Tipo Contrato', asignarCPProvider.existProf ? asignarCPProvider.profesor.contratacion : ' '),
          buildLabelProf(
              'Cargo:', asignarCPProvider.existProf ? asignarCPProvider.profesor.cargo ?? 'No tiene cargo' : ' '),
          buildLabelProf(
              'Tope de Horas:', asignarCPProvider.existProf ? asignarCPProvider.profesor.tope.toString() : ' '),
          buildLabelProf(
              'Horas Asignadas:', asignarCPProvider.existProf ? asignarCPProvider.profesor.horasAsi.toString() : ' '),
          // SizedBox(height: 26)
        ],
      ),
    );
  }

  Widget buildLabelProf(String title, String subTitle) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Text(title),
          SizedBox(width: 5),
          LabelText(text: subTitle),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profesorProvider = Provider.of<ProfesoresProvider>(context, listen: false);
    final asignaturaProvider = Provider.of<AsignaturasProvider>(context, listen: false);
    final asignarCPProvider = Provider.of<AsignarCPProvider>(context);
    // profesorProvider.getProfesores();
    // print(profesorProvider.profesores.length);
    return Column(
      children: [
        Container(
          height: 30,
          // width: double.infinity,
          color: Colors.blue.withOpacity(0.05),
          child: Align(alignment: Alignment.centerLeft),
        ),
        Divider(),
        SizedBox(height: 10),
        //selecion de profesor y curso
        Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              // width: 400,
              child: DropdownSearch<Profesore>(
                // items: [...profesorProvider.profesores],

                maxHeight: 300,
                onFind: (String? filter) async {
                  await profesorProvider.getProfesores();
                  return profesorProvider.profesores;
                  // return await profesorProvider.getData(termino: filter!);
                  // return profesorProvider.getData(termino: filter!);
                },
                // onFind: (String? filter) => getData(filter),
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Selecione un Profesor(a)",
                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                  border: OutlineInputBorder(),
                ),
                onChanged: (data) {
                  asignarCPProvider.profesor = data;
                },
                showSearchBox: true,
                showClearButton: true,
                showSelectedItems: true,
                compareFn: (i, s) => i?.isEqual(s!) ?? false,

                // dropdownBuilder: _customDropDownExample,
                popupItemBuilder: _customPopupItemBuilderExample2,
              ),
            ),
            SizedBox(height: 19),
            // DropdownSearch ASIGNATURA
            Container(
              // width: 510,
              child: DropdownSearch<Asignatura>(
                // items: [UserModel(name: "Offline name1", id: "999"), UserModel(name: "Offline name2", id: "0101")],

                maxHeight: 300,
                onFind: (String? filter) async {
                  await asignaturaProvider.getAsignaturas();
                  return asignaturaProvider.asignaturas;
                },
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Selecione Curso",
                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                  border: OutlineInputBorder(),
                ),
                onChanged: (data) {
                  asignarCPProvider.asignatura = data;
                },
                showSearchBox: true,
                showClearButton: true,
                showSelectedItems: true,
                compareFn: (i, s) => i?.isEqual(s!) ?? false,
                // dropdownBuilder: _customDropDownExample2,
                popupItemBuilder: _customPopupItemBuilderExample,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Divider(),
        if (!asignarCPProvider.isData) SizedBox(height: 50),
        if (asignarCPProvider.isData) _InputBoxGrup(asignarCPProvider: asignarCPProvider),
        SizedBox(height: 25),
        //BTN
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 120),
          child: ElevatedButton(
            onPressed: asignarCPProvider.isData
                ? () async {
                    final saved = await asignarCPProvider.newAsinacion();
                    // final saved = await userFormProvider.updateUser();
                    if (saved) {
                      NotificationsService.showSnackBarOk('Asignacion realizada');
                      // actualizar usuario
                      // Provider.of<UsersProvider>(context, listen: false).refreshUser(userFormProvider.user!);
                    } else {
                      NotificationsService.showSnackBarError('No esposible, EL profesor ya tiene asignado este curso');
                    }
                  }
                : null,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.indigo[400]),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.save_outlined, size: 20),
                Text('Guardar'),
              ],
            ),
          ),
        ),

        ///Menu Mode with no searchBox
        ///Menu Mode with overriden icon and dropdown buttons
      ],
    );
  }

  Widget _customDropDownExample2(BuildContext context, Asignatura? item) {
    if (item == null) {
      return Container();
    }
    // final grupAs

    return Container(
      child: (item.grupTeoriaAsig == null)
          ? ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: CircleAvatar(),
              title: Text("No item selected"),
            )
          : ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: CircleAvatar(
                  // radius: 4,
                  // this does not work - throws 404 error
                  // backgroundImage: NetworkImage(item.avatar ?? ''),
                  ),
              title: Text(item.nombre),
              subtitle: Text(
                item.codigo.toString(),
              ),
            ),
    );
  }

  Widget _customPopupItemBuilderExample2(BuildContext context, Profesore? item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.nombre ?? ''),
        subtitle: Text(item?.horasAsi?.toString() ?? ''),
        leading: CircleAvatar(
            // this does not work - throws 404 error
            // backgroundImage: NetworkImage(item.avatar ?? ''),
            ),
      ),
    );
  }

  Widget _customPopupItemBuilderExample(BuildContext context, Asignatura? item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.nombre ?? ''),
        subtitle: Text(item?.codigo ?? ''),
        leading: CircleAvatar(
            // this does not work - throws 404 error
            // backgroundImage: NetworkImage(item.avatar ?? ''),
            ),
      ),
    );
  }
}

class _InputBoxGrup extends StatelessWidget {
  const _InputBoxGrup({
    Key? key,
    required this.asignarCPProvider,
  }) : super(key: key);

  final AsignarCPProvider asignarCPProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            // constraints: BoxConstraints(maxWidth: 130),
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              // initialValue: '0',
              onChanged: (value) {
                if (value.isNotEmpty) {
                  asignarCPProvider.grupoTeoria = int.parse(value);
                } else {
                  asignarCPProvider.grupoTeoria = 0;
                }
              },

              decoration: CustomInput.authInputDecoration(
                hint: asignarCPProvider.asignatura.grupTeoria.toString(),
                label: 'Grupos Teorias',
                icon: Icons.new_releases_outlined,
                claro: true,
              ),
              style: TextStyle(color: Colors.black87),
            ),
          ),
          if (asignarCPProvider.asignatura.grupPractica! > 0) SizedBox(width: 20),
          if (asignarCPProvider.asignatura.grupPractica! > 0)
            Container(
              width: 150,
              // constraints: BoxConstraints(maxWidth: 130),
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                // initialValue: '0',
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    asignarCPProvider.grupoPractica = int.parse(value);
                  } else {
                    asignarCPProvider.grupoPractica = 0;
                  }
                },
                decoration: CustomInput.authInputDecoration(
                  hint: asignarCPProvider.asignatura.grupPractica.toString(),
                  label: 'Grupos Práticas',
                  icon: Icons.new_releases_outlined,
                  claro: true,
                ),
                style: TextStyle(color: Colors.black87),
              ),
            ),
        ],
      ),
    );
  }
}
