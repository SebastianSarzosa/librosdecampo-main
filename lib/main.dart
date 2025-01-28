import 'package:flutter/material.dart';
import 'package:libroscampo/bienvenido.dart';
import 'package:libroscampo/views/librosdecampo/libro_list.dart';
import 'package:libroscampo/views/login.dart';
import 'package:libroscampo/views/proyectos/proyecto_form.dart';
import 'package:libroscampo/views/proyectos/proyecto_list.dart';
import 'package:libroscampo/views/plantas/planta_form.dart';
import 'package:libroscampo/views/plantas/planta_list.dart';
import 'package:libroscampo/views/plantas/numeroplantas.dart';
import 'package:libroscampo/views/controles/controles_form.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Aplicación Libros de campo",
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginCreate(),
        '/bienvenido': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return Bienvenido(userRole: args['userRole'] , userName: args['userName']);
        },
        '/libro/index': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return LibroListView(userRole: args['userRole'], userName: args['userName']);
        },
        '/proyecto/index': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ProyectoListView(libroId: args['libroId'], libroNombre: args['libroNombre'], userRole: args['userRole'],userName: args['userName']);
        },
        '/proyecto/form': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ProyectoFormView(libroId: args['libroId'],libroNombre: args['libroNombre'], userRole: args['userRole'],userName: args['userName']);
        },
        '/planta/index': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return PlantaListView(proyectoId: args['proyectoId'], proyectoNombre: args['proyectoNombre'], userRole: args['userRole'],userName: args['userName'],  libroId: args['libroId'], libroNombre: args['libroNombre']);
        },
        '/planta/form': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return PlantaFormView(proyectoId: args['proyectoId'], numeroPlantas: args['numeroPlantas'], proyectoNombre: args['proyectoNombre'], userRole: args['userRole'],userName: args['userName'], libroId: args['libroId'], libroNombre: args['libroNombre']);
        },
        '/planta/numero': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return NumeroPlantasForm(proyectoId: args['proyectoId'], proyectoNombre: args['proyectoNombre'], userRole: args['userRole'],userName: args['userName'], libroId: args['libroId'], libroNombre: args['libroNombre']);
        },
        '/control/form': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ControlFormView(
            proyectoId: args['proyectoId'],
            proyectoNombre: args['proyectoNombre'],
            userRole: args['userRole'],
            userName: args['userName'],
            libroId: args['libroId'],
            libroNombre: args['libroNombre'],
          );
        },
      },
    );
  }
}
