import 'package:flutter/material.dart';
import 'package:tarea_integradora/screens/support/tickets_screen.dart';
import '../../apiservices/api_services.dart'; // Asegúrate de importar tu api_services.dart

class CreateTicketScreen extends StatefulWidget {
  final int userId;
  final String userRol;
  final String userCorreo;
  final String userNombre;

  const CreateTicketScreen(
      {super.key,
      required this.userId,
      required this.userRol,
      required this.userCorreo,
      required this.userNombre});

  @override
  _CreateTicketScreenState createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  int? _selectedServiceId;
  List<dynamic> _services = [];

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      final fetchedServices = await ApiServices.fetchServices();
      setState(() {
        _services = fetchedServices;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _createTicket() async {
    if (_selectedServiceId == null) {
      print('Seleccione un servicio');
      return;
    }

    try {
      final response = await ApiServices.createTicket(
        widget.userId,
        _tituloController.text,
        _descripcionController.text,
        _selectedServiceId!,
      );

      if (response['success'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketsScreen(
              userId: widget.userId,
              userRol: widget.userRol,
              userCorreo: widget.userCorreo,
              userNombre: widget.userNombre,
            ),
          ),
        );
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
        title: Text('Crear Ticket'),
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
                color: isDarkMode
                    ? Colors.black.withOpacity(0.5)
                    : Colors.blue.withOpacity(0.5),
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
                'Crear Ticket',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Servicio',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
                items: _services.map<DropdownMenuItem<int>>((service) {
                  return DropdownMenuItem<int>(
                    value: service['id'],
                    child: Text(service['nombre']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedServiceId = value;
                  });
                },
                value: _selectedServiceId,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createTicket,
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
