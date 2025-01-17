import 'package:flutter/material.dart';
import 'package:libroscampo/models/controles.dart';
import 'package:libroscampo/repositories/controles_repository.dart';

class ControlesListView extends StatelessWidget {
  final int plantaId;

  const ControlesListView({Key? key, required this.plantaId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ControlesRepository controlesRepository = ControlesRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text("Controles de la Planta"),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Control>>(
        future: controlesRepository.listControlsByPlant(plantaId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay controles disponibles', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)));
          }

          final controles = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: controles.length,
            itemBuilder: (context, index) {
              final control = controles[index];
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
                    control.idControl.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  subtitle: Text(
                    'Descripción: ${control.descripcion}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal),
                  onTap: () {
                    // Acción al tocar el control (por ejemplo, navegar a otra pantalla)
                    // Navigator.push(...) o cualquier otra acción.
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