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
      'id_pro': idProyecto, // Asegúrate de que el nombre de la columna sea correcto
      'fkid_libro': fkidLibro, // Asegúrate de que el nombre de la columna sea correcto
      'nombre_pro': nombreProyecto, // Asegúrate de que el nombre de la columna sea correcto
      'descripcion_pro': descripcion, // Asegúrate de que el nombre de la columna sea correcto
      'fecha_inicio_pro': fechaInicio, // Asegúrate de que el nombre de la columna sea correcto
    };
  }

  // Crear una instancia de Proyecto desde un Map
  static Proyecto fromMap(Map<String, dynamic> map) {
    return Proyecto(
      idProyecto: map['id_pro'], // Asegúrate de que el nombre de la columna sea correcto
      fkidLibro: map['fkid_libro'], // Asegúrate de que el nombre de la columna sea correcto
      nombreProyecto: map['nombre_pro'], // Asegúrate de que el nombre de la columna sea correcto
      descripcion: map['descripcion_pro'], // Asegúrate de que el nombre de la columna sea correcto
      fechaInicio: map['fecha_inicio_pro'], // Asegúrate de que el nombre de la columna sea correcto
    );
  }
}
