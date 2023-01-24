import 'package:admin_dashboard/models/asignatura.dart';

class PdfInfCurso {
  Asignatura curso;
  List<PdfCursoProf> profesores;

  PdfInfCurso({required this.curso, required this.profesores});
}

class PdfCursoProf {
  String nombre;
  int grupoTeoria;
  int? grupoPractica;
  PdfCursoProf({required this.nombre, required this.grupoTeoria, this.grupoPractica});
}
