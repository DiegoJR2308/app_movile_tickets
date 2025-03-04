import 'package:flutter/material.dart';
import '../../apiservices/api_services.dart';
import 'main_screen.dart';
import 'create_account_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      final responseJson = await ApiServices.login(
        _emailController.text,
        _passwordController.text,
      );

      if (responseJson['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(
              id: responseJson['id'].toString(),
              rol: responseJson['rol'],
              nombre: responseJson['nombre'],
              correo: responseJson['correo'],
            ),
          ),
        );
      } else {
        print('Error: ${responseJson['error']}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xff282828) : Colors.white,
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black.withOpacity(0.5) : Colors.blue.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Inicio de sesión',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Ingresa tus datos para continuar',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Correo',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  hintStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54),
                ),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Google sign-in logic here
                },
                child: Text(
                  'Iniciar sesión con Google',
                  style: TextStyle(color: isDarkMode ? Colors.blue[200] : Colors.blue),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Entrar'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: Text(
                  'Crear Cuenta...',
                  style: TextStyle(color: isDarkMode ? Colors.blue[200] : Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Recover password logic here
                },
                child: Text(
                  'Recuperar contraseña',
                  style: TextStyle(color: isDarkMode ? Colors.blue[200] : Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
