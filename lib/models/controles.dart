class Control {
  int? idControl;
  int fkidPlanta;
  String nombreControl; // Asegúrate de que este campo no sea nulo
  String? descripcion;
  String? fechaControl;

  Control({
    this.idControl,
    required this.fkidPlanta,
    required this.nombreControl, // Asegúrate de que este campo no sea nulo
    this.descripcion,
    this.fechaControl,
  });

  // Convertir a Map para operaciones de base de datos
  Map<String, dynamic> toMap() {
    return {
      'id_control': idControl,
      'fkid_planta': fkidPlanta,
      'nombre_control': nombreControl, // Asegúrate de que este campo no sea nulo
      'descripcion': descripcion,
      'fecha_control': fechaControl,
    };
  }

  // Crear una instancia de Control desde un Map
  static Control fromMap(Map<String, dynamic> map) {
    return Control(
      idControl: map['id_control'],
      fkidPlanta: map['fkid_planta'],
      nombreControl: map['nombre_control'], // Asegúrate de que este campo no sea nulo
      descripcion: map['descripcion'],
      fechaControl: map['fecha_control'],
    );
  }
}