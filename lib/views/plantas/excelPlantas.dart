import 'package:flutter/material.dart';
import 'package:excel/excel.dart'; // Asegúrate de usar la última versión del paquete
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:libroscampo/models/plantas.dart';
import 'package:libroscampo/repositories/plantas_repository.dart';
import 'package:libroscampo/repositories/controles_repository.dart';
import 'package:libroscampo/repositories/variables_repository.dart';

class ExportarExcelScreen extends StatefulWidget {
  final int proyectoId;
  final String proyectoNombre;
  final String userRole;
  final String userName;
  final int libroId;
  final String libroNombre;

  ExportarExcelScreen({
    required this.proyectoId,
    required this.proyectoNombre,
    required this.userRole,
    required this.userName,
    required this.libroId,
    required this.libroNombre,
  });

  @override
  _ExportarExcelScreenState createState() => _ExportarExcelScreenState();
}

class _ExportarExcelScreenState extends State<ExportarExcelScreen> {
  final PlantasRepository plantasRepository = PlantasRepository();
  final ControlesRepository controlesRepository = ControlesRepository();
  final VariablesRepository variablesRepository = VariablesRepository();
  List<Planta> selectedPlantas = [];
  List<Planta> plantasList = [];
  bool selectAll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exportar a Excel"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Planta>>(
        future: plantasRepository.listPlantsByProject(widget.proyectoId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay plantas disponibles', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)));
          }

          plantasList = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Selecciona las plantas:'),
                CheckboxListTile(
                  title: Text("Seleccionar todas"),
                  value: selectAll,
                  onChanged: (bool? value) {
                    setState(() {
                      selectAll = value ?? false;
                      if (selectAll) {
                        selectedPlantas = List.from(plantasList);
                      } else {
                        selectedPlantas.clear();
                      }
                    });
                  },
                ),
                Expanded(
                  child: ListView(
                    children: plantasList.map((planta) {
                      return CheckboxListTile(
                        title: Text("${planta.nombrePlanta}, ${planta.descripcion}"),
                        value: selectedPlantas.any((p) => p.idPlanta == planta.idPlanta),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedPlantas.add(planta);
                            } else {
                              selectedPlantas.removeWhere((p) => p.idPlanta == planta.idPlanta);
                            }
                            selectAll = selectedPlantas.length == plantasList.length;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                Text(
                  "Plantas seleccionadas: ${selectedPlantas.length}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () async {
                    List<List<dynamic>> data = [
                      ["Nombre", "Nombre Cientifico", "Control", "Variable", "Valor"],
                    ];

                    for (var planta in selectedPlantas) {
                      final controles = await controlesRepository.listControlsByPlant(planta.idPlanta!);
                      for (var control in controles) {
                        final variables = await variablesRepository.listVariablesByControl(control.idControl!);
                        for (var variable in variables) {
                          data.add([
                            planta.nombrePlanta,
                            planta.descripcion,
                            control.nombreControl,
                            variable.nombreVariable,
                            variable.valorTexto ?? variable.valorNumerico ?? variable.valorFecha?.toIso8601String() ?? ''
                          ]);
                        }
                      }
                    }

                    bool success = await ExcelExporter.exportToExcel(data, "plantas_controles_variables.xlsx");
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Datos exportados a Excel"),
                        backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error al exportar datos"),
                        backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text("Exportar a Excel", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ExcelExporter {
  // Método estático para exportar datos a un archivo Excel
  static Future<bool> exportToExcel(List<List<dynamic>> data, String fileName) async {
    try {
      // Crear un nuevo archivo Excel
      var excel = Excel.createExcel();
      var sheet = excel['Sheet1'];

      // Agregar los datos a la hoja de cálculo
      for (var i = 0; i < data.length; i++) {
        for (var j = 0; j < data[i].length; j++) {
          // Convertir el valor a un tipo CellValue adecuado
          var cellValue = data[i][j];
          if (cellValue is String) {
            sheet.cell(CellIndex.indexByString("${String.fromCharCode(65 + j)}${i + 1}")).value = cellValue;
          } else if (cellValue is int || cellValue is double) {
            sheet.cell(CellIndex.indexByString("${String.fromCharCode(65 + j)}${i + 1}")).value = cellValue;
          } else {
            // Manejar otros tipos de datos si es necesario
            sheet.cell(CellIndex.indexByString("${String.fromCharCode(65 + j)}${i + 1}")).value = cellValue.toString();
          }
        }
      }

      // Obtener el directorio de documentos
      Directory directory = await getApplicationDocumentsDirectory();
      String path = join(directory.path, fileName);

      // Guardar el archivo Excel
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
}