import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libroscampo/models/proyectos.dart';
import 'package:libroscampo/repositories/proyectos_repository.dart';

class ProyectoEditView extends StatefulWidget {
  final int libroId; // Recibe el ID del libro seleccionado
  final String libroNombre; // Recibe el nombre del libro seleccionado
  final Proyecto proyecto;
  final String userRole; // Recibe el rol del usuario
  final String userName; // Añade el campo userName

  ProyectoEditView({
    required this.proyecto, required this.userRole, required this.userName,
    required this.libroId, required this.libroNombre,
    });

  @override
  State<ProyectoEditView> createState() => _ProyectoEditViewState();
}

class _ProyectoEditViewState extends State<ProyectoEditView> {
  final _formProyectoKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _fechaInicioController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.proyecto.nombreProyecto);
    _descripcionController = TextEditingController(text: widget.proyecto.descripcion);
    _fechaInicioController = TextEditingController(text: widget.proyecto.fechaInicio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Proyecto',
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
                'libroId': widget.proyecto.fkidLibro,
                'libroNombre': widget.libroNombre,
                'userRole': widget.userRole,
                'userName': widget.userName,
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formProyectoKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: _nombreController,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                decoration: InputDecoration(
                  labelText: 'Nombre del Proyecto',
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
                  labelText: 'Descripción del Proyecto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción es requerida';
                  }
                  if (value.length > 200) {
                    return 'La descripción debe tener máximo 200 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _fechaInicioController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Inicio',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime now = DateTime.now();
                  DateTime threeDaysAgo = now.subtract(Duration(days: 3));
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: threeDaysAgo,
                    lastDate: now,
                  );
                  if (pickedDate != null) {
                    String formattedDate = pickedDate.toString().split(' ')[0];
                    setState(() {
                      _fechaInicioController.text = formattedDate;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La fecha de inicio es requerida';
                  }
                  return null;
                },
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formProyectoKey.currentState!.validate()) {
                          Proyecto proyecto = Proyecto(
                            idProyecto: widget.proyecto.idProyecto,
                            nombreProyecto: _nombreController.text,
                            descripcion: _descripcionController.text,
                            fechaInicio: _fechaInicioController.text,
                            fkidLibro: widget.proyecto.fkidLibro,
                          );
                          bool result = false;
                          if (widget.proyecto.idProyecto != null) {
                            result = await ProyectosRepository().update(widget.proyecto.idProyecto!, proyecto) > 0;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('ID del proyecto no puede ser nulo'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          if (result) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Proyecto actualizado correctamente'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pushReplacementNamed(
                              context,
                              '/proyecto/index',
                              arguments: {
                                'libroId': widget.proyecto.fkidLibro,
                                'libroNombre': widget.libroNombre,
                                'userRole': widget.userRole,
                                'userName': widget.userName,
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al actualizar el proyecto'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('Guardar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 25),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/proyecto/index',
                          arguments: {
                            'libroId': widget.proyecto.fkidLibro,
                            'libroNombre': widget.libroNombre,
                            'userRole': widget.userRole,
                            'userName': widget.userName,
                          },
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
