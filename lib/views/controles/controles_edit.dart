import 'package:flutter/material.dart';
import 'package:libroscampo/models/controles.dart';
import 'package:libroscampo/repositories/controles_repository.dart';

class EditControlView extends StatefulWidget {
  final int controlId;
  final String userRole;
  final String userName;
  final int libroId;
  final String libroNombre;
  final int proyectoId;
  final String proyectoNombre;

  EditControlView({
    required this.controlId,
    required this.userRole,
    required this.userName,
    required this.libroId,
    required this.libroNombre,
    required this.proyectoId,
    required this.proyectoNombre,
  });

  @override
  _EditControlViewState createState() => _EditControlViewState();
}

class _EditControlViewState extends State<EditControlView> {
  final _formKey = GlobalKey<FormState>();
  final _controlNombreController = TextEditingController();
  final _fechaControlController = TextEditingController();
  late Control _control;

  @override
  void initState() {
    super.initState();
    _loadControl();
  }

  Future<void> _loadControl() async {
    _control = await ControlesRepository().getControlById(widget.controlId);
    setState(() {
      _controlNombreController.text = _control.nombreControl;
      _fechaControlController.text = _control.fechaControl ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Control'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _control.nombreControl = _controlNombreController.text;
                    await ControlesRepository().updateControl(_control.idControl!, _control);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Control actualizado correctamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context, true); // Regresa a la vista anterior y refresca la lista
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
