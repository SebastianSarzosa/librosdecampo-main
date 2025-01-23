import 'package:flutter/material.dart';
import 'package:libroscampo/models/plantas.dart';
import 'package:libroscampo/repositories/plantas_repository.dart';
import 'package:libroscampo/views/controles/controles_list.dart';

class PlantaListView extends StatelessWidget {
  final int proyectoId;
  final String proyectoNombre;

  const PlantaListView({Key? key, required this.proyectoId, required this.proyectoNombre}) : super(key: key);

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
            Navigator.pop(context);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/planta/numero',
            arguments: {'proyectoId': proyectoId},
          );
        },
        backgroundColor: Colors.green,
        child: Icon(
          color: const Color.fromARGB(255, 250, 250, 250),
          Icons.add
        ),
      ),
    );
  }
}