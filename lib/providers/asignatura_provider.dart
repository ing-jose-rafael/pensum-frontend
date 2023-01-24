import 'package:flutter/material.dart';
import 'package:admin_dashboard/api/cafe_api.dart';
import 'package:admin_dashboard/models/asignatura.dart';
import 'package:admin_dashboard/models/http/asignaturas_response.dart';

class AsignaturasProvider extends ChangeNotifier {
  List<Asignatura> asignaturas = [];
  Map cursosEstado = {};

  getAsignaturas() async {
    // peticion al api
    final resp = await CurriculApi.httpGet('/asignaturas');
    final asignaturasRes = AsignaturaResponse.fromMap(resp);
    this.asignaturas = [...asignaturasRes.asignaturas];
    // print(asignaturas);
    notifyListeners();
  }

  Future newAsignatura(
      {required String cod,
      required String name,
      required int hTeorica,
      int? hPractica,
      required int grupTeoria,
      int? grupPractica}) async {
    // payload
    final data = {
      'codigo': cod,
      'nombre': name,
      'hTeorica': hTeorica,
      'hPractica': hPractica ?? 0,
      'grupTeoria': grupTeoria,
      'grupPractica': grupPractica ?? 0,
      'grupTeoriaAsig': 0,
      'grupPracticaAsig': 0,
      'profesores': []
    };
    // print(data);
    try {
      final json = await CurriculApi.post('/asignaturas', data);
      // print(json['asignatura']);
      final newAsignatura = Asignatura.fromMap(json["asignatura"]);
      // print('=======>   $newAsignatura');
      this.asignaturas.add(newAsignatura);
      notifyListeners();
    } catch (e) {
      print(e);
      throw 'Error al crear Asignatura';
    }
  }

  Future updateAsignatura(
      {required String id,
      required String cod,
      required String name,
      required int hTeorica,
      int? hPractica,
      required int grupTeoria,
      int? grupPractica,
      List<String>? profesores,
      int? grupTeoriaAsig,
      int? grupPracticaAsig}) async {
    final data = {
      'codigo': cod,
      'nombre': name,
      'hTeorica': hTeorica,
      'hPractica': hPractica,
      'grupTeoria': grupTeoria,
      'grupPractica': grupPractica,
      'profesores': profesores,
      'grupTeoriaAsig': grupTeoriaAsig,
      'grupPracticaAsig': grupPracticaAsig,
    };
    try {
      await CurriculApi.put('/asignaturas/$id', data);
      this.asignaturas = this.asignaturas.map((asig) {
        if (asig.uid != id) return asig;
        asig.nombre = name;
        asig.codigo = cod;
        asig.hTeorica = hTeorica;
        asig.hPractica = hPractica;
        asig.grupTeoria = grupTeoria;
        asig.grupPractica = grupPractica;
        asig.profesores = profesores;
        asig.grupTeoriaAsig = grupTeoriaAsig!;
        asig.grupPracticaAsig = grupPracticaAsig!;
        return asig;
      }).toList();
      notifyListeners();
    } catch (e) {
      // print(e);
      throw 'Error al actualizar Asignatura';
    }
  }

  Future deleteAsignatura(String id) async {
    try {
      await CurriculApi.delete('/asignaturas/$id');
      this.asignaturas.removeWhere((element) => element.uid == id);
      notifyListeners();
    } catch (e) {
      // print(e);
      print('Error al eliminar la Asignatura');
    }
  }

  List<Map<String, dynamic>> getCursosEstado() {
    return this.asignaturas.map((curso) {
      final grpsAsig = curso.grupPracticaAsig! + curso.grupTeoriaAsig!;
      final grps = curso.grupPractica! + curso.grupTeoria;

      var color = 0;
      // tiene todo asignado
      final result = grps - grpsAsig;

      if (result == 0) {
        color = 1;
      }
      if (result > 0) {
        if (result != grps) {
          color = 2;
        } else {
          color = 3;
        }
      }
      final data = {
        'codigo': curso.codigo,
        'curso': curso.nombre,
        'color': color,
      };
      // return {curso.codigo, curso.nombre, color};
      return data;
    }).toList();
  }
}
