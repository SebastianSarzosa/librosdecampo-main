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
    final List<Map<String, dynamic>> maps = await DbConnection.filter(tableName, 'fkid_control = ?', [controlId]);
    return List.generate(maps.length, (i) {
      return Variable.fromMap(maps[i]);
    });
  }

  // Método para eliminar una variable por ID
  Future<int> delete(int id) async {
    return await DbConnection.delete(tableName, id);
  }

  // Método para actualizar una variable por ID
  Future<int> update(int id, Variable variable) async {
    return await DbConnection.update(tableName, variable.toMap(), id);
  }
}