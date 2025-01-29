import 'package:flutter/material.dart';
import 'package:libroscampo/models/plantas.dart';
import 'package:libroscampo/repositories/plantas_repository.dart';
import 'package:libroscampo/views/controles/controles_list.dart';
import 'package:libroscampo/views/controles/controles_form.dart';

class PlantaListView extends StatelessWidget {
  final int proyectoId;
  final String proyectoNombre;
  final String userRole;
  final String userName;   // Asegúrate de que este campo sea final
  final int libroId; // Añade el campo libroId
  final String libroNombre; // Añade el campo libroNombre

  const PlantaListView({
    required this.proyectoId, required this.proyectoNombre, required this.userRole, required this.userName, required this.libroId, required this.libroNombre
  });

  @override
  Widget build(BuildContext context) {
    final PlantasRepository plantasRepository = PlantasRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text("Plantas del Proyecto",
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/proyecto/index',
              arguments: {
                'libroId': libroId, 
                'libroNombre': libroNombre, 
                'userRole': userRole, 
                'userName': userName,
                  
              },
            );
          },
        ),
      ),
      body: FutureBuilder<List<Planta>>(
        future: plantasRepository.listPlantsByProject(proyectoId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay plantas disponibles', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)));
          }

          final plantas = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: plantas.length + 1, // +1 para incluir el texto antes de los cards
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Proyecto. $proyectoNombre',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                );
              }
              final planta = plantas[index - 1];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  leading: Icon(Icons.local_florist, size: 40, color: Colors.teal),
                  title: Text(
                    planta.nombrePlanta,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  subtitle: Text(
                    'Descripción: ${planta.descripcion}',
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
                        builder: (context) => ControlesListView(plantaId: planta.idPlanta!),
                      ),
                    );
                  }
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addPlanta', // Etiqueta única
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/planta/numero',
                arguments: {
                  'proyectoId': proyectoId, 
                  'proyectoNombre': proyectoNombre, 
                  'userRole': userRole, 
                  'userName': userName,
                  'libroId': libroId,
                  'libroNombre': libroNombre,
                },
              );
            },
            backgroundColor: Colors.green,
            child: Icon(
              color: const Color.fromARGB(255, 250, 250, 250),
              Icons.add
            ),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'addControl', // Etiqueta única
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ControlFormView(
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
            backgroundColor: Colors.blue,
            child: Icon(
              color: const Color.fromARGB(255, 250, 250, 250),
              Icons.control_point,
            ),
            
          ),
        ],
      ),
    );
  }
}