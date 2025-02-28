import 'package:flutter/material.dart';
import 'package:tarea_integradora/screens/roles/create_rol_screen.dart';
import '../../apiservices/api_services.dart';
import '../home/main_screen.dart';

class RolesScreen extends StatefulWidget {
  final String userId;
  final String userRole;
  final String userNombre;
  final String userCorreo;

  const RolesScreen(
      {super.key,
      required this.userRole,
      required this.userId,
      required this.userNombre,
      required this.userCorreo});

  @override
  _RolesScreenState createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  List<dynamic> roles = [];

  @override
  void initState() {
    super.initState();
    fetchRoles();
  }

  Future<void> fetchRoles() async {
    try {
      List<dynamic> fetchedRoles;
      fetchedRoles = await ApiServices.fetchRoles();
      setState(() {
        roles = fetchedRoles;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => MainScreen(
              id: widget.userId,
              rol: widget.userRole,
              nombre: widget.userNombre,
              correo: widget
                  .userCorreo)), // Asegúrate de proporcionar cualquier argumento necesario
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Roles"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MainScreen(
                        id: widget.userId,
                        rol: widget.userRole,
                        nombre: widget.userNombre,
                        correo: widget
                            .userCorreo)), // Asegúrate de proporcionar cualquier argumento necesario
              );
            },
          ),
        ),
        body: Center(
          child: roles.isEmpty
              ? Text('Ningún rol registrado')
              : ListView.builder(
                  itemCount: roles.length,
                  itemBuilder: (context, index) {
                    final usuario = roles[index];
                    return GestureDetector(
                      onTap: widget.userRole == 'Administrador'
                          ? () {
                              /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserDetailScreen(
                                      userId: usuario['id'],
                                      userRole: widget.userRole, 
                                      userNombre: widget.userNombre, 
                                      userCorreo: widget.userCorreo),
                                ),
                              );*/
                              null;
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
                                color:
                                    isDarkMode ? Colors.black45 : Colors.white,
                                size: 30,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              ' ${usuario['nombre']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                    MaterialPageRoute(builder: (context) => CreateRolScreen()),
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
