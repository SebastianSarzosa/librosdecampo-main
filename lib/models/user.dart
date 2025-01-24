// user.dart
class User {
  final int? id;
  final String username;
  final String password;
  final String role; // 'admin' o 'visor'

  User({this.id, required this.username, required this.password, required this.role});

  // Convertir un usuario a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre_usuario': username,
      'password_usuario': password,
      'rol_usuario': role,
    };
  }

  // Convertir un mapa a un usuario
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['nombre_usuario'],
      password: map['password_usuario'],
      role: map['rol_usuario'],
    );
  }
}