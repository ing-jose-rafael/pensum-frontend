import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

import 'package:admin_dashboard/providers/providers.dart';

import 'package:admin_dashboard/router/router.dart';

import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';
import 'package:admin_dashboard/ui/buttons/link_text.dart';

import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return ChangeNotifierProvider(
      // create: (_) => LoginFormProvider(authProvider), // op 1
      create: (_) => LoginFormProvider(),
      child: Builder(
        builder: (BuildContext context) {
          final loginProvider = Provider.of<LoginFormProvider>(context, listen: false);
          return Container(
            // color: Colors.black,
            margin: const EdgeInsets.only(top: 100),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              /** ConstrainedBox limitando el tamaño del formulario maximo 370, menos de eso se adaptará  */
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 370),
                /** formulario manejado con un gestor de estado independiente, por eso usuamos key: loginProvider.formKey,  */
                child: Form(
                  autovalidateMode: AutovalidateMode.always, // para ir validando en tiempo real
                  key: loginProvider.formKey,
                  child: Column(
                    children: [
                      /** Email */
                      TextFormField(
                        onFieldSubmitted: (_) =>
                            onFormSubmit(loginProvider, authProvider), // para que funcione con el enter
                        onChanged: (value) => loginProvider.email = value,
                        validator: (email) {
                          if (!EmailValidator.validate(email ?? '')) return 'El Email no es válido';
                          return null; // campo válido
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: CustomInput.authInputDecoration(
                          hint: 'Ingrese su correo',
                          label: 'Email',
                          icon: Icons.email_outlined,
                        ),
                      ),
                      SizedBox(height: 20),
                      /** Contraseña */
                      TextFormField(
                        onFieldSubmitted: (_) => onFormSubmit(loginProvider, authProvider),
                        onChanged: (value) => loginProvider.password = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Ingrese contraseña';
                          if (value.length < 5) return 'La contraseña debe ser mayor a 6 caracteres';
                          return null; // valido
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
                        text: 'Ingresar',
                        // onPressed: () {
                        //   final isValid = loginProvider.validateForm();
                        //   if (isValid) {
                        //     authProvider.login(loginProvider.email, loginProvider.password);
                        //   }
                        // },
                        onPressed: () => onFormSubmit(loginProvider, authProvider),
                      ),
                      SizedBox(height: 20),
                      // link
                      LinkText(
                        text: 'Nueva cuenta',
                        onPressed: () {
                          // Hacer que mavegue a otra vista
                          Navigator.pushReplacementNamed(context, Flurorouter.registerRoute);
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

  void onFormSubmit(LoginFormProvider loginProvider, AuthProvider authProvider) {
    final isValid = loginProvider.validateForm();
    if (isValid) {
      // print(loginProvider.email + '---' + loginProvider.password);
      authProvider.login(loginProvider.email, loginProvider.password);
    }
  }
}
