import 'package:libroscampo/models/user.dart';
import 'package:sqflite/sqflite.dart'; //importar conexop a sqliite
import 'package:path/path.dart'; //importar gestor de rutas

class DbConnection {
  static const version = 1; // tener un control por eso es version = 1
  static const String dbname = 'libroCampo.db'; //nombre de la base de datos

  static Future<Database> getDatabase() async {
    return openDatabase(join(await getDatabasesPath(), dbname),
        version: version, //es opcional
        onCreate: (db, version) async => {
              //valida la base de datos del wait si existe pasa al oncreate
              await db.execute("""
          CREATE TABLE LibrosCampo(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre_libro TEXT NOT NULL,
            descripcion_libro TEXT NOT NULL,
            fecha_creacion_libro DATE NOT NULL
          )
        """),

              await db.execute("""
          INSERT INTO LibrosCampo (id, nombre_libro, descripcion_libro, fecha_creacion_libro) VALUES
          (1, 'Fitomejoramiento', 'Libro3', '2022-11-11'),
          (2, 'Caracterizacion', 'Libro2', '2022-11-11'),
          (3, 'Produccion', 'libro3', '2022-11-11'),
          (4, 'Fertilizacion', 'libro4', '2022-11-11')
         """),

              await db.execute("""
          CREATE TABLE Proyectos(
            id_pro INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre_pro TEXT NOT NULL,
            descripcion_pro TEXT NOT NULL,
            fecha_inicio_pro DATE NOT NULL,
            fkid_libro INTEGER NOT NULL,
            FOREIGN KEY (fkid_libro) REFERENCES LibrosCampo(id)
          );
        """),

              await db.execute("""
          INSERT INTO Proyectos (nombre_pro, descripcion_pro, fecha_inicio_pro, fkid_libro) VALUES
          ('Proyecto de cultivo de maíz', 'Evaluacion de maíz', '2025-02-01', 2),
          ('Proyecto de cultivo de quinua', 'Evaluacion de quinua', '2025-02-01', 2),
          ('Proyecto de cultivo de chocho', 'Evaluacion de chocho', '2025-02-01', 2)
        """),

              await db.execute("""
          CREATE TABLE Plantas (
            id_planta INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre_planta TEXT NOT NULL,
            nombre_cientifico TEXT,
            fkid_proyecto INTEGER NOT NULL,
            FOREIGN KEY (fkid_proyecto) REFERENCES Proyectos(id_pro) ON DELETE CASCADE
          );
        """),

              await db.execute("""
          INSERT INTO Plantas (nombre_planta, nombre_cientifico, fkid_proyecto) VALUES
          ('MAI 1', 'Zea mays', 1),
          ('MAI 2', 'Zea mays', 1),
          ('MAI 3', 'Zea mays', 1),
          ('QUI 1', 'Chenopodium quinoa', 2),
          ('QUI 2', 'Chenopodium quinoa', 2),
          ('CHO 1', 'Lupinus mutabilis', 3),
          ('CHO 2', 'Lupinus mutabilis', 3)
        """),

              await db.execute("""
          CREATE TABLE Controles (
            id_control INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre_control TEXT NOT NULL,
            fecha_control DATE,
            descripcion TEXT,
            fkid_planta INTEGER NOT NULL,
            FOREIGN KEY (fkid_planta) REFERENCES Plantas(id_planta) ON DELETE CASCADE
          );
        """),

              await db.execute("""
          INSERT INTO Controles (fecha_control,nombre_control, descripcion, fkid_planta) VALUES
          ('2025-01-05','Control Inicial ', 'Control de crecimiento inicial', 1),
          ('2025-01-10','Control Semanal uno', 'Control de crecimiento semana uno', 1),
          ('2025-01-15','Control Semanal dos', 'Control de crecimiento semand dos ', 1),
          ('2025-01-20','Control Semanal tres', 'Control de crecimiento semanda tres', 1),
          ('2025-01-25','Control Semanal cuatro', 'Control de crecimiento semana cuatro ', 1),
          ('2025-02-01','Control Semanal cinco', 'Control de crecimiento semana cinco ', 1),
          ('2025-02-05','Control Semanal seis', 'Control de crecimiento semana seis ', 1),
          ('2025-02-10','Control Semanal siete', 'Control de crecimiento semana siete ', 1),
          ('2025-02-15','Control Semanal ocho', 'Control de crecimiento semana ocho ', 1),
          ('2025-01-05','Control Inicial ', 'Control de crecimiento inicial', 4),
          ('2025-01-10','Control Semanal uno', 'Control de crecimiento semana uno', 4),
          ('2025-01-15','Control Semanal dos', 'Control de crecimiento semand dos ', 4),
          ('2025-01-20','Control Semanal tres', 'Control de crecimiento semanda tres', 4),
          ('2025-01-25','Control Semanal cuatro', 'Control de crecimiento semana cuatro ', 4),
          ('2025-02-01','Control Semanal cinco', 'Control de crecimiento semana cinco ', 4),
          ('2025-02-05','Control Semanal seis', 'Control de crecimiento semana seis ', 4),
          ('2025-02-10','Control Semanal siete', 'Control de crecimiento semana siete ', 4),
          ('2025-02-15','Control Semanal ocho', 'Control de crecimiento semana ocho ', 4)
          
          
        """),

              await db.execute("""
          CREATE TABLE Variables (
            id_variable INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre_variable TEXT NOT NULL,
            valor_texto TEXT,
            valor_numerico NUMERIC,
            valor_fecha DATE,
            fkid_control INTEGER NOT NULL,
            FOREIGN KEY (fkid_control) REFERENCES Controles(id_control) ON DELETE CASCADE
          );
        """),

              await db.execute("""
          INSERT INTO Variables (nombre_variable, valor_texto, valor_numerico, valor_fecha, fkid_control) VALUES
          ('Altura', NULL, 15.5, NULL, 1),
          ('Altura', NULL, 20.5, NULL, 2),
          ('Altura', NULL, 20.1, NULL, 3),
          ('Altura', NULL, 25.5, NULL, 4),
          ('Altura', NULL, 30.5, NULL, 5),
          ('Altura', NULL, 35.5, NULL, 6),
          ('Altura', NULL, 40.5, NULL, 7),
          ('Altura', NULL, 45.5, NULL, 8),
          ('Altura', NULL, 50.5, NULL, 9),
          ('Altura', NULL, 15.5, NULL, 10),
          ('Altura', NULL, 20.5, NULL, 11),
          ('Altura', NULL, 20.1, NULL, 12),
          ('Altura', NULL, 25.5, NULL, 13),
          ('Altura', NULL, 30.5, NULL, 14),
          ('Altura', NULL, 35.5, NULL, 15),
          ('Altura', NULL, 40.5, NULL, 16),
          ('Altura', NULL, 45.5, NULL, 17),
          ('Altura', NULL, 50.5, NULL, 18)
        """),

              await db.execute("""
          CREATE TABLE Usuarios (
            id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre_usuario TEXT NOT NULL,
            password_usuario TEXT,
            rol_usuario TEXT
          );
        """),

              await db.execute("""
          INSERT INTO Usuarios (nombre_usuario, password_usuario, rol_usuario) VALUES
          ('admin', 'admin123', 'admin'),
          ('visor', 'visor123', 'visor'),
          ('user1', 'user123', 'editor'),
          ('user2', 'user456', 'editor');
        """),

              await db.execute("""
          CREATE TABLE RegistroUsuario (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            apellido TEXT NOT NULL,
            correo_electronico TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            rol_usuario TEXT NOT NULL,
            nombre_usuario TEXT NOT NULL,
            FOREIGN KEY (rol_usuario) REFERENCES Usuarios(rol_usuario),
            FOREIGN KEY (nombre_usuario) REFERENCES Usuarios(nombre_usuario)
          );
        """),
            });
  }

