import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ExportarExcelScreen extends StatefulWidget {
  @override
  _ExportarExcelScreenState createState() => _ExportarExcelScreenState();
}

class _ExportarExcelScreenState extends State<ExportarExcelScreen> {
  final List<List<dynamic>> data = [
    ["Nombre", "Edad", "Ciudad"],
    ["Juan", 25, "Madrid"],
    ["Ana", 30, "Barcelona"],
    ["Luis", 22, "Valencia"],
  ];

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exportar a Excel"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index].join(", ")),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (await _requestStoragePermission()) {
                  bool success = await ExcelExporter.exportToExcel(data, "datos.xlsx");
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Datos exportados a Excel")),
                    );
                    _showNotification();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error al exportar datos")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Permiso de almacenamiento denegado")),
                  );
                }
              },
              child: Text("Exportar a Excel"),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Exportación Completa',
      'El archivo Excel se ha guardado en la carpeta de descargas.',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}

class ExcelExporter {
  static Future<bool> exportToExcel(List<List<dynamic>> data, String fileName) async {
    try {
      // Crear un nuevo archivo Excel
      var excel = Excel.createExcel();
      var sheet = excel['Sheet1'];

      // Agregar los datos a la hoja de cálculo
      for (var i = 0; i < data.length; i++) {
        for (var j = 0; j < data[i].length; j++) {
          sheet.cell(CellIndex.indexByString("${String.fromCharCode(65 + j)}${i + 1}")).value = data[i][j];
        }
      }

      // Obtener la carpeta de descargas pública
      Directory? downloadsDir = await _getDownloadsDirectory();
      if (downloadsDir == null) {
        print("No se pudo acceder a la carpeta de descargas");
        return false;
      }

      // Guardar el archivo Excel en la carpeta de descargas
      String path = join(downloadsDir.path, fileName);
      File file = File(path);
      file.createSync(recursive: true);
      file.writeAsBytesSync(excel.encode()!);

      print("Archivo guardado en: $path");
      return true; // Éxito
    } catch (e) {
      print("Error al exportar a Excel: $e");
      return false; // Fallo
    }
  }

  static Future<Directory?> _getDownloadsDirectory() async {
    // Ruta de la carpeta de descargas en Android
    return Directory("/storage/emulated/0/Download");
  }
}
