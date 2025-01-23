import 'package:flutter/material.dart';
import 'package:libroscampo/views/plantas/planta_form.dart';

class NumeroPlantasForm extends StatefulWidget {
  final int proyectoId;

  NumeroPlantasForm({required this.proyectoId});

  @override
  _NumeroPlantasFormState createState() => _NumeroPlantasFormState();
}

class _NumeroPlantasFormState extends State<NumeroPlantasForm> {
  final _formKey = GlobalKey<FormState>();
  final _numeroController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Número de Plantas',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _numeroController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número de Plantas',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un número';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    int numeroPlantas = int.parse(_numeroController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantaFormView(
                          proyectoId: widget.proyectoId,
                          numeroPlantas: numeroPlantas,
                        ),
                      ),
                    );
                  }
                },
                child: Text('Aceptar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}