import 'package:flutter/material.dart';

import 'package:libroscampo/models/librosdecampo.dart';
import 'package:libroscampo/repositories/librosdecampo_repository.dart';

import 'package:libroscampo/views/proyectos/proyecto_list.dart'; // Asegúrate de importar la vista de proyectos

class LibroListView extends StatefulWidget {
    final String userRole; // Añade el campo userRole
    const LibroListView({super.key, required this.userRole});

  @override
  State<LibroListView> createState() => _LibroListViewState();
}

class _LibroListViewState extends State<LibroListView> {
  final LibrosRespository _librosRespository = LibrosRespository();
  List<Librosdecampo> _libros = [];

  @override
  void initState() {
    super.initState();
    _cargarLibro();
  }

  Future<void> _cargarLibro() async {
    final data = await _librosRespository.list();
    setState(() {
      _libros = data;
    });
  }

  
  @override
  Widget build(BuildContext context) {
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
            Navigator.pushReplacementNamed(
              context,
              '/bienvenido',
              arguments: {'userRole': widget.userRole},
            );
          },
        ),
      ),
      body: _libros.isEmpty
          ? Center(
              child: Text('No hay datos', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _libros.length,
              itemBuilder: (context, i) {
                final libro = _libros[i];
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
                          builder: (context) => ProyectoListView(libroId: libro.id!, libroNombre:libro.nombreLibro, userRole: widget.userRole), // Asegúrate de pasar el id del libro
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      
    );
  }
}