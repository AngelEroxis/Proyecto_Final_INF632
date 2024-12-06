import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/usuario.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _rol = 'paciente'; // Rol predeterminado

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final db = await DBHelper.instance.database;

      // Crear objeto de usuario
      final usuario = Usuario(
        nombre: _nombreController.text,
        email: _emailController.text,
        password: _passwordController.text,
        rol: _rol,
      );

      // Guardar en la base de datos
      await db.insert('usuarios', usuario.toMap());

      // Mostrar mensaje de éxito
      // Verificar los datos guardados
      final usuarios = await DBHelper.instance.fetchUsuarios();
      print('Usuarios en la base de datos: $usuarios');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario registrado con éxito')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Fondo suave
      appBar: AppBar(
        title: Text('Registro de Usuario'),
        backgroundColor: Colors.blue[600], // Color de barra de navegación
      ),
      body: SingleChildScrollView(
        // Permitir desplazamiento
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Icono y texto para mostrar la imagen en la parte superior
              Image.network(
                'https://coloriagevip.com/wp-content/uploads/2024/09/Coloriage-Satoru-Gojo-34.webp', // Sustituye con tu URL de imagen
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 30),
              // Campo de texto para Nombre
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ingresa tu nombre',
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Campo de texto para Correo
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  hintText: 'Ingresa tu correo',
                  prefixIcon: Icon(Icons.email, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu correo';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Ingresa un correo válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Campo de texto para Contraseña
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  hintText: 'Ingresa tu contraseña',
                  prefixIcon: Icon(Icons.lock, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una contraseña';
                  }
                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Dropdown para seleccionar el rol
              DropdownButtonFormField<String>(
                value: _rol,
                decoration: InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: ['paciente', 'médico'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _rol = newValue!;
                  });
                },
              ),
              SizedBox(height: 30),
              // Botón de registro
              ElevatedButton(
                onPressed: _registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600], // Color de fondo
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Registrarse', style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 20),
              // Verificar usuarios en la base de datos
              TextButton(
                onPressed: () async {
                  final usuarios = await DBHelper.instance.fetchUsuarios();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Usuarios en la BD'),
                      content: Text(usuarios.toString()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cerrar'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Verificar Usuarios',
                  style: TextStyle(color: Colors.blue[600], fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
