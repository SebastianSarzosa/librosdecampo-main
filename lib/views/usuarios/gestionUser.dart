import 'package:flutter/material.dart';
import 'package:libroscampo/repositories/registro_repository.dart';
import 'package:libroscampo/models/registroUsuarios.dart';

class GestionUser extends StatefulWidget {
  final String userRole; // Añade el campo userRole
  final String userName; // Añade el campo userName

  GestionUser({required this.userRole, required this.userName});

  @override
  State<GestionUser> createState() => _GestionUserState();
}

class _GestionUserState extends State<GestionUser> {
  late Future<List<RegistroUsuario>> usuarios;

  @override
  void initState() {
    super.initState();
    usuarios = RegistroUsuarioRepository().listAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<RegistroUsuario>>(
        future: usuarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar usuarios'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay usuarios registrados'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final usuario = snapshot.data![index];
                return ListTile(
                  title: Text(usuario.nombreUsuario),
                  subtitle: Text('Rol: ${usuario.rolUsuario}'),
                  trailing: DropdownButton<String>(
                    value: usuario.rolUsuario,
                    items: <String>['admin', 'visor', 'editor']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      if (newValue != null) {
                        setState(() {
                          usuario.rolUsuario = newValue;
                        });
                        await RegistroUsuarioRepository().updateUserRole(usuario.nombreUsuario, newValue);
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
