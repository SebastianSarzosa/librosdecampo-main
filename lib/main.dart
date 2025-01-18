import 'package:flutter/material.dart';
import 'package:libroscampo/bienvenido.dart';
import 'package:libroscampo/menu.dart';
import 'package:libroscampo/settings/connectionService.dart';
import 'package:libroscampo/settings/supabase.dart';
import 'package:libroscampo/views/librosdecampo/libro_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Asegura que la inicialización de Flutter esté completa
  await SupabaseHelper.init(); //Inicializa Supabase
  // Verifica la conectividad y sincroniza los datos cuando haya conexión
  ConnectivityChecker connectivityChecker = ConnectivityChecker();
  await connectivityChecker.checkConnectivityAndSync(); // Llama a la función de verificación de conectividad
  // Comienza a escuchar los cambios de conectividad
  connectivityChecker.listenConnectivity();
  //SyncService().syncData(); // Sincroniza los datos
  runApp(MyApp()); //Inicia la aplicacion
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Aplicación Libros de campo",
      initialRoute: '/bienvenido',
      routes: {
        '/bienvenido':(context) => Bienvenido(),
        '/menu':(context) => Menu(),
        '/libro/index': (context) => LibroListView(),

      },
    );
  }
}