// To parse this JSON data, do
//
//     final responseAsignacio = responseAsignacioFromMap(jsonString);

import 'package:admin_dashboard/models/asignatura.dart';
import 'package:admin_dashboard/models/profesor.dart';

import 'dart:convert';

class ResponseAsignacio {
  ResponseAsignacio({
    required this.msg,
    this.profesor,
    this.curso,
  });

  String msg;
  Profesore? profesor;
  Asignatura? curso;

  factory ResponseAsignacio.fromJson(String str) => ResponseAsignacio.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResponseAsignacio.fromMap(Map<String, dynamic> json) => ResponseAsignacio(
        msg: json["msg"],
        profesor: Profesore.fromMap(json["profesor"]),
        curso: Asignatura.fromMap(json["curso"]),
      );

  Map<String, dynamic> toMap() => {
        "msg": msg,
        "profesor": profesor!.toMap(),
        "curso": curso!.toMap(),
      };
}
