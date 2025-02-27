import 'package:libroscampo/models/plantas.dart';
import 'package:libroscampo/settings/db.connection.dart';

class PlantasRepository {
  final String tableName = 'Plantas';

  // Método para crear una nueva planta
  Future<int> create(Planta planta) async {
    return await DbConnection.insert(tableName, planta.toMap());
  }

  // Método para listar todas las plantas
  Future<List<Map<String, dynamic>>> listAllPlants() async {
    return await DbConnection.list(tableName);
  }

  // Método para listar plantas por ID de proyecto
  Future<List<Planta>> listPlantsByProject(int projectId) async {
    final List<Map<String, dynamic>> maps = await DbConnection.filter(tableName, 'fkid_proyecto = ?', [projectId]);
    return List.generate(maps.length, (i) {
      return Planta.fromMap(maps[i]);
    });
  }

  // Método para eliminar una planta por ID
  Future<int> delete(int id) async {
    return await DbConnection.delete(tableName, id);
  }

  // Método para actualizar una planta por ID
  Future<int> update(int id, Planta planta) async {
    return await DbConnection.updatePlanta(tableName, planta.toMap(), id);
  }
}