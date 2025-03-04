import 'package:flutter/material.dart';
import '../../apiservices/api_services.dart';
import '../home/main_screen.dart';
import 'create_user_screen.dart';
import 'user_detail_screen.dart';
class UsersScreen extends StatefulWidget {
  final String userId;
  final String userRole;
  final String userNombre;
  final String userCorreo;

  const UsersScreen({super.key, required this.userRole, required this.userId, required this.userNombre, required this.userCorreo});

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      List<dynamic> fetchedUsers;
      fetchedUsers = await ApiServices.fetchUsers();
      setState(() {
        users = fetchedUsers;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(id: widget.userId, rol: widget.userRole, nombre: widget.userNombre, correo: widget.userCorreo)), // Asegúrate de proporcionar cualquier argumento necesario
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: isDarkMode ? Color(0xff282828) : Colors.white,
        appBar: AppBar(
          backgroundColor: isDarkMode ? Color(0xff282828) : Colors.white,
          title: Text("Usuarios"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreen(id: widget.userId, rol: widget.userRole, nombre: widget.userNombre, correo: widget.userCorreo)), // Asegúrate de proporcionar cualquier argumento necesario
              );
            },
          ),
        ),
        body: Center(
          child: users.isEmpty
              ? Text('Ningún usuario registrado')
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final usuario = users[index];
                    return GestureDetector(
                      onTap: widget.userRole == 'Administrador'
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserDetailScreen(
                                      userId: usuario['id'],
                                      userRole: widget.userRole, 
                                      userNombre: widget.userNombre, 
                                      userCorreo: widget.userCorreo),
                                ),
                              );
                            }
                          : null,
                      child: Card(
                        margin: EdgeInsets.all(20),
                        elevation: 15,
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  isDarkMode ? Colors.white30 : Colors.black26,
                              child: Icon(
                                Icons.person,
                                color: isDarkMode ? Colors.black45 : Colors.white,
                                size: 30,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${usuario['nombre']} ${usuario['apellido_paterno']} ${usuario['apellido_materno']}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Correo: ${usuario['correo']}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            widget.userRole == 'Administrador'
                                ? Text(
                                    'Rol: ${usuario['rol']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )
                                : SizedBox(height: 5),
                            Text(
                              'Estado: ${usuario['status']}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        floatingActionButton: widget.userRole == 'Administrador'
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateUserScreen()),
                  );
                },
                backgroundColor: isDarkMode
                    ? Color.fromARGB(183, 195, 219, 255)
                    : Color.fromARGB(175, 90, 100, 116),
                child: Icon(Icons.add, color: Colors.white60),
              )
            : null,
      ),
    );
  }
}
