import 'package:admin_dashboard/api/cafe_api.dart';
import 'package:admin_dashboard/models/http/users_response.dart';
import 'package:admin_dashboard/models/usuario_model.dart';
import 'package:flutter/material.dart';

class UsersProvider extends ChangeNotifier {
  List<Usuario> users = [];
  bool isLoading = true;
  bool ascending = true;
  int? sortColumnIdex;

  /** en el momento que alquien requiera mi user provider quiero que se haga la petición  getUsers */
  UsersProvider() {
    this.getUsers();
  }
  getUsers() async {
    //petición ala Api
    final resp = await CurriculApi.httpGet('/usuario?limite=100'); // retorna un mapa
    final usersResponse = UsersResponse.fromMap(resp);
    this.users = [...usersResponse.usuarios];
    isLoading = false;
    // print(usersResponse.total);
    // print(usersResponse.usuarios.length);
    notifyListeners();
  }

  Future<Usuario?> getUsersById(String uid) async {
    //petición ala Api
    try {
      final resp = await CurriculApi.httpGet('/usuario/$uid'); // retorna un mapa
      final user = Usuario.fromMap(resp);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// funsion generica para ordear, pide el campo por cual ordenar
  void sort<T>(Comparable<T> Function(Usuario user) getField) {
    users.sort((user1, user2) {
      final user1Value = getField(user1); // retorna el campo que quiero obtener
      final user2Value = getField(user2); // retorna el campo que quiero obtener
      // operacion de comparación
      return ascending ? Comparable.compare(user1Value, user2Value) : Comparable.compare(user2Value, user1Value);
    });
    ascending = !ascending;
    // notificamos por que se cambio  el arreglo
    notifyListeners();
  }

  void refreshUser(Usuario newUser) {
    this.users = this.users.map((user) {
      if (user.uid == newUser.uid) user = newUser;
      return user;
    }).toList();
    notifyListeners();
  }
}
