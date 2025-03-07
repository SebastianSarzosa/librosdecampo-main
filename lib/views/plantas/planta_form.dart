import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libroscampo/models/plantas.dart';
import 'package:libroscampo/models/controles.dart';
import 'package:libroscampo/models/variables.dart';
import 'package:libroscampo/repositories/plantas_repository.dart';
import 'package:libroscampo/repositories/controles_repository.dart';
import 'package:libroscampo/repositories/variables_repository.dart';
import 'package:libroscampo/views/plantas/planta_list.dart';

class PlantaFormView extends StatefulWidget {
  final int proyectoId;
  final int numeroPlantas;
  final String proyectoNombre;
  final String userRole; // Asegúrate de que este campo sea final
  final String userName; // Añade el campo userName
  final int libroId; // Añade el campo libroId
  final String libroNombre; // Añade el campo libroNombre
  
  PlantaFormView({
    required this.proyectoId, required this.numeroPlantas,required this.proyectoNombre,required this.userRole,required this.userName,required this.libroId,required this.libroNombre
  });

  @override
  State<PlantaFormView> createState() => _PlantaFormViewState();
}

class _PlantaFormViewState extends State<PlantaFormView> {
  final _formPlantaKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _controlNombreController = TextEditingController();
  final _fechaControlController = TextEditingController(text: DateTime.now().toString().split(' ')[0]); // Establece la fecha actual por defecto
  final List<String> _variables = ['Altura', 'Color de hoja', 'Cantidad de Saponinas', 'Cantidad de agua'];
  final List<String> _selectedVariables = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insertar Plantas',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/planta/index',
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
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formPlantaKey,
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
              SizedBox(height: 20),
              Text('Selecciona las variables:'),
              ..._variables.map((variable) {
                return CheckboxListTile(
                  title: Text(variable),
                  value: _selectedVariables.contains(variable),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedVariables.add(variable);
                      } else {
                        _selectedVariables.remove(variable);
                      }
                      
                    });
                  },
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formPlantaKey.currentState!.validate()) {
                    for (int i = 0; i < widget.numeroPlantas; i++) {
                      Planta planta = Planta(
                        nombrePlanta: '${_nombreController.text} ${i + 1}',
                        descripcion: _descripcionController.text,
                        fkidProyecto: widget.proyectoId,
                      );
                      var plantaId = await PlantasRepository().create(planta);
                      if (plantaId <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al agregar la planta ${i + 1}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      Control control = Control(
                        fkidPlanta: plantaId,
                        nombreControl: _controlNombreController.text, // Asegúrate de que este campo no sea nulo
                        descripcion: _controlNombreController.text,
                        fechaControl: _fechaControlController.text,
                      );
                      var controlId = await ControlesRepository().create(control);
                      if (controlId <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al agregar el control para la planta ${i + 1}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      for (String variable in _selectedVariables) {
                        Variable newVariable = Variable(
                          nombreVariable: variable,
                          fkidControl: controlId,
                        );
                        var variableId = await VariablesRepository().create(newVariable);
                        if (variableId <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al agregar la variable $variable para la planta ${i + 1}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                      }
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Plantas, controles y variables agregadas correctamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantaListView(
                          proyectoId: widget.proyectoId,
                          proyectoNombre: widget.proyectoNombre, 
                          userRole:widget.userRole , 
                          userName: widget.userName, 
                          libroId: widget.libroId, 
                          libroNombre: widget.libroNombre),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text('Aceptar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}