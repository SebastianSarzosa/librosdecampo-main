class Librosdecampo {
  int? id;  
  String nombreLibro;
  String descripcionLibro;
  DateTime fechaCreacionLibro;
  
  Librosdecampo({
    this.id,
    required this.nombreLibro,
    required this.descripcionLibro,
    required this.fechaCreacionLibro
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre_libro': nombreLibro,
      'descripcion_libro': descripcionLibro,
      // Convierte DateTime a String
      'fecha_creacion_libro': fechaCreacionLibro.toIso8601String(),
    };
  }


  static Librosdecampo fromMap(Map<String, dynamic> map) {
    return Librosdecampo(
      id: map['id'],
      nombreLibro: map['nombre_libro'],
      descripcionLibro: map['descripcion_libro'],
      // Convierte la fecha de String a DateTime
      fechaCreacionLibro: DateTime.parse(map['fecha_creacion_libro']),
    );
  }

}