  static Future<int> insert(String tableName, dynamic data) async {
    final db = await getDatabase();
    return db.insert(tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }


  static Future<int> update(String tableName, dynamic data, int id) async {
    final db = await getDatabase();
    return db.update(tableName, data,
        where: "id_variable = ?",
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
  static Future<int> updateProyecto(String tableName, dynamic data, int id) async {
    final db = await getDatabase();
    return db.update(tableName, data,
        where: "id_pro = ?",
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updatePlanta(String tableName, dynamic data, int id) async {
    final db = await getDatabase();
    return db.update(tableName, data,
        where: "id_planta = ?",
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> delete(String tableName, int id) async {
    final db = await getDatabase();
    return db.delete(
      tableName,
      where: "id=?",
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> list(String tableName) async {
    final db = await getDatabase();
    return await db.query(tableName);
  }

  static Future<List<Map<String, dynamic>>> filter(
      String tableName, String where, dynamic whereArgs) async {
    final db = await getDatabase();
    return await db.query(tableName, where: where, whereArgs: whereArgs);
  }

  static Future<List<Map<String, dynamic>>> selectSql(
      String sql, List<dynamic> args) async {
    final db = await getDatabase();
    return db.rawQuery(sql, args);
  }

  // Método para insertar un usuario
  static Future<int> insertUser(User user) async {
    final db = await getDatabase();
    return db.insert('Usuarios', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
  

  // Método para obtener un usuario por nombre de usuario y contraseña
  static Future<Map<String, dynamic>?> getUser(
      String username, String password) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'Usuarios',
      where: 'nombre_usuario = ? AND password_usuario = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return maps.first; // Retorna el primer usuario encontrado
    }
    return null; // Retorna null si no se encuentra el usuario
    
  }

}
