/** Cacaron para crear vistas*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:email_validator/email_validator.dart';

import 'package:admin_dashboard/models/usuario_model.dart';

import 'package:admin_dashboard/providers/providers.dart';

import 'package:admin_dashboard/services/navigation_services.dart';
import 'package:admin_dashboard/services/notification_services.dart';

import 'package:admin_dashboard/ui/cards/white_card.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';

class UserDetailsView extends StatefulWidget {
  final String uid;

  const UserDetailsView({Key? key, required this.uid}) : super(key: key);

  @override
  _UserDetailsViewState createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  Usuario? user;
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    final userFormProvider = Provider.of<UserFormProvider>(context, listen: false);
    userProvider.getUsersById(widget.uid).then((userDB) {
      if (userDB != null) {
        userFormProvider.user = userDB;
        userFormProvider.formKey = new GlobalKey<FormState>();

        setState(() {
          this.user = userDB;
        });
      } else {
        NavigationService.replaceTo('/dashboard/users');
      }
    });
  }

  @override
  void dispose() {
    this.user = null;
    Provider.of<UserFormProvider>(context, listen: false).user = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('User Detail View', style: CustomLabels.h1),
          SizedBox(height: 10),
          // si no tiene usuario
          if (user == null)
            WhitrCard(
              child: Container(
                alignment: Alignment.center,
                height: 300,
                child: CircularProgressIndicator(),
              ),
            ),
          if (user != null) _UserViewBody(),
        ],
      ),
    );
  }
}

class _UserViewBody extends StatelessWidget {
  const _UserViewBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Table(
      // columnWidths Ancho de la columna recibe un map, Map<int, TableColumnWidth> si no
      // se espesifican las demas toma el ancho restante
      columnWidths: {
        0: FixedColumnWidth(250),
      },
      children: [
        TableRow(children: [
          //TODO: avatar
          _AvatarContainer(),
          //TODO: Formulario
          _UserviewForm(),
        ])
      ],
    ));
  }
}

class _UserviewForm extends StatelessWidget {
  const _UserviewForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userFormProvider = Provider.of<UserFormProvider>(context);

    return WhitrCard(
      title: 'Información general',
      child: Form(
        key: userFormProvider.formKey, //key
        // siempre pendiente de la validaciones que agrego
        autovalidateMode: AutovalidateMode.always,
        /** el child será una columna por que tendrá widget uno debajo de otro */
        child: Column(
          children: [
            TextFormField(
              initialValue: userFormProvider.user!.nombre,
              onChanged: (value) {
                userFormProvider.copyUserWith(nombre: value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) return 'Ingrese nombre del usuario';

                if (value.length < 3) return 'El nombre debe ser mayor a 3 caracteres';
                return null; // valido
              },
              // onFieldSubmitted: (_) => onFormSubmit(userFormProvider),
              decoration: CustomInput.formInputDecoration(
                hint: 'Nombre del usuario',
                label: 'Nombre',
                icon: Icons.supervised_user_circle_outlined,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: userFormProvider.user!.correo,
              onChanged: (value) => userFormProvider.copyUserWith(correo: value),
              validator: (email) {
                if (!EmailValidator.validate(email ?? '')) return 'El Email no es válido';

                return null; // campo válido
              },
              decoration: CustomInput.formInputDecoration(
                hint: 'Correo del usuario',
                label: 'Correo',
                icon: Icons.mark_email_read_outlined,
              ),
            ),
            SizedBox(height: 20),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: ElevatedButton(
                onPressed: () async {
                  // //TODO: put Actualizar usuario
                  final saved = await userFormProvider.updateUser();
                  if (saved) {
                    NotificationsService.showSnackBarOk('Usuario actualizado');
                    // actualizar usuario
                    Provider.of<UsersProvider>(context, listen: false).refreshUser(userFormProvider.user!);
                  } else {
                    NotificationsService.showSnackBarError('No se pudo guardar');
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
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
          ],
        ),
      ),
    );
  }
}

class _AvatarContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userFormProvider = Provider.of<UserFormProvider>(context);
    final user = userFormProvider.user!;

    final image = (user.img == null)
        ? Image(image: AssetImage('assets/no-image.jpg'))
        : FadeInImage.assetNetwork(placeholder: 'assets/loader.gif', image: user.img!);

    return WhitrCard(
      width: 250,
      child: Container(
          width: double.infinity,
          // decoration: buildBoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Profile', style: CustomLabels.h2),
              SizedBox(height: 20),
              Container(
                width: 150,
                height: 160,
                child: Stack(
                  children: [
                    ClipOval(child: image),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: buildBoxDecoration(),
                        child: FloatingActionButton(
                          backgroundColor: Colors.indigo,
                          elevation: 0,
                          child: Icon(Icons.camera_alt_outlined, size: 20),
                          onPressed: () async {
                            //TODO: SELECIONAR LA IMAGEN
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              allowedExtensions: ['jpg', 'jpeg', 'png'],
                              allowMultiple: false,
                              type: FileType.custom,
                            );

                            if (result != null) {
                              PlatformFile file = result.files.first;

                              NotificationsService.showBusyIndicator(context);
                              final newUserresp =
                                  await userFormProvider.uploadImageUser('/uploads/usuarios/${user.uid}', file.bytes!);
                              // actualizar usuario
                              Provider.of<UsersProvider>(context, listen: false).refreshUser(newUserresp);
                              // cerrando NotificationsService.showBusyIndicator
                              Navigator.of(context).pop();

                              // print(file.name);
                              // print(file.bytes);
                              // print(file.size);
                              // print(file.extension);

                            } else {
                              print('No hay imagen');
                              // User canceled the picker
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                user.nombre,
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          )),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white, width: 5),
      );
}
