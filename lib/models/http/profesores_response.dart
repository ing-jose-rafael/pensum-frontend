// To parse this JSON data, do
//
//     final profesorResponse = profesorResponseFromMap(jsonString);

import 'dart:convert';

import 'package:admin_dashboard/models/profesor.dart';

class ProfesorResponse {
  ProfesorResponse({
    required this.total,
    required this.profesores,
  });

  int total;
  List<Profesore> profesores;

  factory ProfesorResponse.fromJson(String str) => ProfesorResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProfesorResponse.fromMap(Map<String, dynamic> json) => ProfesorResponse(
        total: json["total"],
        profesores: List<Profesore>.from(json["profesores"].map((x) => Profesore.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "total": total,
        "profesores": List<dynamic>.from(profesores.map((x) => x.toMap())),
      };
}
