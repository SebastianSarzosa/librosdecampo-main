import 'package:libroscampo/models/controles.dart';
import 'package:libroscampo/settings/db.connection.dart';

class ControlesRepository {
  final String tableName = 'Controles';

  // Método para crear un nuevo control
  Future<int> create(Control control) async {
    return await DbConnection.insert(tableName, control.toMap());
  }

  // Método para listar todos los controles
  Future<List<Map<String, dynamic>>> listAllControls() async {
    return await DbConnection.list(tableName);
  }

  // Método para listar controles por ID de planta
  Future<List<Control>> listControlsByPlant(int plantId) async {
    final List<Map<String, dynamic>> maps = await DbConnection.filter(tableName, 'fkid_planta = ?', [plantId]);
    return List.generate(maps.length, (i) {
      return Control.fromMap(maps[i]);
    });
  }

  // Método para eliminar un control por ID
  Future<int> delete(int id) async {
    return await DbConnection.delete(tableName, id);
  }

  // Método para actualizar un control por ID
  Future<int> updateControl(int id, Control control) async {
    return await DbConnection.updateControl(tableName, control.toMap(), id);
  }

  // Método para obtener un control por ID
  Future<Control> getControlById(int id) async {
    final List<Map<String, dynamic>> maps = await DbConnection.filter(tableName, 'id_control = ?', [id]);
    if (maps.isNotEmpty) {
      return Control.fromMap(maps.first);
    } else {
      throw Exception('Control no encontrado');
    }
  }

  Future<void> addControl(Control control) async {
    final db = await DbConnection.getDatabase();
    await db.insert('Controles', control.toMap());
  }

  Future<void> deleteControl(int idControl) async {
    final db = await DbConnection.getDatabase();
    await db.delete('Controles', where: 'id_control = ?', whereArgs: [idControl]);
  }
}