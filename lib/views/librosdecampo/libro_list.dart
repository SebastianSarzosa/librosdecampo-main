import 'package:flutter/material.dart';
import 'package:libroscampo/models/librosdecampo.dart';
import 'package:libroscampo/repositories/librosdecampo_repository.dart';
import 'package:libroscampo/views/proyectos/proyecto_list.dart'; // Asegúrate de importar la vista de proyectos

class LibroListView extends StatelessWidget {
  final String userRole; // Añade el campo userRole
  final String userName; // Añade el campo userName

  LibroListView({required this.userRole, required this.userName});

  @override
  Widget build(BuildContext context) {
    final LibrosRespository librosRespository = LibrosRespository();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lista libro",
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/bienvenido', 
            arguments: {'userRole': userRole, 'userName': userName
            }); // Regresar a la pantalla de bienvenida
          },
        ),
      ),
      body: FutureBuilder<List<Librosdecampo>>(
        future: librosRespository.list(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)));
          }

          final libros = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: libros.length,
            itemBuilder: (context, i) {
              final libro = libros[i];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  leading: Icon(Icons.book, size: 40, color: Colors.teal),
                  title: Text(
                    libro.nombreLibro,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  subtitle: Text(
                    'Descripción: ${libro.descripcionLibro}',
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
                        builder: (context) => ProyectoListView(libroId: libro.id!, libroNombre: libro.nombreLibro, userRole: userRole, userName: userName),
                      ),
                    );
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