class Planta {
  int? idPlanta;
  String nombrePlanta;
  String? descripcion;
  int fkidProyecto;


  Planta({
    this.idPlanta,
    required this.nombrePlanta,
    this.descripcion,
    required this.fkidProyecto,

  });

  // Convertir a Map para operaciones de base de datos
  Map<String, dynamic> toMap() {
    return {
      'id_planta': idPlanta,
      'nombre_planta': nombrePlanta,
      'nombre_cientifico': descripcion,
      'fkid_proyecto': fkidProyecto,

    };
  }

  // Crear una instancia de Planta desde un Map
  static Planta fromMap(Map<String, dynamic> map) {
    return Planta(
      idPlanta: map['id_planta'],
      nombrePlanta: map['nombre_planta'],
      descripcion: map['nombre_cientifico'],
      fkidProyecto: map['fkid_proyecto'],

    );
  }
}