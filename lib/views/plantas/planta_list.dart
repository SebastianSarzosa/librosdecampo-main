import 'package:flutter/material.dart';
import 'package:libroscampo/models/plantas.dart';
import 'package:libroscampo/repositories/plantas_repository.dart';
import 'package:libroscampo/views/controles/controles_list.dart';
import 'package:libroscampo/views/controles/controles_form.dart';

class PlantaListView extends StatefulWidget {
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
  _PlantaListViewState createState() => _PlantaListViewState();
}

class _PlantaListViewState extends State<PlantaListView> {
  final PlantasRepository plantasRepository = PlantasRepository();
  List<Planta> plantasList = [];
  List<Planta> filteredPlantasList = [];
  TextEditingController searchController = TextEditingController();
  bool showFloatingButtons = false;

  @override
  void initState() {
    super.initState();
    _fetchPlantas();
    searchController.addListener(_filterPlantas);
  }

  void _fetchPlantas() async {
    final plantas = await plantasRepository.listPlantsByProject(widget.proyectoId);
    setState(() {
      plantasList = plantas;
      filteredPlantasList = plantas;
    });
  }

  void _filterPlantas() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredPlantasList = plantasList.where((planta) {
        return planta.nombrePlanta.toLowerCase().contains(query) ||
               (planta.descripcion?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  void _toggleFloatingButtons() {
    setState(() {
      showFloatingButtons = !showFloatingButtons;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                'libroId': widget.libroId, 
                'libroNombre': widget.libroNombre, 
                'userRole': widget.userRole, 
                'userName': widget.userName,
              },
            );
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
                labelText: 'Buscar plantas',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredPlantasList.length + 1, // +1 para incluir el texto antes de los cards
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Proyecto. ${widget.proyectoNombre}',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                final planta = filteredPlantasList[index - 1];
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
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (showFloatingButtons) ...[
            FloatingActionButton(
              heroTag: 'addPlanta', // Etiqueta única
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/planta/numero',
                  arguments: {
                    'proyectoId': widget.proyectoId, 
                    'proyectoNombre': widget.proyectoNombre, 
                    'userRole': widget.userRole, 
                    'userName': widget.userName,
                    'libroId': widget.libroId,
                    'libroNombre': widget.libroNombre,
                  },
                );
              },
              backgroundColor: Colors.teal,
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
                      proyectoId: widget.proyectoId,
                      proyectoNombre: widget.proyectoNombre,
                      userRole: widget.userRole,
                      userName: widget.userName,
                      libroId: widget.libroId,
                      libroNombre: widget.libroNombre,
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
            SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'addExcel', // Etiqueta única
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/excelPlantas',
                  arguments: {
                    'proyectoId': widget.proyectoId, 
                    'proyectoNombre': widget.proyectoNombre, 
                    'userRole': widget.userRole, 
                    'userName': widget.userName,
                    'libroId': widget.libroId,
                    'libroNombre': widget.libroNombre,
                  }
                );
              },
              backgroundColor: Colors.purple,
              child: Icon(
                color: const Color.fromARGB(255, 250, 250, 250),
                Icons.file_download_outlined,
              ),
            ),
          ],
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'toggleButtons', // Etiqueta única
            onPressed: _toggleFloatingButtons,
            backgroundColor: Colors.green,
            child: Icon(
              color: const Color.fromARGB(255, 250, 250, 250),
              showFloatingButtons ? Icons.close : Icons.menu,
            ),
          ),
        ],
      ),
    );
  }
}