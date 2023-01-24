import 'dart:typed_data';

import 'package:admin_dashboard/api/cafe_api.dart';
import 'package:admin_dashboard/models/usuario_model.dart';
import 'package:flutter/material.dart';

class UserFormProvider extends ChangeNotifier {
  // necesito mantener la información del usuario
  Usuario? user; // usuario opcional
  late GlobalKey<FormState> formKey; // para manejar las validaciones del formulario

  /**
   * Crear una copia recibiendo los nuevos valores y notificando
   */
  copyUserWith({
    String? rol,
    bool? estado,
    bool? google,
    String? nombre,
    String? correo,
    String? uid,
    String? img,
  }) {
    user = new Usuario(
      rol: rol ?? this.user!.rol,
      estado: estado ?? this.user!.estado,
      google: google ?? this.user!.google,
      nombre: nombre ?? this.user!.nombre,
      correo: correo ?? this.user!.correo,
      uid: uid ?? this.user!.uid,
    );
    notifyListeners();
  }

  //pensar como actualizar usuario y notificar
  Future updateUser() async {
    if (!this._validForm()) return false;
    // actualizando el usuario en backend se manda como lo pide el backend
    final data = {
      'nombre': user!.nombre,
      'correo': user!.correo,
    };
    try {
      final resp = await CurriculApi.put('/usuario/${user!.uid}', data);
      return true;
    } catch (e) {
      print('error en updateUser :$e');
      return false;
    }
  }

  /// funtion boleana retorna si el formulario es válido
  bool _validForm() {
    return formKey.currentState!.validate();
  }

  // como la respuesta a la api nos retorna un usuario
  Future<Usuario> uploadImageUser(String path, Uint8List bytes) async {
    try {
      final resp = await CurriculApi.uploadFile(path, bytes);
      user = Usuario.fromMap(resp); // como en la respuesta llega un mapa
      // notifico que el usuario tiene una nueva propiedad la imagen
      notifyListeners();
      return user!;
    } catch (e) {
      print(e);
      throw 'Error en user from provider';
    }
  }
}
