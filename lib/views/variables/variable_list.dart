import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Añadir esta línea
import 'package:libroscampo/models/variables.dart';
import 'package:libroscampo/repositories/variables_repository.dart';

class VariablesListView extends StatefulWidget {
  final int controlId;
  final int proyectoId;
  final String proyectoNombre;
  final String userRole;
  final String userName; // Asegúrate de que este campo sea final
  final int libroId; // Añade el campo libroId
  final String libroNombre; // Añadir el campo userRole
  final Function()? onDataUpdated; // Añade este campo

  const VariablesListView({
    required this.controlId,
    required this.userRole,
    required this.userName,
    required this.libroId,
    required this.libroNombre,
    required this.proyectoId,
    required this.proyectoNombre,
    this.onDataUpdated, // Recibe el callback
  });

  @override
  _VariablesListViewState createState() => _VariablesListViewState();
}

class _VariablesListViewState extends State<VariablesListView> {
  late Future<List<Variable>> _variablesFuture;

  @override
  void initState() {
    super.initState();
    _variablesFuture = VariablesRepository().listVariablesByControl(widget.controlId);
  }

  void _refreshVariables() {
    setState(() {
      _variablesFuture = VariablesRepository().listVariablesByControl(widget.controlId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Variables del Control",
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
      body: FutureBuilder<List<Variable>>(
        future: _variablesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay variables disponibles', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)));
          }

          final variables = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: variables.length,
            itemBuilder: (context, index) {
              final variable = variables[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  leading: Icon(Icons.label, size: 40, color: Colors.teal),
                  title: Text(
                    variable.nombreVariable,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  subtitle: Text(
                    'Valor: ${variable.valorTexto ?? variable.valorNumerico ?? variable.valorFecha}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: (widget.userRole == 'admin' || widget.userRole == 'editor')
                      ? Icon(Icons.edit, color: Colors.teal)
                      : null,
                  onTap: (widget.userRole == 'admin' || widget.userRole == 'editor')
                      ? () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VariableDetailView(variable: variable),
                            ),
                          );
                          if (result == true) {
                            _refreshVariables();
                            Navigator.pop(context, true); // Indicar que se debe refrescar el dashboard
                          }
                        }
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class VariableDetailView extends StatelessWidget {
  final Variable variable;

  const VariableDetailView({Key? key, required this.variable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _valueController = TextEditingController(
      text: variable.valorTexto ?? variable.valorNumerico?.toString() ?? variable.valorFecha?.toString().split(' ')[0]
    );

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
        child: Column(
          children: [
            TextFormField(
              controller: _valueController,
              keyboardType: variable.nombreVariable == 'Altura' || variable.nombreVariable == 'Cantidad de agua'
                  ? TextInputType.number
                  : variable.valorFecha != null
                      ? TextInputType.datetime
                      : TextInputType.text,
              decoration: InputDecoration(
                labelText: variable.nombreVariable == 'Altura'
                    ? 'Ingrese el valor en cm'
                    : variable.nombreVariable == 'Cantidad de agua'
                        ? 'Ingrese el valor en litros'
                        : 'Valor de ${variable.nombreVariable}',
                border: OutlineInputBorder(),
                suffixText: variable.nombreVariable == 'Altura'
                    ? 'cm'
                    : variable.nombreVariable == 'Cantidad de agua'
                        ? 'litros'
                        : null,
              ),
              inputFormatters: variable.nombreVariable == 'Altura' || variable.nombreVariable == 'Cantidad de agua'
                  ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
                  : null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El valor es requerido';
                }
                if (variable.nombreVariable == 'Altura') {
                  final altura = double.tryParse(value);
                  if (altura == null || altura < 0 || altura > 500) {
                    return 'La altura debe ser un número entre 0 y 500 cm';
                  }
                }
                if (variable.nombreVariable == 'Cantidad de agua') {
                  final cantidad = double.tryParse(value);
                  if (cantidad == null || cantidad < 0) {
                    return 'La cantidad de agua debe ser un número positivo';
                  }
                }
                return null;
              },
              onTap: variable.valorFecha != null
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (variable.nombreVariable == 'Altura' || variable.nombreVariable == 'Cantidad de agua') {
                  variable.valorNumerico = double.tryParse(_valueController.text);
                } else if (variable.valorFecha != null) {
                  variable.valorFecha = DateTime.tryParse(_valueController.text);
                } else {
                  variable.valorTexto = _valueController.text;
                }
                await VariablesRepository().update(variable.idVariable!, variable);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Variable actualizada correctamente'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context, true); // Indicar que se debe refrescar el dashboard
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}