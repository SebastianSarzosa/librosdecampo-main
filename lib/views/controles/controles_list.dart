import 'package:flutter/material.dart';
import 'package:libroscampo/models/controles.dart';
import 'package:libroscampo/repositories/controles_repository.dart';
import 'package:libroscampo/views/dashboardPlanta.dart';
import 'package:libroscampo/views/variables/variable_list.dart';
import 'package:libroscampo/views/controles/controles_edit.dart'; // Importar la vista de edición
import 'package:libroscampo/models/plantas.dart'; // Importar el modelo Planta
import 'package:libroscampo/repositories/plantas_repository.dart'; // Importar PlantasRepository

class ControlesListView extends StatefulWidget {
  final int plantaId;
  final int proyectoId;
  final String proyectoNombre;
  final String userRole;
  final String userName;   // Asegúrate de que este campo sea final
  final int libroId; // Añade el campo libroId
  final String libroNombre;

   ControlesListView({
     required this.plantaId, required this.proyectoId, 
     required this.proyectoNombre,  required this.userRole, 
     required this.userName, required this.libroId, 
     required this.libroNombre
     });

  @override
  _ControlesListViewState createState() => _ControlesListViewState();
}

class _ControlesListViewState extends State<ControlesListView> {
  final ControlesRepository controlesRepository = ControlesRepository();
  late Future<List<Control>> _controlesFuture;

  @override
  void initState() {
    super.initState();
    _controlesFuture = controlesRepository.listControlsByPlant(widget.plantaId);
  }

  void _refreshControls() {
    setState(() {
      _controlesFuture = controlesRepository.listControlsByPlant(widget.plantaId);
    });
  }

  void _deleteControl(int controlId) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              
            ],
          ),
          content: Text(
            '¿Está seguro de que desea eliminar este control? Una vez eliminado, no se podrán recuperar los datos.',
            style: TextStyle(color:  Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Sí', style: TextStyle(color: Colors.green[600])),
            ),
          ],
        );
      },
    );

    if (confirm) {
      await controlesRepository.delete(controlId);
      _refreshControls();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Control eliminado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Control de Plantas",
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
      body: FutureBuilder<List<Control>>(
        future: _controlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay controles disponibles', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)));
          }

          final controles = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: controles.length,
            itemBuilder: (context, index) {
              final control = controles[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  leading: Icon(Icons.check_circle, size: 40, color: Colors.teal),
                  title: Text(
                    control.nombreControl, // Asegúrate de que este campo se muestre correctamente
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  subtitle: Text(
                    'Fecha de inicio: ${control.fechaControl}\nID: ${control.idControl}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.userRole == 'admin') // Mostrar el icono de edición solo si el rol es admin
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.teal),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditControlView(
                                  controlId: control.idControl!,
                                  userRole: widget.userRole,
                                  userName: widget.userName,
                                  libroId: widget.libroId,
                                  libroNombre: widget.libroNombre,
                                  proyectoId: widget.proyectoId,
                                  proyectoNombre: widget.proyectoNombre,
                                ),
                              ),
                            );
                            _refreshControls();
                          },
                        ),
                      if (widget.userRole == 'admin') // Mostrar el icono de eliminación solo si el rol es admin
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteControl(control.idControl!);
                          },
                        ),
                      Icon(Icons.arrow_forward_ios, color: Colors.teal),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VariablesListView(
                          controlId: control.idControl!,
                          userRole: widget.userRole,
                          userName: widget.userName,
                          libroId: widget.libroId,
                          libroNombre: widget.libroNombre,
                          proyectoId: widget.proyectoId,
                          proyectoNombre: widget.proyectoNombre,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardPlantaView(
                plantaId: widget.plantaId,
                proyectoId: widget.proyectoId,
                proyectoNombre: widget.proyectoNombre,
                userRole: widget.userRole,
                userName: widget.userName,
                libroId: widget.libroId,
                libroNombre: widget.libroNombre,
              ),
            ),
          );
        },
        child: Icon(Icons.dashboard, color: Colors.white),
        backgroundColor: Colors.green,
      ),
    );
  }
}