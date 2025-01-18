import 'package:connectivity_plus/connectivity_plus.dart';
import 'syncService.dart';

class ConnectivityChecker {
  final SyncService syncService = SyncService();

  // Verifica la conectividad inicial y realiza la sincronización si hay conexión
  Future<void> checkConnectivityAndSync() async {
    // Obtiene el estado actual de la conectividad
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();

    // Verifica el tipo de conexión y realiza la sincronización si hay conexión
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      print('Conexión a Internet detectada');
      await syncService.syncData();  // Llama a la función de sincronización
    } else {
      print('No hay conexión a Internet');
    }
  }

  // Escucha los cambios de conectividad en tiempo real
  void listenConnectivity() {
    // Escucha los cambios de conectividad y verifica el estado
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        print('Conexión disponible');
        await syncService.syncData();  // Llama a la función de sincronización
      } else {
        print('Sin conexión');
      }
    });
  }
}
