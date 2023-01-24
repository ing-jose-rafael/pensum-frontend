import 'package:admin_dashboard/api/cafe_api.dart';
import 'package:admin_dashboard/models/http/auth_response.dart';
import 'package:admin_dashboard/models/usuario_model.dart';
import 'package:admin_dashboard/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/services/local_storage.dart';
import 'package:admin_dashboard/services/navigation_services.dart';

// manteniendo el estado de la autentificacion
enum AuthStatus {
  cheking,
  authenticated,
  notAuthenticated,
}

/// Para manejar la informacion que usuario esta conectado,
/// permite en todo momento saber si el usuario esta autenticado
class AuthProvider extends ChangeNotifier {
  String? _token;
  AuthStatus authStatus = AuthStatus.cheking; // revisando el estado
  Usuario? user;

  AuthProvider() {
    this.isAuthenticated();
  }

  /// Necesita el email y el passwoard
  login(String email, String pass) {
    //péticion HTTPS

    final data = {
      'correo': email,
      'password': pass,
    };
    // print(data);
    CurriculApi.post('/auth/login', data).then((json) {
      // print(json);
      final authResponse = AuthResponse.fromMap(json);
      this.user = authResponse.usuario;
      this._token = authResponse.token;
      //Guardando en localStorage
      LocalStorage.prefs.setString('token', this._token!);
      authStatus = AuthStatus.authenticated; // cambiamos el estado
      NavigationService.replaceTo(Flurorouter.asignarRoute);
      // NavigationService.replaceTo(Flurorouter.dashboardRoute);
      CurriculApi.configuraDio(); // acualizando el token
      notifyListeners();
      // cambiando de Layout
      NavigationService.replaceTo(Flurorouter.asignarRoute); // cambiando el Url
      // NavigationService.replaceTo(Flurorouter.dashboardRoute); // cambiando el Url
    }).catchError((e) {
      // Mostar notificacion de error
      print(e);
      NotificationsService.showSnackBarError('Usuario / Password no válidos');
    });

    // print('Almacenar JWT: $_token');
    //Navegar al dashboard
    // this.isAuthenticated();
  }

  /// Necesita el email y el passwoard
  register(String email, String pass, String name) {
    // mapa con los dts que se tienen que enviar al backend
    final data = {
      'nombre': name,
      'correo': email,
      'password': pass,
    };

    CurriculApi.post('/usuarios', data).then((json) {
      // print(json);
      final authResponse = AuthResponse.fromMap(json);
      this.user = authResponse.usuario;
      this._token = authResponse.token;
      //Guardando en localStorage
      LocalStorage.prefs.setString('token', this._token!);
      authStatus = AuthStatus.authenticated; // cambiamos el estado
      // cambiando de Layout
      //Navegar al dashboard
      NavigationService.replaceTo(Flurorouter.dashboardRoute); // cambiando el Url
      CurriculApi.configuraDio(); // acualizando el token
      notifyListeners();
    }).catchError((e) {
      // print('Error en $e');
      // Mostar notificacion de error
      NotificationsService.showSnackBarError('Correo no válidas');
    });

    // this._token = 'sakjdkla.hjsdhkjahskd.wyuwhsbzcm';

    // // print('Almacenar JWT: $_token');
    // this.isAuthenticated();
  }

  Future<bool> isAuthenticated() async {
    final token = LocalStorage.prefs.getString('token'); // obtener el token
    if (token == null) {
      authStatus = AuthStatus.notAuthenticated; // cambiamos el estado
      notifyListeners(); // notificamos a todos
      return false;
    }
    //Ir al backend y validar el JWT
    // //simulacion
    // await Future.delayed(Duration(milliseconds: 1000));
    try {
      final resp = await CurriculApi.httpGet('/auth');
      final authResponse = AuthResponse.fromMap(resp);
      this.user = authResponse.usuario;
      this._token = authResponse.token;
      LocalStorage.prefs.setString('token', this._token!);
      authStatus = AuthStatus.authenticated; // cambiamos el estado
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      authStatus = AuthStatus.notAuthenticated; // cambiamos el estado
      notifyListeners();
      return false;
    }
  }

  logout() {
    LocalStorage.prefs.remove('token'); // remover el token
    authStatus = AuthStatus.notAuthenticated; // cambiamos el estado
    notifyListeners();
  }
}
