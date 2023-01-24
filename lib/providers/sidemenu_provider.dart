import 'package:flutter/material.dart';

class SideMenuProvider extends ChangeNotifier {
  static late AnimationController menuController;
  static bool isMenuOpen = false; // indica cuando el menu esta abierto o cerrado

  String _currentPage = '';

  String get currentPage => this._currentPage;

  void setCurrentPage(String routeName) {
    _currentPage = routeName;
    /** Separando los hilos de tiempo para que primero se construya la pagina
     * retrazamos un poco la notificacion
    */
    Future.delayed(Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }

  // animaciones de movimiento
  // empieza en menos -200 por que ese es el ancho del menu
  static Animation<double> movement = Tween<double>(begin: -200, end: 0).animate(CurvedAnimation(
    parent: menuController,
    curve: Curves.easeInOut,
  ));
  // controlando la opacidad
  static Animation<double> opacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
    parent: menuController,
    curve: Curves.easeInOut,
  ));

  static void openMenu() {
    isMenuOpen = true;
    // diaparando la animacion
    menuController.forward();
  }

  // cerrar el menu
  static void closeMenu() {
    isMenuOpen = false;
    // diaparando la animacion
    menuController.reverse();
  }

  // si esta abierto lo cierra y si esta cerrado el menu lo abre
  static void toggleMenu() {
    // diaparando la animacion
    (isMenuOpen) ? menuController.reverse() : menuController.forward();
    isMenuOpen = !isMenuOpen;
  }
}
