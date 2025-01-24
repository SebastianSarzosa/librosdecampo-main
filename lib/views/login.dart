import 'package:flutter/material.dart';
import 'package:libroscampo/settings/db.connection.dart';

class LoginCreate extends StatefulWidget {
  const LoginCreate({super.key});

  @override
  State<LoginCreate> createState() => _LoginCreateState();
}

class _LoginCreateState extends State<LoginCreate> {
  final loginForm = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true; // Variable para controlar la visibilidad de la contraseña

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: loginForm,
          child: ListView(
            children: <Widget>[
              Image.asset(
                'assets/images/login/caren.png',
                height: 100,
              ),
              const SizedBox(height: 16),
              const Text(
                'Bienvenido',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Usuario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su nombre de usuario';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                obscureText: _obscureText, // Controla la visibilidad de la contraseña
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText; // Cambia el estado de visibilidad
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  return null;
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Olvidé mi contraseña'),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (loginForm.currentState!.validate()) {
                    final user = await DbConnection.getUser(
                      emailController.text,
                      passwordController.text,
                    );

                    if (user != null) {
                      // Verifica el rol del usuario
                      final userRole = user['rol_usuario'];
                      final userName = user['nombre_usuario'];

                      Navigator.pushNamed(
                        context,
                        '/bienvenido',
                        arguments: {'userRole': userRole, 'userName': userName},
                      );
                    } else {
                      // Muestra un mensaje de error si las credenciales son incorrectas
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Credenciales incorrectas'),
                          backgroundColor: Colors.red, // Fondo rojo para el mensaje de error
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Iniciar Sesión'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}