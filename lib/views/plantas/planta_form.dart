import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libroscampo/models/plantas.dart';
import 'package:libroscampo/repositories/plantas_repository.dart';
import 'package:libroscampo/views/plantas/planta_list.dart';

class PlantaFormView extends StatefulWidget {
  final int proyectoId;

  PlantaFormView({required this.proyectoId});

  @override
  State<PlantaFormView> createState() => _PlantaFormViewState();
}

class _PlantaFormViewState extends State<PlantaFormView> {
  final _formPlantaKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _fkidProyectoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fkidProyectoController.text = widget.proyectoId.toString(); // Establece el ID del proyecto por defecto
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insertar Planta',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formPlantaKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
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
                    return 'El nombre cientifico es requerida';
                  }
                  if (value.length > 200) {
                    return 'El nombre cientifico debe tener máximo 200 caracteres';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 20),
              TextFormField(
                controller: _fkidProyectoController,
                decoration: InputDecoration(
                  labelText: 'ID del Proyecto',
                  border: OutlineInputBorder(),
                ),
                readOnly: true, // Hace que el campo sea de solo lectura
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formPlantaKey.currentState!.validate()) {
                          Planta planta = Planta(
                            nombrePlanta: _nombreController.text,
                            descripcion: _descripcionController.text,
                            fkidProyecto: widget.proyectoId,

                          );
                          var result = await PlantasRepository().create(planta);
                          print('El ID del registro es: ' + result.toString());
                          if (result > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Planta agregada correctamente'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlantaListView(proyectoId: widget.proyectoId),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al agregar la planta'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('Aceptar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 25),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlantaListView(proyectoId: widget.proyectoId),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('Cancelar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
