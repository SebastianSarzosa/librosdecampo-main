import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libroscampo/models/plantas.dart';
import 'package:libroscampo/repositories/plantas_repository.dart';
import 'package:libroscampo/views/plantas/planta_list.dart';

class PlantaFormView extends StatefulWidget {
  final int proyectoId;
  final int numeroPlantas;
  final String proyectoNombre;

  PlantaFormView({required this.proyectoId, required this.numeroPlantas,required this.proyectoNombre});

  @override
  State<PlantaFormView> createState() => _PlantaFormViewState();
}

class _PlantaFormViewState extends State<PlantaFormView> {
  final _formPlantaKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insertar Plantas',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      body: Padding(
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
              ElevatedButton(
                onPressed: () async {
                  if (_formPlantaKey.currentState!.validate()) {
                    for (int i = 0; i < widget.numeroPlantas; i++) {
                      Planta planta = Planta(
                        nombrePlanta: '${_nombreController.text} ${i + 1}',
                        descripcion: _descripcionController.text,
                        fkidProyecto: widget.proyectoId,
                      );
                      var result = await PlantasRepository().create(planta);
                      if (result <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al agregar la planta ${i + 1}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Plantas agregadas correctamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantaListView(proyectoId: widget.proyectoId,proyectoNombre: widget.proyectoNombre),
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