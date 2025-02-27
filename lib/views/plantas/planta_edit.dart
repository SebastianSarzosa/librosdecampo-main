import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libroscampo/models/plantas.dart';
import 'package:libroscampo/repositories/plantas_repository.dart';
import 'package:libroscampo/views/plantas/planta_list.dart';

class PlantaEditView extends StatefulWidget {
  final List<Planta> plantasList;
  final String userRole;
  final String userName;
  final int libroId;
  final String libroNombre;
  final String proyectoNombre;
  final int proyectoId;
  final int numeroPlantas; // Añadir el campo numeroPlantas

  const PlantaEditView({
    required this.plantasList,
    required this.userRole,
    required this.userName,
    required this.libroId,
    required this.libroNombre,
    required this.proyectoNombre,
    required this.proyectoId,
    required this.numeroPlantas, // Añadir el campo numeroPlantas
  });

  @override
  _PlantaEditViewState createState() => _PlantaEditViewState();
}

class _PlantaEditViewState extends State<PlantaEditView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  List<int> selectedPlantasIds = [];
  Map<String, int> plantasCount = {};

  @override
  void initState() {
    super.initState();
    _initializePlantasCount();
  }

  void _initializePlantasCount() {
    widget.plantasList.forEach((planta) {
      String key = '${planta.nombrePlanta.split(' ').first}-${planta.descripcion}';
      if (plantasCount.containsKey(key)) {
        plantasCount[key] = plantasCount[key]! + 1;
      } else {
        plantasCount[key] = 1;
      }
    });
  }

  bool _areSelectedPlantasEqual() {
    if (selectedPlantasIds.isEmpty) return true;
    final firstPlanta = widget.plantasList.firstWhere((p) => p.idPlanta == selectedPlantasIds.first);
    return selectedPlantasIds.every((id) {
      final planta = widget.plantasList.firstWhere((p) => p.idPlanta == id);
      return planta.nombrePlanta.split(' ').first == firstPlanta.nombrePlanta.split(' ').first;
    });
  }

  void _toggleSelection(Planta planta) {
    setState(() {
      if (selectedPlantasIds.contains(planta.idPlanta)) {
        // Desmarcar todas las plantas iguales
        widget.plantasList.forEach((p) {
          if (p.nombrePlanta.split(' ').first == planta.nombrePlanta.split(' ').first &&
              p.descripcion == planta.descripcion) {
            selectedPlantasIds.remove(p.idPlanta!);
          }
        });
      } else {
        // Marcar todas las plantas iguales
        widget.plantasList.forEach((p) {
          if (p.nombrePlanta.split(' ').first == planta.nombrePlanta.split(' ').first &&
              p.descripcion == planta.descripcion) {
            selectedPlantasIds.add(p.idPlanta!);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Plantas para Editar',
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: plantasCount.length,
              itemBuilder: (context, index) {
                String key = plantasCount.keys.elementAt(index);
                int count = plantasCount[key]!;
                String nombrePlanta = key.split('-').first;
                String descripcion = key.split('-').last;
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
                      '$nombrePlanta ($count)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    subtitle: Text(
                      'Nombre Cientifico: $descripcion',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        selectedPlantasIds.any((id) {
                          final planta = widget.plantasList.firstWhere((p) => p.idPlanta == id);
                          return planta.nombrePlanta.split(' ').first == nombrePlanta &&
                                 planta.descripcion == descripcion;
                        })
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: Colors.teal,
                      ),
                      onPressed: () {
                        final planta = widget.plantasList.firstWhere((p) =>
                            p.nombrePlanta.split(' ').first == nombrePlanta &&
                            p.descripcion == descripcion);
                        _toggleSelection(planta);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedPlantasIds.isNotEmpty) {
                if (_areSelectedPlantasEqual()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlantaEditFormView(
                        selectedPlantasIds: selectedPlantasIds,
                        plantasList: widget.plantasList,
                        userRole: widget.userRole,
                        userName: widget.userName,
                        libroId: widget.libroId,
                        libroNombre: widget.libroNombre,
                        proyectoNombre: widget.proyectoNombre,
                        proyectoId: widget.proyectoId,
                        numeroPlantas: selectedPlantasIds.length, // Corregir el campo numeroPlantas
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Las plantas seleccionadas no son iguales'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Seleccione al menos una planta para editar'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Text('Editar Plantas Seleccionadas', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class PlantaEditFormView extends StatefulWidget {
  final List<int> selectedPlantasIds;
  final List<Planta> plantasList;
  final String userRole;
  final String userName;
  final int libroId;
  final String libroNombre;
  final String proyectoNombre;
  final int proyectoId;
  final int numeroPlantas; // Añadir el campo numeroPlantas

  const PlantaEditFormView({
    required this.selectedPlantasIds,
    required this.plantasList,
    required this.userRole,
    required this.userName,
    required this.libroId,
    required this.libroNombre,
    required this.proyectoNombre,
    required this.proyectoId,
    required this.numeroPlantas, // Añadir el campo numeroPlantas
  });

  @override
  _PlantaEditFormViewState createState() => _PlantaEditFormViewState();
}

class _PlantaEditFormViewState extends State<PlantaEditFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.selectedPlantasIds.isNotEmpty) {
      final planta = widget.plantasList.firstWhere((planta) => planta.idPlanta == widget.selectedPlantasIds.first);
      _nombreController.text = planta.nombrePlanta.split(' ').first;
      _descripcionController.text = planta.descripcion ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Plantas',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                decoration: InputDecoration(
                  labelText: 'Nombre de la Planta',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es requerido';
                  }
                  if (value.length < 3) {
                    return 'El nombre debe tener al menos 3 caracteres';
                  }
                  if (value.length > 50) {
                    return 'El nombre debe tener máximo 50 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Nombre cientifico de la Planta',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre cientifico es requerido';
                  }
                  if (value.length > 200) {
                    return 'El nombre cientifico debe tener máximo 200 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Rango de Plantas: ${widget.numeroPlantas}'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    for (int i = 0; i < widget.numeroPlantas; i++) {
                      int plantaId = widget.selectedPlantasIds[i];
                      Planta updatedPlanta = Planta(
                        idPlanta: plantaId,
                        nombrePlanta: '${_nombreController.text} ${i + 1}',
                        descripcion: _descripcionController.text,
                        fkidProyecto: widget.proyectoId,
                      );
                      int result = await PlantasRepository().update(plantaId, updatedPlanta);
                      bool success = result > 0;
                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al actualizar la planta con ID $plantaId'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Plantas actualizadas correctamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantaListView(
                          proyectoId: widget.proyectoId,
                          proyectoNombre: widget.proyectoNombre,
                          userRole: widget.userRole,
                          userName: widget.userName,
                          libroId: widget.libroId,
                          libroNombre: widget.libroNombre,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text('Guardar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
