import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/services/navigation_services.dart';

import 'package:admin_dashboard/ui/shared/widgets/menu_item.dart';
import 'package:admin_dashboard/ui/shared/widgets/text_separator.dart';
import 'package:admin_dashboard/ui/shared/widgets/logo.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sideMenuProvider = Provider.of<SideMenuProvider>(context);
    return Container(
      width: 200,
      height: double.infinity,
      decoration: buildBoxDecoration(),
      child: ListView(
        // para tener scroll
        physics: ClampingScrollPhysics(),
        children: [
          Logo(),
          SizedBox(height: 50),
          TextSeparator(text: 'main'),
          MenuItem(
            text: 'Asignar',
            // icon: Icons.dashboard_outlined,
            icon: Icons.post_add_outlined,
            isActive: sideMenuProvider.currentPage == Flurorouter.asignarRoute,
            onPressed: () => navigatorTo(Flurorouter.asignarRoute),
          ),
          MenuItem(
            text: 'Consulta',
            icon: Icons.person_search,
            // icon: Icons.dashboard_outlined,
            isActive: sideMenuProvider.currentPage == Flurorouter.profesorCursoRoute,
            onPressed: () => navigatorTo(Flurorouter.profesorCursoRoute),
          ),
          // MenuItem(
          //   text: 'Dashboard',
          //   icon: Icons.compass_calibration_outlined,
          //   isActive: sideMenuProvider.currentPage == Flurorouter.dashboardRoute,
          //   onPressed: () => navigatorTo(Flurorouter.dashboardRoute),
          // ),
          MenuItem(
            text: 'Cursos',
            // icon: Icons.shopping_cart_outlined,
            icon: Icons.list_alt_outlined,
            isActive: sideMenuProvider.currentPage == Flurorouter.asignaturaRoute,
            onPressed: () => navigatorTo(Flurorouter.asignaturaRoute),
          ),
          MenuItem(
            text: 'Profesores',
            icon: Icons.people_alt_outlined,
            isActive: sideMenuProvider.currentPage == Flurorouter.profesorRoute,
            onPressed: () => navigatorTo(Flurorouter.profesorRoute),
          ),
          MenuItem(
            text: 'Info Cursos',
            icon: Icons.layers_outlined,
            isActive: sideMenuProvider.currentPage == Flurorouter.cursoRoute,
            onPressed: () => navigatorTo(Flurorouter.cursoRoute),
          ),
          MenuItem(
            text: 'Estadistica',
            icon: Icons.pie_chart,
            isActive: sideMenuProvider.currentPage == Flurorouter.iconsRoute,
            onPressed: () => navigatorTo(Flurorouter.iconsRoute),
          ),

          // MenuItem(
          //   text: 'Users',
          //   icon: Icons.people_alt_outlined,
          //   isActive: sideMenuProvider.currentPage == Flurorouter.usersRoute,
          //   onPressed: () => navigatorTo(Flurorouter.usersRoute),
          // ),
          /**
          SizedBox(height: 30),
          TextSeparator(text: 'UI Elements'),
          MenuItem(
            text: 'Icons',
            icon: Icons.list_alt_outlined,
            isActive: sideMenuProvider.currentPage == Flurorouter.iconsRoute,
            onPressed: () => navigatorTo(Flurorouter.iconsRoute),
          ),
          MenuItem(text: 'Marketing', icon: Icons.mark_email_read_outlined, onPressed: () {}),
          MenuItem(text: 'Campaing', icon: Icons.note_add_outlined, onPressed: () {}),
          MenuItem(
            text: 'Blank',
            icon: Icons.post_add_outlined,
            isActive: sideMenuProvider.currentPage == Flurorouter.blankRoute,
            onPressed: () => navigatorTo(Flurorouter.blankRoute),
          ),
           */
          SizedBox(height: 50),
          TextSeparator(text: 'UI Elements'),
          MenuItem(
              text: 'Logout',
              icon: Icons.exit_to_app_outlined,
              onPressed: () {
                SideMenuProvider.isMenuOpen = false;
                // sideMenuProvider.currentPage == Flurorouter.blankRoute,
                // navigatorTo(Flurorouter.blankRoute);
                SideMenuProvider.menuController.reset();
                Provider.of<AuthProvider>(context, listen: false).logout();
              }),
        ],
      ),
    );
  }

  void navigatorTo(String routeName) {
    if (SideMenuProvider.isMenuOpen) SideMenuProvider.closeMenu();
    NavigationService.replaceTo(routeName);
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF092044),
          Color(0xFF092042),
        ],
      ),
      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      // color: Colors.deepPurple,
    );
  }
}
