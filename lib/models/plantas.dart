class Planta {
  int? idPlanta;
  int fkidProyecto;
  String nombrePlanta;
  String? descripcion;
  String? fechaPlantacion;

  Planta({
    this.idPlanta,
    required this.fkidProyecto,
    required this.nombrePlanta,
    this.descripcion,
    this.fechaPlantacion,
  });

  // Convertir a Map para operaciones de base de datos
  Map<String, dynamic> toMap() {
    return {
      'id_planta': idPlanta,
      'fkid_proyecto': fkidProyecto,
      'nombre_planta': nombrePlanta,
      'nombre_cientifico': descripcion,
      'fecha_plantacion': fechaPlantacion,
    };
  }

  // Crear una instancia de Planta desde un Map
  static Planta fromMap(Map<String, dynamic> map) {
    return Planta(
      idPlanta: map['id_planta'],
      fkidProyecto: map['fkid_proyecto'],
      nombrePlanta: map['nombre_planta'],
      descripcion: map['nombre_cientifico'],
      fechaPlantacion: map['fecha_plantacion'],
    );
  }
}