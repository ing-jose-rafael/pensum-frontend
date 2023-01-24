import 'package:flutter/material.dart';

class RegitserFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String nombre = '', correo = '', password = '';

  // validateForm() {
  //   if (formKey.currentState!.validate()) {
  //     print('Form válido');
  //     print('$nombre == $correo == $password');
  //   } else {
  //     print('Form not válido');
  //   }
  // }
  bool validateForm() => formKey.currentState!.validate() ? true : false;
}
