import 'package:libroscampo/models/proyectos.dart';
import 'package:libroscampo/settings/db.connection.dart';

class ProyectosRepository {
  final String tableName = 'Proyectos';  
  
  // Método para crear un nuevo proyecto
  Future<int> create(Proyecto proyecto) async {
    return await DbConnection.insert(tableName, proyecto.toMap());
  }

  // Método para listar todos los proyectos
  Future<List<Map<String, dynamic>>> listAllProjects() async {
    return await DbConnection.list(tableName);
  }

  // Método para listar proyectos por ID de libro
  Future<List<Map<String, dynamic>>> listProjectsByBook(String bookId) async {
    return await DbConnection.filter(tableName, 'libro_id = ?', [bookId]);
  }

  // Método para eliminar un proyecto por ID
  Future<int> delete(int id) async {
    return await DbConnection.delete(tableName, id);
  }

  // Método para actualizar un proyecto por ID
  Future<int> update(int id, Proyecto proyecto) async {
    return await DbConnection.update(tableName, proyecto.toMap(), id);
  }
}