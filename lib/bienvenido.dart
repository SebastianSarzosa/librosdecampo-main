import 'package:flutter/material.dart';

class Bienvenido extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BIENVENIDOS',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.green
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            child: Text('Bienvenidos a la aplicación de libros de campo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Text('En esta aplicación podrá llevar el control de los libros de campo de su empresa',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Text('Para comenzar, presione el botón de menú en la esquina superior izquierda',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ), 
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Libros de campo'
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Color.fromARGB(255, 6, 67, 146),
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, ModalRoute.withName('/bienvenido')); 
          } else if (index == 1) {
            Navigator.pushNamed(context, '/libro/index'); 
          }
        },
      ),
    );
    
  }
  
}