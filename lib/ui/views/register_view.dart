import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:email_validator/email_validator.dart';

import 'package:admin_dashboard/providers/providers.dart';

import 'package:admin_dashboard/router/router.dart';

import 'package:admin_dashboard/ui/buttons/link_text.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegitserFormProvider(),
      child: Builder(
        builder: (BuildContext context) {
          final registerProvider = Provider.of<RegitserFormProvider>(context, listen: false);
          return Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 370),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: registerProvider.formKey,
                  child: Column(
                    children: [
                      /** Nombre */
                      TextFormField(
                        onChanged: (value) => registerProvider.nombre = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'El nombre es obligatorio';
                          if (value.length < 3) return 'El nombre debe ser mayor de 3 caracteres';
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: CustomInput.authInputDecoration(
                          hint: 'Ingrese su nombre',
                          label: 'Nombre',
                          icon: Icons.supervised_user_circle_sharp,
                        ),
                      ),
                      SizedBox(height: 20),
                      /** Email */
                      TextFormField(
                        onChanged: (value) => registerProvider.correo = value,
                        validator: (value) {
                          if (!EmailValidator.validate(value ?? 'xx')) return 'Email no válido';
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: CustomInput.authInputDecoration(
                          hint: 'Ingrese su correo',
                          label: 'Email',
                          icon: Icons.email_outlined,
                        ),
                      ),
                      SizedBox(height: 20),
                      /** contraseña */
                      TextFormField(
                        onChanged: (value) => registerProvider.password = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'La contraseña es obligatorio';
                          if (value.length < 5) return 'El contraseña debe ser mayor de 6 caracteres';
                          return null;
                        },
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: CustomInput.authInputDecoration(
                          label: 'Contraseña',
                          hint: '***********',
                          icon: Icons.lock_outline_rounded,
                        ),
                      ),
                      SizedBox(height: 20),
                      // btn
                      CustomOutLinedButton(
                        text: 'Crear Cuenta',
                        onPressed: () {
                          final isValid = registerProvider.validateForm();
                          if (!isValid) return;
                          //TODO:
                          Provider.of<AuthProvider>(context, listen: false)
                              .register(registerProvider.correo, registerProvider.password, registerProvider.nombre);
                        },
                      ),
                      SizedBox(height: 20),
                      LinkText(
                        text: 'Ir a Login',
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, Flurorouter.loginRoute);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
