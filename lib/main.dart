import 'package:flutter/material.dart';
import 'package:libroscampo/bienvenido.dart';
import 'package:libroscampo/menu.dart';
import 'package:libroscampo/views/librosdecampo/libro_list.dart';
import 'package:libroscampo/views/login.dart';
import 'package:libroscampo/views/proyectos/proyecto_form.dart';
import 'package:libroscampo/views/proyectos/proyecto_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Aplicación Libros de campo",
      initialRoute: '/login',
      routes: {
        '/login':(context) => LoginCreate(),
        '/bienvenido':(context) => Bienvenido(),
        '/menu':(context) => Menu(),
        '/libro/index': (context) => LibroListView(),
        '/proyecto/index': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ProyectoListView(libroId: args['libroId']);
        },
        '/proyecto/form': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ProyectoFormView(libroId: args['libroId']);
        },             
      },
    );
  }
}