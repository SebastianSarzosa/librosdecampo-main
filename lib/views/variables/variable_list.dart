import 'package:flutter/material.dart';
import 'package:libroscampo/models/variables.dart';
import 'package:libroscampo/repositories/variables_repository.dart';

class VariablesListView extends StatelessWidget {
  final int controlId;

  const VariablesListView({Key? key, required this.controlId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VariablesRepository variablesRepository = VariablesRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text("Variables del Control",
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Variable>>(
        future: variablesRepository.listVariablesByControl(controlId),
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
                  leading: Icon(Icons.check_circle, size: 40, color: Colors.teal),
                  title: Text(
                    variable.nombreVariable,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  subtitle: Text(
                    'id: ${variable.idVariable}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  
                ),
              );
            },
          );
        },
      ),
    );
  }
}