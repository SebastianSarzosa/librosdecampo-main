class Proyecto {
  int? idProyecto;
  int fkidLibro;
  String nombreProyecto;
  String? descripcion;
  String? fechaInicio;

  Proyecto({
    this.idProyecto,
    required this.fkidLibro,
    required this.nombreProyecto,
    this.descripcion,
    this.fechaInicio,
  });

  // Convertir a Map para operaciones de base de datos
  Map<String, dynamic> toMap() {
    return {
      'id_pro': idProyecto,
      'fkid_libro': fkidLibro,
      'nombre_pro': nombreProyecto,
      'descripcion_pro': descripcion,
      'fecha_inicio_pro': fechaInicio,
    };
  }

  // Crear una instancia de Proyecto desde un Map
  static Proyecto fromMap(Map<String, dynamic> map) {
    return Proyecto(
      idProyecto: map['id_pro'],
      fkidLibro: map['fkid_libro'],
      nombreProyecto: map['nombre_pro'],
      descripcion: map['descripcion_pro'],
      fechaInicio: map['fecha_inicio_pro'],
    );
  }
}
