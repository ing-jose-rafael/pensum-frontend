import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:admin_dashboard/ui/shared/widgets/nav_bar_avatar.dart';
import 'package:admin_dashboard/ui/shared/widgets/notification_indicator.dart';
import 'package:flutter/material.dart';
import 'package:admin_dashboard/ui/shared/widgets/search_text.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 50,
      width: double.infinity,
      decoration: buildBoxDecoration(),
      child: Row(
        children: [
          /** Icon del menú todo esto se debe ocultar */
          if (size.width <= 700)
            IconButton(onPressed: () => SideMenuProvider.openMenu(), icon: Icon(Icons.menu_outlined)),
          SizedBox(width: 5),
          /** Search input con tamaño especifico no le permite crecer*/
          // if (size.width > 390)
          //   ConstrainedBox(
          //     constraints: BoxConstraints(maxWidth: 250),
          //     child: SearchText(),
          //   ),
          /**creando espacio */
          Spacer(),
          /** Campana de notificanes  */
          NotificationIndicator(),
          SizedBox(width: 10),
          NavBarAvatar(),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5,
        )
      ]);
}
