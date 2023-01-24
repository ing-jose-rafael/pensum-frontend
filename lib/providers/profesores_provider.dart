import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_dashboard/api/cafe_api.dart';

import 'package:admin_dashboard/models/profesor.dart';
import 'package:admin_dashboard/models/http/profesores_response.dart';

class ProfesoresProvider extends ChangeNotifier {
  List<Profesore> profesores = [];

  getProfesores() async {
    // peticion al api
    final resp = await CurriculApi.httpGet('/profesores');
    // print(resp);
    //TODO: Mapear respuesta
    final profesoresRes = ProfesorResponse.fromMap(resp);

    this.profesores = [...profesoresRes.profesores..sort()];

    // print(asignaturas);
    notifyListeners();
  }

  // getProfesoresSort() => this.profesores.sort();
  Future newProfesor(
      {required String cedula,
      required String nombre,
      required String contratacion,
      String? cargo = '',
      int? tope = 0,
      String? observaciones = ''}) async {
    // payload
    final data = {
      'nombre': nombre,
      'cedula': cedula,
      'contratacion': contratacion,
      'cargo': cargo,
      'tope': tope,
      'horasAsi': 0,
      'cursos': [],
    };
    // print(data);
    try {
      final json = await CurriculApi.post('/profesores', data);

      final newProfesor = Profesore.fromMap(json["profesor"]);

      // print('=======>   $newAsignatura');
      this.profesores.add(newProfesor);
      notifyListeners();
    } catch (e) {
      print(e);
      throw 'Error al crear Profesor';
    }
  }

  Future updateProfesor(
      {required String id,
      String? cedula,
      String? nombre,
      String? contratacion,
      String? cargo,
      int? tope,
      int? horasAsi,
      List<Curso>? cursos,
      String? observaciones}) async {
    // payload

    // final profesor = new Profesore(
    //   nombre: nombre,
    //   cedula: cedula,
    //   contratacion: contratacion,
    //   cargo: cargo,
    //   tope: tope,
    //   cursos: cursos,
    //   horasAsi: horasAsi,
    //   uid: id,
    //   observaciones: observaciones,
    // );

    final Profesore profesorDB = this.profesores.firstWhere((element) => element.uid == id);

    profesorDB.nombre = nombre ?? profesorDB.nombre;
    profesorDB.cedula = cedula ?? profesorDB.cedula;
    profesorDB.contratacion = contratacion ?? profesorDB.contratacion;
    profesorDB.cargo = cargo ?? profesorDB.cargo;
    profesorDB.tope = tope ?? profesorDB.tope;
    profesorDB.horasAsi = horasAsi ?? profesorDB.horasAsi;
    profesorDB.cursos = cursos ?? profesorDB.cursos;
    profesorDB.observaciones = observaciones ?? profesorDB.observaciones;

    // print(profesorDB.cursos!.length);
    try {
      final resp = await CurriculApi.put('/profesores/$id', profesorDB.toMap());
      // print(resp);
      this.profesores = this.profesores.map((prof) {
        if (prof.uid != id) return prof;
        prof = profesorDB;

        return prof;
      }).toList();
      notifyListeners();
    } catch (e) {
      print(e);
      throw 'Error al actualizar Profesor';
    }
  }

  Future deleteProfesor(String id) async {
    try {
      await CurriculApi.delete('/profesores/$id');
      this.profesores.removeWhere((element) => element.uid == id);
      notifyListeners();
    } catch (e) {
      // print(e);
      print('Error al eliminar el Profesor');
    }
  }

  Future<List<Profesore>> getData({String termino = '4'}) async {
    List<Profesore> profesoresDB = [];
    print(termino);
    try {
      // peticion al api
      // final resp = await CurriculApi.httpGet('/profesores');
      final resp = await CurriculApi.httpGet('/buscar/profesores/$termino');
      // print(resp);
      final profesoresRes = ProfesorResponse.fromMap(resp);
      profesoresDB = [...profesoresRes.profesores];
    } catch (e) {
      print(e);
      print('Error al buscar Profesor');
    }
    return profesoresDB;
  }

  List<List<Object>> getDocentTipoContrato() {
    int h1 = 0, h2 = 0, h3 = 0;
    this.profesores.forEach((e) {
      switch (e.ordeByContr) {
        case 1:
          h1 += e.horasAsi!;
          break;
        case 2:
          h2 += e.horasAsi!;
          break;
        case 3:
          h3 += e.horasAsi!;
          break;
      }
    });
    return [
      ['Planta', h1],
      ['TCO', h2],
      ['Catedra', h3]
    ];
  }
}
