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
    );
  }
}