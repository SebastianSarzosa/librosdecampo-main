import 'package:flutter/material.dart';
import 'package:libroscampo/models/variables.dart';
import 'package:libroscampo/repositories/variables_repository.dart';

class VariablesListView extends StatefulWidget {
  final int controlId;

  const VariablesListView({Key? key, required this.controlId}) : super(key: key);

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
            Navigator.pop(context);
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
                  trailing: Icon(Icons.edit, color: Colors.teal),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VariableDetailView(variable: variable),
                      ),
                    );
                    _refreshVariables();
                  },
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
    final _valueController = TextEditingController(text: variable.valorTexto);

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
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: _valueController,
              decoration: InputDecoration(
                labelText: 'Valor de ${variable.nombreVariable}',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Update the variable value
                variable.valorTexto = _valueController.text;
                await VariablesRepository().update(variable.idVariable!, variable);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Variable actualizada correctamente'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
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