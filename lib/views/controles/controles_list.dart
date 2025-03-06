import 'package:flutter/material.dart';
import 'package:libroscampo/models/controles.dart';
import 'package:libroscampo/repositories/controles_repository.dart';
import 'package:libroscampo/views/dashboardPlanta.dart';
import 'package:libroscampo/views/variables/variable_list.dart';

class ControlesListView extends StatelessWidget {
  final int plantaId;
  final int proyectoId;
  final String proyectoNombre;
  final String userRole;
  final String userName;   // Asegúrate de que este campo sea final
  final int libroId; // Añade el campo libroId
  final String libroNombre;

   ControlesListView({
     required this.plantaId, required this.proyectoId, 
     required this.proyectoNombre,  required this.userRole, 
     required this.userName, required this.libroId, 
     required this.libroNombre
     });

  @override
  Widget build(BuildContext context) {
    final ControlesRepository controlesRepository = ControlesRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Control de Plantas",
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
                    control.nombreControl, // Asegúrate de que este campo se muestre correctamente
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  subtitle: Text(
                    'Fecha de inicio: ${control.fechaControl}\nID: ${control.idControl}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal),
                   onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VariablesListView(
                            controlId: control.idControl!,
                            userRole: userRole,
                            userName: userName,
                            libroId: libroId,
                            libroNombre: libroNombre,
                            proyectoId: proyectoId,
                            proyectoNombre: proyectoNombre,
                          ),
                        ),
                      );
                    },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardPlantaView(
                plantaId: plantaId,
                proyectoId: proyectoId,
                proyectoNombre: proyectoNombre,
                userRole: userRole,
                userName: userName,
                libroId: libroId,
                libroNombre: libroNombre,
              ),
            ),
          );
        },
        child: Icon(Icons.dashboard, color: Colors.white),
        backgroundColor: Colors.green,
      ),
    );
  }
}