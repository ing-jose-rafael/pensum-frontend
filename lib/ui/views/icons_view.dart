import 'package:admin_dashboard/providers/profesores_provider.dart';
import 'package:admin_dashboard/providers/providers.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard/ui/cards/white_card.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';
import 'package:provider/provider.dart';

class IconsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profeProvider = Provider.of<ProfesoresProvider>(context, listen: false);
    profeProvider.getProfesores();
    // final cursoProvider = Provider.of<AsignaturasProvider>(context);
    final data = profeProvider.getDocentTipoContrato();
    print(data);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('Icons View', style: CustomLabels.h1),
          SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.horizontal, // crea los elementos hoorizontal
            children: [
              WhitrCard(
                title: 'ac_unit_outlined',
                child: _InfoProfesor(),
                width: 170,
              ),
              WhitrCard(
                title: 'access_alarms_outlined',
                child: Center(child: Icon(Icons.access_alarms_outlined)),
                width: 170,
              ),
              WhitrCard(
                title: 'access_time_outlined',
                child: Center(child: Icon(Icons.access_time_outlined)),
                width: 170,
              ),
              WhitrCard(
                title: 'outlined_flag_outlined',
                child: Center(child: Icon(Icons.outlined_flag_outlined)),
                width: 170,
              ),
              WhitrCard(
                title: 'report_gmailerrorred',
                child: Center(child: Icon(Icons.report_gmailerrorred_outlined)),
                width: 170,
              ),
              WhitrCard(
                title: 'play_for_work_outlined',
                child: Center(child: Icon(Icons.play_for_work_outlined)),
                width: 170,
              ),
              WhitrCard(
                title: 'music_note_outlined',
                child: Center(child: Icon(Icons.music_note_outlined)),
                width: 170,
              ),
              WhitrCard(
                title: 'laptop_mac_outlined',
                child: Center(child: Icon(Icons.laptop_mac_outlined)),
                width: 170,
              ),
              WhitrCard(
                title: 'accessibility',
                child: Center(child: Icon(Icons.accessibility)),
                width: 170,
              ),
              WhitrCard(
                title: 'portable_wifi',
                child: Center(child: Icon(Icons.portable_wifi_off_outlined)),
                width: 170,
              ),
              WhitrCard(
                title: 'gps_fixed_outlined',
                child: Center(child: Icon(Icons.gps_fixed_outlined)),
                width: 170,
              ),
            ],
          )
          // WhitrCard(
          //   title: 'Sale Statistics',
          //   child: Text('data'),
          // ),
        ],
      ),
    );
  }
}

class _InfoProfesor extends StatelessWidget {
  const _InfoProfesor({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Icon(Icons.ac_unit_outlined),
      ],
    ));
  }
}
