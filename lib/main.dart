import 'package:flutter/material.dart';
import 'package:libroscampo/bienvenido.dart';
import 'package:libroscampo/views/librosdecampo/libro_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Aplicación Libros de campo",
      initialRoute: '/bienvenido',
      routes: {
        '/bienvenido':(context) => Bienvenido(),
        '/libro/index': (context) => LibroListView(),

      },
    );
  }
}