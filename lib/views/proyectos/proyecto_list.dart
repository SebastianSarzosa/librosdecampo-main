import 'package:flutter/material.dart';
import 'package:libroscampo/models/proyectos.dart';
import 'package:libroscampo/repositories/proyectos_repository.dart';
import 'package:libroscampo/views/plantas/planta_list.dart';
import 'package:libroscampo/views/proyectos/proyecto_edit.dart'; // Importa la vista de edición de proyectos

class ProyectoListView extends StatefulWidget {
  final int libroId;
  final String libroNombre;
  final String userRole;  // Asegúrate de que este campo sea final
  final String userName; // Añade el campo userName

  ProyectoListView({required this.libroId, required this.libroNombre, required this.userRole, required this.userName});

  @override
  _ProyectoListViewState createState() => _ProyectoListViewState();
}

class _ProyectoListViewState extends State<ProyectoListView> {
  final ProyectosRepository proyectosRepository = ProyectosRepository();
  List<Proyecto> proyectosList = [];
  List<Proyecto> filteredProyectosList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProyectos();
    searchController.addListener(_filterProyectos);
  }

  void _fetchProyectos() async {
    final proyectos = await proyectosRepository.listProjectsByBook(widget.libroId);
    setState(() {
      proyectosList = proyectos;
      filteredProyectosList = proyectos;
    });
  }

  void _filterProyectos() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProyectosList = proyectosList.where((proyecto) {
        return proyecto.nombreProyecto.toLowerCase().contains(query) ||
               (proyecto.descripcion?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Proyectos de ${widget.libroNombre}",
          style: TextStyle(color: Colors.white, fontSize: 19.5),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/libro/index', 
            arguments: {'userRole': widget.userRole, 'userName': widget.userName}); // Regresar a la pantalla de libros
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar proyectos',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Proyecto>>(
              future: proyectosRepository.listProjectsByBook(widget.libroId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay proyectos disponibles', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)));
                }

                final proyectos = filteredProyectosList;

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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.userRole == 'admin') // Mostrar el botón de editar solo si el usuario es admin
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.teal),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProyectoEditView(
                                        proyecto: proyecto,
                                        userRole: widget.userRole,
                                        userName: widget.userName,
                                        libroId: widget.libroId,
                                        libroNombre: widget.libroNombre,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            Icon(Icons.arrow_forward_ios, color: Colors.teal), // Ícono de flecha al final
                          ],
                        ),
                        onTap: () {
                          // Navegar a la pantalla de proyectos
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlantaListView(
                                proyectoId: proyecto.idProyecto!, proyectoNombre: proyecto.nombreProyecto, userRole: widget.userRole, userName: widget.userName, libroId: widget.libroId, libroNombre: widget.libroNombre
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
          ),
        ],
      ),
      floatingActionButton: widget.userRole == 'admin' // Mostrar el botón solo si el rol es admin
      ? FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/proyecto/form',
              arguments: {
                'libroId': widget.libroId, 
                'libroNombre': widget.libroNombre, 
                'userRole': widget.userRole, 
                'userName': widget.userName
              },
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