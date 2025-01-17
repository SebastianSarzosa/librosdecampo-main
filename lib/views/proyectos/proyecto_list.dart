import 'package:flutter/material.dart';
import 'package:libroscampo/models/proyectos.dart';
import 'package:libroscampo/repositories/proyectos_repository.dart';

class ProyectoListView extends StatelessWidget {
  final int libroId;

  const ProyectoListView({Key? key, required this.libroId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProyectosRepository proyectosRepository = ProyectosRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text("Proyectos del Libro"),
      ),
      body: FutureBuilder<List<Proyecto>>(
        future: proyectosRepository.listProjectsByBook(libroId), // Cambia bookId a libroId
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay proyectos'));
          }

          final proyectos = snapshot.data!;

          return ListView.builder(
            itemCount: proyectos.length,
            itemBuilder: (context, index) {
              final proyecto = proyectos[index];
              return ListTile(
                title: Text(proyecto.nombreProyecto),
                
              );
            },
          );
        },
      ),
    );
  }
}