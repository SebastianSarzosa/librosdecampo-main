class Librosdecampo {
  int? idLibro;  
  String nombreLibro;
  String descripcionLibro;
  DateTime fechaCreacionLibro;
  
  Librosdecampo({
    this.idLibro,
    required this.nombreLibro,
    required this.descripcionLibro,
    required this.fechaCreacionLibro
  });

  Map<String, dynamic>toMap(){
    return{
      'id_libro':idLibro,
      'nombre_libro':nombreLibro,
      'descripcion_libro':descripcionLibro,
      'fecha_creacion_libro': fechaCreacionLibro
    };
  }

  static Librosdecampo fromMap(Map<String, dynamic>map){
    return Librosdecampo(
      idLibro: map['id_libro'],
      nombreLibro: map['nombre_libro'], 
      descripcionLibro: map['descripcion_libro'], 
      fechaCreacionLibro: map['fecha_creacion_libro']
    );
  }
}
