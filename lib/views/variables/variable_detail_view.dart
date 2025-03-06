import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libroscampo/models/variables.dart';
import 'package:libroscampo/repositories/variables_repository.dart';

class VariableDetailView extends StatefulWidget {
  final Variable variable;

  const VariableDetailView({Key? key, required this.variable}) : super(key: key);

  @override
  _VariableDetailViewState createState() => _VariableDetailViewState();
}

class _VariableDetailViewState extends State<VariableDetailView> {
  late TextEditingController _valueController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController(
      text: widget.variable.valorTexto ?? widget.variable.valorNumerico?.toString() ?? widget.variable.valorFecha?.toString().split(' ')[0]
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detalle de Variable",
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // Indicar que se debe refrescar el dashboard
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _valueController,
                keyboardType: widget.variable.nombreVariable == 'Altura' || widget.variable.nombreVariable == 'Cantidad de agua' || widget.variable.nombreVariable == 'Cantidad de Saponinas'
                    ? TextInputType.number
                    : widget.variable.valorFecha != null
                        ? TextInputType.datetime
                        : TextInputType.text,
                decoration: InputDecoration(
                  labelText: widget.variable.nombreVariable == 'Altura'
                      ? 'Ingrese el valor en cm'
                      : widget.variable.nombreVariable == 'Cantidad de agua'
                          ? 'Ingrese el valor en litros'
                          : widget.variable.nombreVariable == 'Cantidad de Saponinas'
                              ? 'Ingrese el valor en cm'
                              : 'Valor de ${widget.variable.nombreVariable}',
                  border: OutlineInputBorder(),
                  suffixText: widget.variable.nombreVariable == 'Altura'
                      ? 'cm'
                      : widget.variable.nombreVariable == 'Cantidad de agua'
                          ? 'litros'
                          : widget.variable.nombreVariable == 'Cantidad de Saponinas'
                              ? 'cm'
                              : null,
                ),
                inputFormatters: widget.variable.nombreVariable == 'Altura' || widget.variable.nombreVariable == 'Cantidad de agua' || widget.variable.nombreVariable == 'Cantidad de Saponinas'
                    ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
                    : widget.variable.nombreVariable == 'Color de hoja'
                        ? [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))]
                        : null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El valor es requerido';
                  }
                  if (widget.variable.nombreVariable == 'Altura') {
                    final altura = double.tryParse(value);
                    if (altura == null || altura < 0 || altura > 500) {
                      return 'La altura debe ser un número entre 0 y 500 cm';
                    }
                  }
                  if (widget.variable.nombreVariable == 'Cantidad de agua') {
                    final cantidad = double.tryParse(value);
                    if (cantidad == null || cantidad < 0 || cantidad > 30) {
                      return 'La cantidad de agua debe ser un número entre 0 y 30 litros';
                    }
                  }
                  if (widget.variable.nombreVariable == 'Cantidad de Saponinas') {
                    final cantidad = double.tryParse(value);
                    if (cantidad == null || cantidad < 0 || cantidad > 20) {
                      return 'La cantidad debe ser un número entre 0 y 20 cm';
                    }
                  }
                  return null;
                },
                onTap: widget.variable.valorFecha != null
                    ? () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          String formattedDate = pickedDate.toString().split(' ')[0];
                          _valueController.text = formattedDate;
                        }
                      }
                    : null,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (widget.variable.nombreVariable == 'Altura' || widget.variable.nombreVariable == 'Cantidad de agua' || widget.variable.nombreVariable == 'Cantidad de Saponinas') {
                      widget.variable.valorNumerico = double.tryParse(_valueController.text);
                      _valueController.text = widget.variable.valorNumerico?.toString() ?? '';
                    } else if (widget.variable.valorFecha != null) {
                      widget.variable.valorFecha = DateTime.tryParse(_valueController.text);
                    } else {
                      widget.variable.valorTexto = _valueController.text;
                    }
                    await VariablesRepository().update(widget.variable.idVariable!, widget.variable);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Variable actualizada correctamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context, true); // Indicar que se debe refrescar la lista de variables
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
