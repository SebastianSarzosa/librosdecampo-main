import 'package:flutter/material.dart';
import 'package:libroscampo/views/librosdecampo/libro_list.dart'; // Asegúrate de importar la vista de lista de libros

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'BIENVENIDO $userName',
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LibroListView(userRole: userRole), // Pasa el userRole aquí
              ),
            ); // Ir a la pantalla de la lista de libros
          }
        },
      ),
    );
  }
}