import 'package:flutter/material.dart';
import 'package:libroscampo/models/controles.dart';
import 'package:libroscampo/models/plantas.dart';
import 'package:libroscampo/models/variables.dart';
import 'package:libroscampo/repositories/controles_repository.dart';
import 'package:libroscampo/repositories/plantas_repository.dart';
import 'package:libroscampo/repositories/variables_repository.dart';

class ControlFormView extends StatefulWidget {
  final int proyectoId;
  final String proyectoNombre;
  final String userRole;
  final String userName;
  final int libroId;
  final String libroNombre;

  ControlFormView({
    required this.proyectoId, required this.proyectoNombre, required this.userRole, required this.userName, required this.libroId, required this.libroNombre
  });

  @override
  State<ControlFormView> createState() => _ControlFormViewState();
}

class _ControlFormViewState extends State<ControlFormView> {
  final _formControlKey = GlobalKey<FormState>();
  final _controlNombreController = TextEditingController();
  final _fechaControlController = TextEditingController(text: DateTime.now().toString().split(' ')[0]); // Establece la fecha actual por defecto
  final List<int> _selectedPlantas = [];
  final PlantasRepository plantasRepository = PlantasRepository();
  final VariablesRepository variablesRepository = VariablesRepository();
  final Map<int, List<Variable>> _plantVariables = {};
  final Map<int, List<Variable>> _newVariables = {};
  bool selectAll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Control',
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
      body: FutureBuilder<List<Planta>>(
        future: plantasRepository.listPlantsByProject(widget.proyectoId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay plantas disponibles', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)));
          }

          final plantas = snapshot.data!;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formControlKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _controlNombreController,
                        decoration: InputDecoration(
                          labelText: 'Nombre del Control',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El nombre del control es requerido';
                          }
                          if (value.length > 100) {
                            return 'El nombre del control no puede exceder los 100 caracteres';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _fechaControlController,
                        decoration: InputDecoration(
                          labelText: 'Fecha de Inicio del Control',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                        
                      ),
                      SizedBox(height: 5),
                      Text('Selecciona las plantas:'),
                      CheckboxListTile(
                        title: Text("Seleccionar todas"),
                        value: selectAll,
                        onChanged: (bool? value) {
                          setState(() {
                            selectAll = value ?? false;
                            if (selectAll) {
                              _selectedPlantas.clear();
                              _selectedPlantas.addAll(plantas.map((planta) => planta.idPlanta!));
                              _plantVariables.clear();
                              _newVariables.clear();
                              plantas.forEach((planta) async {
                                final variables = await variablesRepository.listVariablesByFirstControlOfPlant(planta.idPlanta!);
                                setState(() {
                                  _plantVariables[planta.idPlanta!] = variables;
                                  _newVariables[planta.idPlanta!] = variables.map((variable) {
                                    return Variable(
                                      nombreVariable: variable.nombreVariable,
                                      valorTexto: '',
                                      valorNumerico: null,
                                      valorFecha: null,
                                      fkidControl: 0,
                                    );
                                  }).toList();
                                });
                              });
                            } else {
                              _selectedPlantas.clear();
                              _plantVariables.clear();
                              _newVariables.clear();
                            }
                          });
                        },
                      ),
                      Text(
                        "Plantas seleccionadas: ${_selectedPlantas.length}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: plantas.map((planta) {
                      return CheckboxListTile(
                        title: Text(planta.nombrePlanta),
                        value: _selectedPlantas.contains(planta.idPlanta),
                        onChanged: (bool? value) async {
                          setState(() {
                            if (value == true) {
                              _selectedPlantas.add(planta.idPlanta!);
                            } else {
                              _selectedPlantas.remove(planta.idPlanta);
                              _plantVariables.remove(planta.idPlanta);
                              _newVariables.remove(planta.idPlanta);
                            }
                            selectAll = _selectedPlantas.length == plantas.length;
                          });
                          if (value == true) {
                            final variables = await variablesRepository.listVariablesByFirstControlOfPlant(planta.idPlanta!);
                            setState(() {
                              _plantVariables[planta.idPlanta!] = variables;
                              _newVariables[planta.idPlanta!] = variables.map((variable) {
                                return Variable(
                                  nombreVariable: variable.nombreVariable,
                                  valorTexto: '',
                                  valorNumerico: null,
                                  valorFecha: null,
                                  fkidControl: 0,
                                );
                              }).toList();
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formControlKey.currentState!.validate()) {
                      for (int plantaId in _selectedPlantas) {
                        Control control = Control(
                          fkidPlanta: plantaId,
                          nombreControl: _controlNombreController.text,
                          fechaControl: _fechaControlController.text,
                        );
                        var controlId = await ControlesRepository().create(control);
                        if (controlId <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al agregar el control para la planta $plantaId'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final newVariables = _newVariables[plantaId] ?? [];
                        for (Variable variable in newVariables) {
                          variable.fkidControl = controlId;
                          await variablesRepository.create(variable);
                        }
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Control creado correctamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text('Aceptar', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
