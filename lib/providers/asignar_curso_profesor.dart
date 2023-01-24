import 'package:admin_dashboard/api/cafe_api.dart';
import 'package:admin_dashboard/models/asignatura.dart';
import 'package:admin_dashboard/models/http/response_asignacion.dart';
import 'package:admin_dashboard/models/profesor.dart';
import 'package:flutter/material.dart';

class AsignarCPProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Profesore? _profesor;
  Asignatura? _asignatura;
  int grupoTeoria = 0;
  int grupoPractica = 0;
  bool isData = false;

  set profesor(Profesore? profesor) {
    this._profesor = profesor;

    this.setData(true);
  }

  set asignatura(Asignatura? value) {
    this._asignatura = value;

    this.setData(true);
  }

  setData(bool value) {
    if (_asignatura == null || _profesor == null) {
      this.isData = false;
    } else {
      this.isData = value;
    }
    notifyListeners();
  }

  Profesore get profesor => this._profesor!;
  Asignatura get asignatura => this._asignatura!;

  get existAsig => this._asignatura != null ? true : false;
  get existProf => this._profesor != null ? true : false;

  bool validForm() => formKey.currentState!.validate();

  Future newAsinacion() async {
    // if (!this.validForm()) return false;
    if (grupoTeoria == 0 && grupoPractica == 0) return false;
    final data = {
      "idProfe": _profesor!.uid,
      "idCurso": _asignatura!.uid,
      "grupoTeoria": grupoTeoria,
      "grupoPractica": grupoPractica,
    };
    try {
      final json = await CurriculApi.post('/asignar', data);
      // print(json['msg']);
      if (json['msg'] != 'ok') {
        return false;
      }
      final newAsignacion = ResponseAsignacio.fromMap(json);
      // print(newAsignacion);
      grupoTeoria = 0;
      grupoPractica = 0;
      return true;
    } catch (e) {
      print(e);
      throw 'Error al crear $e';
    }
  }

  copyProfesorWith({
    String? nombre,
    String? cedula,
    String? contratacion,
    String? cargo,
    int? tope,
    int? horasAsi,
    List<Curso>? cursos,
    String? uid,
  }) {
    this._profesor = new Profesore(
      nombre: nombre ?? this._profesor!.nombre,
      cedula: cedula ?? this._profesor!.cedula,
      contratacion: contratacion ?? this._profesor!.contratacion,
      cargo: cargo ?? this._profesor!.cargo,
      tope: tope ?? this._profesor!.tope,
      horasAsi: horasAsi ?? this._profesor!.horasAsi,
      cursos: cursos ?? this._profesor!.cursos,
      uid: uid ?? this._profesor!.uid,
    );
    notifyListeners();
  }

  copyProfesorDBWith(Profesore pro) {
    this._profesor = new Profesore(
      nombre: pro.nombre,
      cedula: pro.cedula,
      contratacion: pro.contratacion,
      cargo: pro.cargo,
      tope: pro.tope,
      horasAsi: pro.horasAsi,
      cursos: pro.cursos,
      observaciones: pro.observaciones,
      uid: pro.uid,
    );
    notifyListeners();
  }

  Future editarAsignacion(String idP, String idC, int grupoTeor, int grupoPracti) async {
    if (grupoTeor == 0 && grupoPracti == 0) return false;
    final data = {
      "idProfe": idP,
      "idCurso": idC,
      "grupoTeoria": grupoTeor,
      "grupoPractica": grupoPracti,
    };
    try {
      final json = await CurriculApi.put('/asignar/$idP/$idC', data);
      // print(json);
      final newAsignacion = ResponseAsignacio.fromMap(json);
      // print(newAsignacion.curso);
      if (newAsignacion.profesor != null) {
        copyProfesorDBWith(newAsignacion.profesor!);
      }
      // this.copyProfesorWith(horasAsi:)
      return true;
    } catch (e) {
      print(e);
      throw 'Error al editar';
    }
  }

  Future eliminarAsignacion(String idP, String idc) async {
    try {
      final json = await CurriculApi.delete('/asignar/$idP/$idc');
      // print(json["profesor"]);
      final newProfesor = Profesore.fromMap(json["profesor"]);

      copyProfesorDBWith(newProfesor);

      // this._profesor!.cursos!.removeWhere((curso) => curso.asignatura.id == idc);
      // print(cursos);
      notifyListeners();
      // print(json);

      // final newAsignacion = ResponseAsignacio.fromMap(json);
      return true;
    } catch (e) {
      print(e);
      throw 'Error al eliminar';
    }
  }
}
