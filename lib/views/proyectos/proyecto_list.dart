import 'package:flutter/material.dart';
import 'package:libroscampo/models/proyectos.dart';
import 'package:libroscampo/repositories/proyectos_repository.dart';
import 'package:libroscampo/views/plantas/planta_list.dart';

class ProyectoListView extends StatelessWidget {
  final int libroId;
  final String libroNombre;
  final String userRole;  // Asegúrate de que este campo sea final


  ProyectoListView({required this.libroId, required this.libroNombre, required this.userRole});

  @override
  Widget build(BuildContext context) {
  print('User  Role: $userRole'); 
    final ProyectosRepository proyectosRepository = ProyectosRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text("Proyectos de $libroNombre",
           style: TextStyle(color: Colors.white, 
           fontSize: 19.5,
           ),       
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/libro/index',
              arguments: {'userRole': userRole},
            );
          },
        ),
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
                      // Navegar a la pantalla de proyectos
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlantaListView(proyectoId: proyecto.idProyecto!, proyectoNombre: proyecto.nombreProyecto),
                        ),
                      );
                    },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: userRole == 'admin' // Mostrar el botón solo si el rol es admin
      ? FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/proyecto/form',
              arguments: {'libroId': libroId, 'libroNombre': libroNombre, 'userRole': userRole}
            );
          },
          backgroundColor: Colors.green,
          child: Icon(
            color: const Color.fromARGB(255, 250, 250, 250),
            Icons.add
          ),
        )
      : null, // Si no es admin, no mostrar el botón
    );
  }
  
}