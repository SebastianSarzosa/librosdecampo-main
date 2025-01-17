import 'package:flutter/material.dart';

class Variable {
  final int idVariable;
  final String nombreVariable;
  final String? valorTexto;
  final num? valorNumerico;
  final DateTime? valorFecha;
  final int fkidControl;

  Variable({
    required this.idVariable,
    required this.nombreVariable,
    this.valorTexto,
    this.valorNumerico,
    this.valorFecha,
    required this.fkidControl,
  });

  factory Variable.fromMap(Map<String, dynamic> map) {
    return Variable(
      idVariable: map['id_variable'],
      nombreVariable: map['nombre_variable'],
      valorTexto: map['valor_texto'],
      valorNumerico: map['valor_numerico'],
      valorFecha: map['valor_fecha'] != null ? DateTime.parse(map['valor_fecha']) : null,
      fkidControl: map['fkid_control'],
    );
  }

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
}