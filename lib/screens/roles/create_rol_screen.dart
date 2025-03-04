import 'package:flutter/material.dart';
import '../../apiservices/api_services.dart'; // Asegúrate de importar tu api_services.dart

class CreateRolScreen extends StatefulWidget {
  const CreateRolScreen({super.key});

  @override
  _CreateRolScreenState createState() => _CreateRolScreenState();
}

class _CreateRolScreenState extends State<CreateRolScreen> {
  final TextEditingController _NameController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Future<void> _createRol() async {
    try {
      final response = await ApiServices.createRol(_NameController.text);
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
      backgroundColor: isDarkMode ? Color(0xff282828) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Color(0xff282828) : Colors.white,
        title: Text('CREAR ROL'),
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
                'CREAR NUEVO ROL',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _NameController,
                decoration: InputDecoration(
                  labelText: 'NOMBRE',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _createRol,
                child: Text('GUARDAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
