import 'dart:convert';

class Asignatura {
  Asignatura({
    required this.codigo,
    required this.nombre,
    required this.hTeorica,
    this.hPractica,
    required this.grupTeoria,
    this.grupPractica,
    this.grupPracticaAsig,
    this.grupTeoriaAsig,
    this.profesores,
    required this.uid,
  });

  String codigo;
  String nombre;
  int hTeorica;
  int? hPractica;
  int grupTeoria;
  int? grupPractica;
  int? grupPracticaAsig;
  int? grupTeoriaAsig;
  List<String>? profesores;
  String uid;

  factory Asignatura.fromJson(String str) => Asignatura.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Asignatura.fromMap(Map<String, dynamic> json) => Asignatura(
        codigo: json["codigo"],
        nombre: json["nombre"],
        hTeorica: json["hTeorica"],
        hPractica: json["hPractica"],
        grupTeoria: json["grupTeoria"],
        grupPractica: json["grupPractica"],
        profesores: json["profesores"] == null ? [] : List<String>.from(json["profesores"].map((x) => x)),
        grupTeoriaAsig: json["grupTeoriaAsig"],
        grupPracticaAsig: json["grupPracticaAsig"],
        uid: json["uid"],
        // codigo: json["codigo"],
        // nombre: json["nombre"],
        // hTeorica: json["hTeorica"],
        // hPractica: json["hPractica"],
        // grupTeoria: json["grupTeoria"],
        // grupPractica: json["grupPractica"],
        // profesores: List<String>.from(json["profesores"].map((x) => x)),
        // grupTeoriaAsig: json["grupTeoriaAsig"],
        // grupPracticaAsig: json["grupPracticaAsig"],
        // uid: json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "codigo": codigo,
        "nombre": nombre,
        "hTeorica": hTeorica,
        "hPractica": hPractica,
        "grupTeoria": grupTeoria,
        "grupPractica": grupPractica,
        "grupPracticaAsig": grupPracticaAsig,
        "grupTeoriaAsig": grupTeoriaAsig,
        "profesores": profesores == null ? null : List<dynamic>.from(profesores!.map((x) => x)),
        "uid": uid,
      };

  ///custom comparing function to check if two users are equal
  bool isEqual(Asignatura model) {
    return this.uid == model.uid;
  }

  @override
  String toString() => nombre;
}
