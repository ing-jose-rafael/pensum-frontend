import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:admin_dashboard/ui/shared/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:admin_dashboard/ui/shared/sidebar.dart';

class DashboardLayout extends StatefulWidget {
  final Widget child;

  const DashboardLayout({Key? key, required this.child}) : super(key: key);

  @override
  _DashboardLayoutState createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> with TickerProviderStateMixin {
  @override
  void initState() {
    SideMenuProvider.menuController = new AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
    SideMenuProvider.movement = Tween<double>(begin: -200, end: 0)
        .animate(CurvedAnimation(parent: SideMenuProvider.menuController, curve: Curves.easeInOut));

    SideMenuProvider.opacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: SideMenuProvider.menuController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    SideMenuProvider.menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffEDF1F2),
      body: Stack(
        children: [
          Row(
            children: [
              /** el menu tendara un tamaño estaico */
              // depende si es mayor 700
              if (size.width >= 700) SideBar(),
              // el espacio restante del row lo toma la columna
              Expanded(
                child: Column(
                  children: [
                    // NavBar
                    NavBar(),
                    //view
                    Expanded(
                      child: Container(
                        // padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                        child: widget.child,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          /** solo se muestra si es  menor de  700*/
          if (size.width < 700)
            AnimatedBuilder(
              animation: SideMenuProvider.menuController,
              builder: (BuildContext context, _) {
                return Stack(
                  children: [
                    // fondo translucido
                    if (SideMenuProvider.isMenuOpen)
                      Opacity(
                        opacity: SideMenuProvider.opacity.value,
                        child: GestureDetector(
                          onTap: () => SideMenuProvider.closeMenu(),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.black26,
                          ),
                        ),
                      ),
                    // para mover el menu de forma horizontal
                    Transform.translate(
                      offset: Offset(SideMenuProvider.movement.value, 0),
                      child: SideBar(),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
