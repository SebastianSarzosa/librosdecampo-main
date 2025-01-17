import 'package:sqflite/sqflite.dart'; //importar conexop a sqliite
import 'package:path/path.dart'; //importar gestor de rutas

class DbConnection {
  static const version = 1; // tener un control por eso es version = 1
  static const String dbname = 'libroCampo.db'; //nombre de la base de datos 

  static Future<Database> getDatabase() async{   
    return openDatabase(
      join(await getDatabasesPath(),dbname),
      version: version,  //es opcional
      onCreate: (db, version) async =>{ //valida la base de datos del wait si existe pasa al oncreate 
        await db.execute( """
          CREATE TABLE LibrosCampo(
            id_libro integer primary key AUTOINCREMENT,
            nombre_libro text not null,
            descripcion_libro text not null,
            fecha_creacion_libro date not null
          )
          """
        ),
        await db.execute("""insert into LibrosCampo values
          (1, 'Fitomejoramiento','Libro3','2022-11-11'),
          (2, 'Caracterizacion','Libro2','2022-11-11'),
          (3, 'Produccion','libro3,'2022-11-11')

          """
        ),
        await db.execute("""
          CREATE TABLE  Proyectos(
            id_pro integer primary key AUTOINCREMENT,
            nombre_pro text not null,
            descripcion_pro text not null,
            fecha_inicio_pro date not null,
            fkid_libro integer not null,
            foreign key (fk_libro) references LibrosCampo(id)
          ); 
          """
        ),

        await db.execute("""INSERT INTO proyectos (fkid_libro, nombre_pro, descripcion_pro, fecha_inicio_pro) VALUES
        (1, 'Proyecto A', 'Descripción del proyecto A', '2025-01-03'),
        (1, 'Proyecto B', 'Descripción del proyecto B', '2025-01-04'),
        (2, 'Proyecto C', 'Descripción del proyecto C', '2025-01-05');
          """
        ),

        await db.execute("""
          CREATE TABLE plantas (
          id_planta INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre_planta TEXT NOT NULL,
          nombre_cientifico TEXT,
          fkid_proyecto INTEGER NOT NULL,
          FOREIGN KEY (fkid_proyecto) REFERENCES proyectos(id_proyecto) ON DELETE CASCADE
          );
          """
        ),

        await db.execute("""INSERT INTO plantas (fkid_proyecto, nombre_planta, nombre_cientifico) VALUES
        (1, 'Planta 1', 'Plantae Scientifica 1'),
        (1, 'Planta 2', 'Plantae Scientifica 2'),
        (2, 'Planta 3', 'Plantae Scientifica 3'),
        (3, 'Planta 4', 'Plantae Scientifica 4');
        """
        ),

        await db.execute("""
          CREATE TABLE controles (
          id_control INTEGER PRIMARY KEY AUTOINCREMENT,
          fecha_control DATE,
          descripcion TEXT,
          fkid_planta INTEGER NOT NULL,
          FOREIGN KEY (fkid_planta) REFERENCES plantas(id_planta) ON DELETE CASCADE
          );
          """
        ),

        await db.execute("""INSERT INTO controles (fkid_planta, fecha_control, descripcion) VALUES
        (1, '2025-01-06', 'Control de crecimiento inicial para Planta 1'),
        (1, '2025-01-07', 'Control de nutrientes para Planta 1'),
        (2, '2025-01-08', 'Control de plagas para Planta 2'),
        (3, '2025-01-09', 'Control de riego para Planta 3'),
        (4, '2025-01-10', 'Control de poda para Planta 4');
        """
        ),

        await db.execute("""
          CREATE TABLE variables (
          id_variable INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre_variable TEXT NOT NULL,
          valor_texto TEXT,
          valor_numerico NUMERIC,
          valor_fecha DATE,
          fkid_control INTEGER NOT NULL,
          FOREIGN KEY (fkid_control) REFERENCES controles(id_control) ON DELETE CASCADE
          );
          """
        ),

        await db.execute("""INSERT INTO variables (fkid_control, nombre_variable, valor_texto, valor_numerico, valor_fecha) VALUES
        (1, 'Altura', NULL, 15.5, NULL),
        (1, 'Color de hoja', 'Verde claro', NULL, NULL),
        (2, 'Nutrientes', 'Alto contenido de Nitrógeno', NULL, NULL),
        (3, 'Presencia de plagas', 'Ninguna', NULL, NULL),
        (4, 'Cantidad de agua', NULL, 2.5, NULL),
        (5, 'Fecha de última poda', NULL, NULL, '2025-01-10');
        """
        ),
      }
    );
  } 
  //insert : mandar datos y se crea solo el insert 
  static Future<int> insert(String tableName, dynamic data) async{
    final db = await getDatabase(); //tableName nombre de la tabla ejem pacientes,medicame,dep
    return db.insert(tableName, data, conflictAlgorithm: ConflictAlgorithm.replace);     
  }
  //rowInsert : mandar un paramaetro con el insert into
  static Future<int> insertSql(String,sql) async {
    final db=await getDatabase();
    return db.rawInsert(sql);
  }

  //FUNCIONES DE ACTUALIZACION DE DATOS
  static Future<int> update(String tableName, dynamic data, int id) async{
    final db = await getDatabase();
    return db.update(tableName, 
      data,
      where: "id=?",
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<int> updatesql(String sql) async{
    final db = await getDatabase();
    return db.rawUpdate(sql);
    
  }
  //Funcion delete

  static Future<int> delete(String tableName, int id) async{
    final db = await getDatabase();
    return db.delete(tableName,
    where: "id=?",
    whereArgs: [id],
    );
  }

  static Future<int> deletesql(String sql) async{
    final db = await getDatabase();
    return db.rawDelete(sql);
  }

  //FUNCION LISTAR

  static Future <List<Map<String, dynamic>>> list(String tableName) async{
    final db=await getDatabase(); //base de datos
    return await db.query(tableName); //select * form y el table muestra toda la tabla  
  }
  ///select * from ---- where ..... cndition
  static Future <List<Map<String, dynamic>>> filter(String tableName, String where, dynamic whereArgs) async{
    final db=await getDatabase(); 
    return await db.query(
      tableName,
      where: where,
      whereArgs: whereArgs
    );   
  }
  //enviar tal cual el sql
  static Future<List<Map<String, dynamic>>> selectSql(String sql) async{
    final db=await getDatabase();
    return db.rawQuery(sql);
  }
}