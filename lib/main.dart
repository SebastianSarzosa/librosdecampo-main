import 'package:flutter/material.dart';
import 'package:libroscampo/bienvenido.dart';
import 'package:libroscampo/menu.dart';

import 'package:libroscampo/views/librosdecampo/libro_list.dart';
import 'package:libroscampo/views/login.dart';

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

      },
    );
  }
}