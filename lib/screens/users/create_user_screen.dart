import 'package:flutter/material.dart';
import '../../apiservices/api_services.dart'; // Asegúrate de importar tu api_services.dart

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<dynamic> _roles = [];
  int? _selectedRolId;
  @override
  void initState() {
    super.initState();
    fetchRoles();
  }

  Future<void> fetchRoles() async {
    try {
      final fetchedServices = await ApiServices.fetchRoles();
      setState(() {
        _roles = fetchedServices;
      });
      print("object");
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _signUp() async {
    try {
      final response = await ApiServices.createAccount(
        _selectedRolId!.toString(),
        _firstNameController.text,
        _lastNameController.text,
        _middleNameController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (response['success'] == true) {
        Navigator.pop(context); 
      } else {
        print('Error: ${response['error']}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('CREAR USUARIO'),
      ),
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
                'CREAR CUENTA',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'NOMBRE',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'APELLIDO PATERNO',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _middleNameController,
                decoration: InputDecoration(
                  labelText: 'APELLIDO MATERNO',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'CORREO',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'CONTRASEÑA',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              SizedBox(height: 5),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
                items: _roles.map<DropdownMenuItem<int>>((service) {
                  return DropdownMenuItem<int>(
                    value: service['id'],
                    child: Text(service['nombre']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRolId = value;
                  });
                },
                value: _selectedRolId,
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: _signUp,
                child: Text('GUARDAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
