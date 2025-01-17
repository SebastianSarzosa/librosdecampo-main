class Control {
  int? idControl;
  int fkidPlanta;
  String tipoControl;
  String? descripcion;
  String? fechaControl;

  Control({
    this.idControl,
    required this.fkidPlanta,
    required this.tipoControl,
    this.descripcion,
    this.fechaControl,
  });

  // Convertir a Map para operaciones de base de datos
  Map<String, dynamic> toMap() {
    return {
      'id_control': idControl,
      'fkid_planta': fkidPlanta,
      'tipo_control': tipoControl,
      'descripcion_control': descripcion,
      'fecha_control': fechaControl,
    };
  }

  // Crear una instancia de Control desde un Map
  static Control fromMap(Map<String, dynamic> map) {
    return Control(
      idControl: map['id_control'],
      fkidPlanta: map['fkid_planta'],
      tipoControl: map['tipo_control'],
      descripcion: map['descripcion_control'],
      fechaControl: map['fecha_control'],
    );
  }
}