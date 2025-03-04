import 'package:flutter/material.dart';
import 'user_update_screen.dart';
import '../../apiservices/api_services.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;
  final String userRole;
  final String userNombre;
  final String userCorreo;

  const UserDetailScreen({super.key, required this.userId, required this.userRole, required this.userNombre, required this.userCorreo});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  Map<String, dynamic>? userDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final details = await ApiServices.fetchUserDetails(widget.userId);
      setState(() {
        userDetails = details as Map<String, dynamic>?;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToUpdate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserUpdateScreen(userId: widget.userId, userRole: widget.userRole, userNombre: widget.userNombre, userCorreo: widget.userCorreo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xff282828) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Color(0xff282828) : Colors.white,
        title: Text('Detalle de Usuario'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userDetails == null
              ? Center(child: Text('Error al cargar los detalles del usuario'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Información del Usuario',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 25),
                          Text(
                            'Nombre: ${userDetails!['nombre']} ${userDetails!['apellido_paterno']} ${userDetails!['apellido_materno']}',
                            style: TextStyle(
                              fontSize: 18,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Correo: ${userDetails!['correo']}',
                            style: TextStyle(
                              fontSize: 18,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Rol: ${userDetails!['rol']}',
                            style: TextStyle(
                              fontSize: 18,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      )),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _navigateToUpdate,
                        child: Text('Editar Usuario'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
