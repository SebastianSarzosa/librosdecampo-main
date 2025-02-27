class Variable {
  int? idVariable;
  String nombreVariable;
  String? valorTexto;
  double? valorNumerico;
  DateTime? valorFecha;
  int fkidControl;

  Variable({
    this.idVariable,
    required this.nombreVariable,
    this.valorTexto,
    this.valorNumerico,
    this.valorFecha,
    required this.fkidControl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_variable': idVariable,
      'nombre_variable': nombreVariable,
      'valor_texto': valorTexto,
      'valor_numerico': valorNumerico,
      'valor_fecha': valorFecha?.toIso8601String(),
      'fkid_control': fkidControl,
    };
  }

  static Variable fromMap(Map<String, dynamic> map) {
    return Variable(
      idVariable: map['id_variable'],
      nombreVariable: map['nombre_variable'],
      valorTexto: map['valor_texto'],
      valorNumerico: map['valor_numerico']?.toDouble(), // Asegúrate de convertir a double
      valorFecha: map['valor_fecha'] != null ? DateTime.parse(map['valor_fecha']) : null,
      fkidControl: map['fkid_control'],
    );
  }
}