import 'package:flutter/material.dart';
import 'package:libroscampo/models/variables.dart';
import 'package:libroscampo/repositories/variables_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'variable_detail_view.dart';
import 'image_view_screen.dart';

class VariablesListView extends StatefulWidget {
  final int controlId;
  final int proyectoId;
  final String proyectoNombre;
  final String userRole;
  final String userName;
  final int libroId;
  final String libroNombre;
  final Function()? onDataUpdated;

  const VariablesListView({
    required this.controlId,
    required this.userRole,
    required this.userName,
    required this.libroId,
    required this.libroNombre,
    required this.proyectoId,
    required this.proyectoNombre,
    this.onDataUpdated,
  });

  @override
  _VariablesListViewState createState() => _VariablesListViewState();
}

class _VariablesListViewState extends State<VariablesListView> {
  late Future<List<Variable>> _variablesFuture;
  XFile? _imageFile;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _variablesFuture = VariablesRepository().listVariablesByControl(widget.controlId);
    _loadImage();
  }

  void _refreshVariables() {
    setState(() {
      _variablesFuture = VariablesRepository().listVariablesByControl(widget.controlId);
    });
  }

  Future<void> _loadImage() async {
    final existingVariable = await VariablesRepository().getVariableByControlAndName(widget.controlId, 'Foto');
    if (existingVariable != null && existingVariable.imagePath != null) {
      setState(() {
        _imageFile = XFile(existingVariable.imagePath!);
      });
    }
  }

  void _viewImage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewScreen(
          controlId: widget.controlId,
          imageFile: _imageFile,
          onImageTaken: (XFile image) {
            setState(() {
              _imageFile = image;
            });
            _saveImagePath(image.path);
          },
          userRole: widget.userRole,
        ),
      ),
    );
  }

  Future<void> _saveImagePath(String path) async {
    final existingVariable = await VariablesRepository().getVariableByControlAndName(widget.controlId, 'Foto');
    if (existingVariable != null) {
      existingVariable.imagePath = path;
      await VariablesRepository().update(existingVariable.idVariable!, existingVariable);
    } else {
      final nuevaVariable = Variable(
        nombreVariable: 'Foto',
        valorTexto: null,
        valorNumerico: null,
        valorFecha: null,
        fkidControl: widget.controlId,
        imagePath: path,
      );
      await VariablesRepository().create(nuevaVariable);
    }
    _refreshVariables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Variables del Control",
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // Indicar que se debe refrescar el dashboard
          },
        ),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _viewImage,
                    child: const Text('Ver Foto'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Variable>>(
              future: _variablesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay variables disponibles', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)));
                }

                final variables = snapshot.data!.where((variable) => variable.nombreVariable != 'Foto').toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: variables.length,
                  itemBuilder: (context, index) {
                    final variable = variables[index];
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        leading: Icon(Icons.label, size: 40, color: Colors.teal),
                        title: Text(
                          variable.nombreVariable,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Valor: ${variable.valorTexto ?? variable.valorNumerico?.toString() ?? variable.valorFecha}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        trailing: (widget.userRole == 'admin' || widget.userRole == 'editor')
                            ? Icon(Icons.edit, color: Colors.teal)
                            : null,
                        onTap: (widget.userRole == 'admin' || widget.userRole == 'editor')
                            ? () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VariableDetailView(variable: variable),
                                  ),
                                );
                                if (result == true) {
                                  _refreshVariables();
                                }
                              }
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}