class RegistroUsuario {
  int? id;
  String nombre;
  String apellido;
  String correoElectronico;
  String password;
  String rolUsuario;
  String nombreUsuario;

  RegistroUsuario({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.correoElectronico,
    required this.password,
    required this.rolUsuario,
    required this.nombreUsuario,
  });

  // Convertir a Map para operaciones de base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'correo_electronico': correoElectronico,
      'password': password,
      'rol_usuario': rolUsuario,
      'nombre_usuario': nombreUsuario,
    };
  }

  // Crear una instancia de RegistroUsuario desde un Map
  static RegistroUsuario fromMap(Map<String, dynamic> map) {
    return RegistroUsuario(
      id: map['id'],
      nombre: map['nombre'],
      apellido: map['apellido'],
      correoElectronico: map['correo_electronico'],
      password: map['password'],
      rolUsuario: map['rol_usuario'],
      nombreUsuario: map['nombre_usuario'],
    );
  }
}
