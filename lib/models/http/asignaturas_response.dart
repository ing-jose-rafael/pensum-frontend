// To parse this JSON data, do
//
//     final asignaturaResponse = asignaturaResponseFromMap(jsonString);

import 'package:admin_dashboard/models/asignatura.dart';

import 'dart:convert';

class AsignaturaResponse {
  AsignaturaResponse({
    required this.total,
    required this.asignaturas,
  });

  int total;
  List<Asignatura> asignaturas;

  factory AsignaturaResponse.fromJson(String str) => AsignaturaResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AsignaturaResponse.fromMap(Map<String, dynamic> json) => AsignaturaResponse(
        total: json["total"],
        asignaturas: List<Asignatura>.from(json["asignaturas"].map((x) => Asignatura.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "total": total,
        "asignaturas": List<dynamic>.from(asignaturas.map((x) => x.toMap())),
      };
}
