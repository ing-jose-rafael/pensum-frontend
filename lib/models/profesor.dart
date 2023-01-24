import 'dart:convert';

class Profesore extends Comparable {
  Profesore({
    required this.nombre,
    required this.cedula,
    required this.contratacion,
    this.cargo,
    this.tope,
    this.horasAsi,
    this.cursos,
    this.observaciones,
    required this.uid,
  }) {
    switch (this.contratacion) {
      case 'Docente Carrera':
        this.ordeByContr = 1;
        break;
      case 'Docente MTO':
      case 'Docente TCO':
        this.ordeByContr = 2;
        break;
      case 'Docente Hora Catedra':
        this.ordeByContr = 3;
        break;
      default:
        this.ordeByContr = 4;
    }
  }

  String nombre;
  String cedula;
  String contratacion;
  String? cargo;
  int? tope;
  int? horasAsi;
  List<Curso>? cursos;
  String? observaciones;
  int? ordeByContr; // para ordenarlos por tipo de contrato
  String uid;

  factory Profesore.fromJson(String str) => Profesore.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Profesore.fromMap(Map<String, dynamic> json) => Profesore(
        nombre: json["nombre"],
        cedula: json["cedula"],
        contratacion: json["contratacion"],
        cargo: json["cargo"],
        tope: json["tope"],
        horasAsi: json["horasAsi"],
        cursos: List<Curso>.from(json["cursos"].map((x) => Curso.fromMap(x))),
        observaciones: json["observaciones"],
        uid: json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "nombre": nombre,
        "cedula": cedula,
        "contratacion": contratacion,
        "cargo": cargo,
        "tope": tope,
        "horasAsi": horasAsi,
        "cursos": List<dynamic>.from(cursos!.map((x) => x.toMap())),
        "observaciones": observaciones,
        "uid": uid,
      };

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.uid} ${this.nombre}';
  }

  static List<Profesore> fromJsonList(List list) {
    // if (list == null) return null;
    return list.map((item) => Profesore.fromJson(item)).toList();
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Profesore model) {
    return this.uid == model.uid;
  }

  @override
  String toString() => nombre;
  // sort by contratacion (asc), then nombre (desc)
  @override
  int compareTo(other) {
    int tipoContratoComp = this.ordeByContr!.compareTo(other.ordeByContr);
    if (tipoContratoComp == 0) {
      return this.nombre.compareTo(other.nombre); // '-' for descending
    }
    return tipoContratoComp;
  }
}

class Curso {
  Curso({
    required this.horaTeoria,
    required this.codigo,
    this.horaPractica,
    required this.asignatura,
    required this.grupoTeoria,
    this.grupoPractica,
    required this.id,
  });

  int horaTeoria;
  int? horaPractica;
  AsignaturaProfesor asignatura;
  // String asignatura;
  int grupoTeoria;
  int? grupoPractica;
  String id;
  String codigo;

  factory Curso.fromJson(String str) => Curso.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Curso.fromMap(Map<String, dynamic> json) => Curso(
        horaTeoria: json["horaTeoria"],
        codigo: json["codigo"],
        horaPractica: json["horaPractica"],
        asignatura: AsignaturaProfesor.fromMap(json["asignatura"]),
        // asignatura: json["asignatura"],
        grupoTeoria: json["grupoTeoria"],
        grupoPractica: json["grupoPractica"],
        id: json["_id"],
      );

  Map<String, dynamic> toMap() => {
        "asignatura": asignatura.toMap(),
        "codigo": codigo,
        "grupoTeoria": grupoTeoria,
        "horaTeoria": horaTeoria,
        "grupoPractica": grupoPractica,
        "horaPractica": horaPractica,
        "_id": id,
        // "asignatura": asignatura,
      };
}

class AsignaturaProfesor {
  AsignaturaProfesor({
    required this.id,
    required this.nombre,
    required this.hTeorica,
    this.hPractica,
  });

  String id;
  String nombre;
  int hTeorica;
  int? hPractica;

  factory AsignaturaProfesor.fromJson(String str) => AsignaturaProfesor.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AsignaturaProfesor.fromMap(Map<String, dynamic> json) => AsignaturaProfesor(
        id: json["_id"],
        nombre: json["nombre"],
        hTeorica: json["hTeorica"],
        hPractica: json["hPractica"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "nombre": nombre,
        "hTeorica": hTeorica,
        "hPractica": hPractica,
      };
}
