import 'package:flutter/material.dart';
import 'package:admin_dashboard/ui/layouts/auth/widgets/widgets_auth.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  const AuthLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Scrollbar(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            /** de manera condicional redibujamos el widget correspondiente */
            (size.width > 1000)
                ?
                // Desktop
                _DesktopBody(child)
                // Mobiel
                : _MobileBody(child: child),
            /** linksBar */
            LinksBar(),
          ],
        ),
      ),
    );
  }
}

class _MobileBody extends StatelessWidget {
  final Widget child;
  const _MobileBody({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          CustomTile(),
          /** Espacio para el child */
          Container(
            height: 420,
            width: double.infinity,
            child: child,
          ),
          Container(
            height: 400,
            width: double.infinity,
            child: CustomBackground(),
          ),
        ],
      ),
    );
  }
}

class _DesktopBody extends StatelessWidget {
  final Widget child;
  const _DesktopBody(this.child);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      /** dimensiones controladas para evitar que el contenido se pase y no tener que hacer scroll */
      width: size.width,
      height: size.height * 0.95, //
      child: Row(
        children: [
          // Twitter background
          Expanded(child: CustomBackground()),
          // View form tiene un tamaño especifico
          Container(
            width: 600.0,
            height: double.infinity,
            color: Colors.black,
            child: Column(
              children: [
                SizedBox(height: 20),
                CustomTile(),
                SizedBox(height: 50),
                /** Tomando el espacio retante para dibujar la vista */
                Expanded(child: child),
              ],
            ),
          )
        ],
      ),
    );
  }
}
