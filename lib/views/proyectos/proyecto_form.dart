import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libroscampo/models/librosdecampo.dart';
import 'package:libroscampo/models/proyectos.dart';
import 'package:libroscampo/repositories/proyectos_repository.dart';
import 'package:libroscampo/repositories/librosdecampo_repository.dart'; // Importa el repositorio de libros
import 'package:libroscampo/views/proyectos/proyecto_list.dart';

class ProyectoFormView extends StatefulWidget {
  final int libroId; // Recibe el ID del libro seleccionado

  ProyectoFormView({required this.libroId});

  @override
  State<ProyectoFormView> createState() => _ProyectoFormViewState();
}

class _ProyectoFormViewState extends State<ProyectoFormView> {
  final _formProyectoKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _fechaInicioController = TextEditingController();
  final _fkidLibroController = TextEditingController();
  List<Librosdecampo> _libros = []; // Lista de libros

  @override
  void initState() {
    super.initState();
    _fkidLibroController.text = widget.libroId.toString(); // Establece el ID del libro por defecto
    _fechaInicioController.text = DateTime.now().toString().split(' ')[0]; // Establece la fecha actual por defecto
    _loadLibros(); // Cargar libros al iniciar
  }

  Future<void> _loadLibros() async {
    _libros = await LibrosRespository().list();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insertar Proyecto',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        
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
                readOnly: true, // Hace que el campo sea de solo lectura
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formProyectoKey.currentState!.validate()) {
                          Proyecto proyecto = Proyecto(
                            nombreProyecto: _nombreController.text,
                            descripcion: _descripcionController.text,
                            fechaInicio: _fechaInicioController.text,
                            fkidLibro: int.parse(_fkidLibroController.text),
                          );
                          var result = await ProyectosRepository().create(proyecto);
                          print('El ID del registro es: ' + result.toString());
                          if (result > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Proyecto agregado correctamente'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pushNamed(
                              context,
                              '/proyecto/index',
                              arguments: {'libroId': widget.libroId},
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al agregar el proyecto'),
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
                            builder: (context) => ProyectoListView(libroId: widget.libroId),
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