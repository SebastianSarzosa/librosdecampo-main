import 'package:libroscampo/models/variables.dart';
import 'package:libroscampo/settings/db.connection.dart';
class VariablesRepository {
  final String tableName = 'Variables';

  // Método para crear una nueva variable
  Future<int> create(Variable variable) async {
    return await DbConnection.insert(tableName, variable.toMap());
  }

  // Método para listar todas las variables
  Future<List<Map<String, dynamic>>> listAllVariables() async {
    return await DbConnection.list(tableName);
  }

  // Método para listar variables por ID de control
  Future<List<Variable>> listVariablesByControl(int controlId) async {
    final db = await DbConnection.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'fkid_control = ?',
      whereArgs: [controlId],
    );

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return Variable.fromMap(maps[i]);
    });
  }

  // Método para listar variables por el primer control de una planta
  Future<List<Variable>> listVariablesByFirstControlOfPlant(int plantaId) async {
    final db = await DbConnection.getDatabase();
    final List<Map<String, dynamic>> controlMaps = await db.query(
      'Controles',
      where: 'fkid_planta = ?',
      whereArgs: [plantaId],
      orderBy: 'fecha_control ASC',
      limit: 1,
    );

    if (controlMaps.isEmpty) {
      return [];
    }

    final int firstControlId = controlMaps.first['id_control'];
    return listVariablesByControl(firstControlId);
  }

  // Método para eliminar una variable por ID
  Future<int> delete(int id) async {
    return await DbConnection.delete(tableName, id);
  }

  // Método para actualizar una variable por ID
  Future<int> update(int id, Variable variable) async {
    return await DbConnection.update(tableName, variable.toMap(), id);
  }

  // Método para obtener una variable por control y nombre
  Future<Variable?> getVariableByControlAndName(int controlId, String nombreVariable) async {
    final db = await DbConnection.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'fkid_control = ? AND nombre_variable = ?',
      whereArgs: [controlId, nombreVariable],
    );

    if (maps.isNotEmpty) {
      return Variable.fromMap(maps.first);
    }
    return null;
  }
}