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
  Future<List<Proyecto>> listProjectsByBook(int bookId) async { // Cambia String a int
    final List<Map<String, dynamic>> maps = await DbConnection.filter(tableName, 'fkid_libro = ?', [bookId]); // Asegúrate de que 'libro_id' sea la columna correcta
    return List.generate(maps.length, (i) {
      return Proyecto.fromMap(maps[i]); // Asegúrate de tener un método fromMap en tu modelo Proyecto
    });
  }

  // Método para eliminar un proyecto por ID
  Future<int> delete(int id) async {
    return await DbConnection.delete(tableName, id);
  }

  // Método para actualizar un proyecto por ID
  Future<int> update(int id, Proyecto proyecto) async {
    return await DbConnection.updateProyecto(tableName, proyecto.toMap(), id); // Cambia 'id_variable' a 'id_pro'
  }
}