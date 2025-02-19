import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libroscampo/repositories/registro_repository.dart';
import 'package:libroscampo/models/registroUsuarios.dart';

class RegisterCreate extends StatefulWidget {
  const RegisterCreate({super.key});

  @override
  State<RegisterCreate> createState() => _RegisterCreateState();
}

class _RegisterCreateState extends State<RegisterCreate> {
  final registerForm = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Usuario'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: registerForm,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su nombre';
                  }
                  if (!RegExp(r'^[a-zA-Z]{3,50}$').hasMatch(value)) {
                    return 'El nombre debe contener solo letras y tener entre 3 y 50 caracteres';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su apellido';
                  }
                  if (!RegExp(r'^[a-zA-Z]{3,50}$').hasMatch(value)) {
                    return 'El apellido debe contener solo letras y tener entre 3 y 50 caracteres';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su correo electrónico';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@utc\.edu\.ec$').hasMatch(value)) {
                    return 'El correo electrónico debe ser del dominio @utc.edu.ec';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su teléfono';
                  }
                  if (!RegExp(r'^09\d{8}$').hasMatch(value)) {
                    return 'El teléfono debe iniciar con 09 y tener 10 dígitos';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
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
              TextFormField(
                controller: confirmPasswordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor confirme su contraseña';
                  }
                  if (value != passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (registerForm.currentState!.validate()) {
                    // Verificar si el correo electrónico ya existe
                    final existingUser = await RegistroUsuarioRepository().getByEmail(emailController.text);
                    if (existingUser != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El correo electrónico ya está registrado'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final registroUsuario = RegistroUsuario(
                      nombre: nameController.text,
                      apellido: lastNameController.text,
                      correoElectronico: emailController.text,
                      password: passwordController.text,
                      rolUsuario: 'visor', // Rol por defecto
                      nombreUsuario: emailController.text, // Guardar el correo en nombre_usuario
                    );

                    final success = await RegistroUsuarioRepository().registerUser(registroUsuario);

                    if (success > 0) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Usuario registrado exitosamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error al registrar usuario'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Registrar'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
