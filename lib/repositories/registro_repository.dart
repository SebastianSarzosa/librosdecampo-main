import 'package:libroscampo/models/registroUsuarios.dart';
import 'package:libroscampo/settings/db.connection.dart';

class RegistroUsuarioRepository {
  final String tableName = 'RegistroUsuario';

  // Método para crear un nuevo registro de usuario
  Future<int> create(RegistroUsuario registroUsuario) async {
    return await DbConnection.insert(tableName, registroUsuario.toMap());
  }

  // Método para listar todos los registros de usuarios
  Future<List<RegistroUsuario>> listAllUsers() async {
    final List<Map<String, dynamic>> maps = await DbConnection.list(tableName);
    return List.generate(maps.length, (i) {
      return RegistroUsuario.fromMap(maps[i]);
    });
  }

  // Método para obtener un registro de usuario por ID
  Future<RegistroUsuario?> getById(int id) async {
    final List<Map<String, dynamic>> maps = await DbConnection.filter(tableName, 'id = ?', [id]);
    if (maps.isNotEmpty) {
      return RegistroUsuario.fromMap(maps.first);
    }
    return null;
  }

  // Método para obtener un registro de usuario por correo electrónico
  Future<RegistroUsuario?> getByEmail(String email) async {
    final List<Map<String, dynamic>> maps = await DbConnection.filter(tableName, 'correo_electronico = ?', [email]);
    if (maps.isNotEmpty) {
      return RegistroUsuario.fromMap(maps.first);
    }
    return null;
  }

  // Método para eliminar un registro de usuario por ID
  Future<int> delete(int id) async {
    final db = await DbConnection.getDatabase();
    final usuario = await getById(id);
    if (usuario != null) {
      await db.transaction((txn) async {
        await txn.delete(
          'Usuarios',
          where: 'nombre_usuario = ?',
          whereArgs: [usuario.nombreUsuario],
        );
        await txn.delete(
          'RegistroUsuario',
          where: 'id = ?',
          whereArgs: [id],
        );
      });
      return 1;
    }
    return 0;
  }

  // Método para actualizar un registro de usuario por ID
  Future<int> update(int id, RegistroUsuario registroUsuario) async {
    return await DbConnection.update(tableName, registroUsuario.toMap(), id);
  }

  // Método para actualizar el rol de un usuario en ambas tablas
  Future<int> updateUserRole(String nombreUsuario, String newRole) async {
    final db = await DbConnection.getDatabase();
    await db.transaction((txn) async {
      await txn.update(
        'Usuarios',
        {'rol_usuario': newRole},
        where: 'nombre_usuario = ?',
        whereArgs: [nombreUsuario],
      );
      await txn.update(
        'RegistroUsuario',
        {'rol_usuario': newRole},
        where: 'nombre_usuario = ?',
        whereArgs: [nombreUsuario],
      );
    });
    return 1;
  }

  // Método para registrar un usuario en ambas tablas
  Future<int> registerUser(RegistroUsuario registroUsuario) async {
    final db = await DbConnection.getDatabase();
    await db.transaction((txn) async {
      await txn.insert('Usuarios', {
        'nombre_usuario': registroUsuario.nombreUsuario,
        'password_usuario': registroUsuario.password,
        'rol_usuario': registroUsuario.rolUsuario,
      });
      await txn.insert('RegistroUsuario', registroUsuario.toMap());
    });
    return 1;
  }
}
