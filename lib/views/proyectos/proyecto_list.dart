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
        backgroundColor: Colors.teal, // Cambiar color de la app bar
      ),
      body: FutureBuilder<List<Proyecto>>(
        future: proyectosRepository.listProjectsByBook(libroId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay proyectos disponibles', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)));
          }

          final proyectos = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0), // Padding para que no esté pegado al borde
            itemCount: proyectos.length,
            itemBuilder: (context, index) {
              final proyecto = proyectos[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0), // Padding dentro de cada card
                  leading: Icon(Icons.book, size: 40, color: Colors.teal), // Ícono en el inicio de cada item
                  title: Text(
                    proyecto.nombreProyecto,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  subtitle: Text(
                    'Descripción: ${proyecto.descripcion}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600], // Color gris para la descripción
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal), // Ícono de flecha al final
                  onTap: () {
                    // Acción al tocar el proyecto (por ejemplo, navegar a otra pantalla)
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
