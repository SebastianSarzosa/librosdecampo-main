import 'package:flutter/material.dart';

import 'package:libroscampo/models/librosdecampo.dart';
import 'package:libroscampo/repositories/librosdecampo_repository.dart';

import 'package:libroscampo/views/proyectos/proyecto_list.dart'; // Asegúrate de importar la vista de proyectos

class LibroListView extends StatefulWidget {
  const LibroListView({super.key});

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

  Future<void> _eliminarLibro(int id) async {
    await _librosRespository.delete(id);
    _cargarLibro();
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
            Navigator.popUntil(context, ModalRoute.withName('/bienvenido'));
          },
        ),
      ),
      body: _libros.isEmpty
          ? Center(
              child: Text('No hay datos'),
            )
          : ListView.builder(
              itemCount: _libros.length,
              itemBuilder: (context, i) {
                final libro = _libros[i];
                return Card(
                  child: ListTile(
                    title: Text('${libro.nombreLibro} '),
                    subtitle: Column(
                      children: [
                        Text('descripcion: ${libro.descripcionLibro}')
                      ],
                    ),
                    onTap: () {
                      // Navegar a la pantalla de proyectos
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProyectoListView(libroId: libro.id!),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit,
                            color: Color.fromARGB(255, 6, 94, 9),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final mensaje = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Eliminar libro'),
                                  content: Text('¿Está seguro de eliminar el libro?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text('Si'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (mensaje == true) {
                              _eliminarLibro(libro.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(' ${libro.nombreLibro} eliminado exitosamente')),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/libro/form');
        },
        backgroundColor: Color.fromARGB(255, 6, 67, 146),
        child: Icon(
          color: const Color.fromARGB(255, 250, 250, 250),
          Icons.add,
        ),
      ),
    );
  }
}