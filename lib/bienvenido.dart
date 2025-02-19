import 'package:flutter/material.dart';

class Bienvenido extends StatelessWidget {
  final String userRole; // Añade el campo userRole
  final String userName; // Añade el campo userName

  Bienvenido({required this.userRole, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PLANT'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false); // Ir a la pantalla de inicio de sesión
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bienvenido $userName',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Image.asset(
              'assets/images/inicio/area.jpg',
              height: 200,
            ),
            const SizedBox(height: 16),
            const Text(
              'FORTALECIMIENTO DE CAPACIDADES\nPRODUCTIVAS VITRINAS TECNOLOGICAS\nUTC-INIAP-KOPIA',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            if (userRole == 'admin')
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/gestionUsuario', arguments: {'userRole': userRole, 'userName': userName}); // Ir a la lista de libros
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Gestionar Usuarios',style: TextStyle(color: Colors.white),),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Libros de Campo',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.green,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, ModalRoute.withName('/bienvenido')); // Ir a la pantalla de inicio
          } else if (index == 1) {
            Navigator.pushNamed(context, '/dashboard/index', arguments: {'userRole': userRole, 'userName': userName}); // Ir a dashboard
          } else if (index == 2) {
            Navigator.pushNamed(context, '/libro/index',arguments: {'userRole': userRole, 'userName': userName}); // Ir a la lista de libros
          }
        },
      ),
    );
  }
}