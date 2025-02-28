import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea_integradora/screens/calif/calificaciones_soporte_screen.dart';
import 'package:tarea_integradora/screens/roles/roles_screen.dart';
import 'package:tarea_integradora/screens/users/users_screen.dart';
import 'login_screen.dart';
import '../config/settings_screen.dart';
import '../support/tickets_screen.dart'; // Importa la pantalla de tickets
import '../../config/theme_provider.dart';

class MainScreen extends StatefulWidget {
  final String id;
  final String rol;
  final String nombre;
  final String correo;

  const MainScreen(
      {super.key,
      required this.id,
      required this.rol,
      required this.nombre,
      required this.correo});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<void> _logout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Cerrar sesión'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Deseas cerrar sesión?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Si', style: TextStyle(color: Colors.greenAccent)),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(
                      id: '',
                      rol: 'Invitado',
                      nombre: 'Invitado',
                      correo: '',
                    ),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text('No', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Codex services'),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                widget.nombre,
                style: TextStyle(
                  color: isDarkMode ?
                  Colors.white
                  :Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                widget.correo,
                style: TextStyle(
                  color: isDarkMode ?
                  Colors.white
                  :Colors.black,
                  fontSize: 14,), 
              ),
              currentAccountPicture: CircleAvatar(
                radius: 50,
                backgroundColor: isDarkMode ?
                Colors.black54:
                Colors.white30,
                child: Icon(
                  Icons.person,
                  color: isDarkMode ?
                Colors.white60:
                Colors.black54,
                  size: 50,
                ),
              ),
              decoration: BoxDecoration(
                color: isDarkMode ?
                Color.fromRGBO(130, 8, 252, 0.764)
                :
                Color.fromRGBO(187, 120, 255, 0.75),
              ),
            ),
            if (widget.rol == 'Administrador') ...[
              ListTile(
                title: Text('Tickets'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketsScreen(userId: int.parse(widget.id), userRol: widget.rol, userCorreo: widget.correo, userNombre: widget.nombre),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Usuarios'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UsersScreen(userRole: widget.rol, userId: widget.id, userNombre:widget.nombre, userCorreo: widget.correo),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Roles'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RolesScreen(userRole: widget.rol, userId: widget.id, userNombre:widget.nombre, userCorreo: widget.correo),
                    ),
                  );
                },
              ),
              ListTile(
              title: Text('Configuración'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen(userId: int.parse(widget.id))), // Asegúrate de pasar el userId
                );
              },
            ),
            ] else if (widget.rol == 'Operador') ...[
              ListTile(
                title: Text('Tickets'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketsScreen(userId: int.parse(widget.id), userRol: widget.rol, userCorreo: widget.correo, userNombre: widget.nombre), // Pasa el userId
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Usuarios'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UsersScreen(userRole: widget.rol, userId: widget.id, userNombre:widget.nombre, userCorreo: widget.correo),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Mis calificaciones'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalificacionesSoporteScreen(id_operador: int.parse(widget.id)),
                    ),
                  );
                },
              ),
              ListTile(
              title: Text('Configuración'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen(userId: int.parse(widget.id))), // Asegúrate de pasar el userId
                );
              },
            ),
            ] else if (widget.rol == 'Cliente') ...[
              ListTile(
                title: Text('Tickets'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketsScreen(userId: int.parse(widget.id), userRol: widget.rol, userCorreo: widget.correo, userNombre: widget.nombre,), // Pasa el userId
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Opción Cliente 2'),
                onTap: () {
                  // Acción para la opción Cliente 2
                },
              ),
              ListTile(
              title: Text('Configuración'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen(userId: int.parse(widget.id))), // Asegúrate de pasar el userId
                );
              },
            ),
            ],
            ListTile(
              title: Text(widget.rol == 'Invitado' ? 'Login' : 'Logout'),
              onTap: () {
                if (widget.rol == 'Invitado') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } else {
                  _logout();
                }
              },
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomLeft,
              child: ListTile(
                title: Text('Modo Oscuro'),
                trailing: Icon(
                  themeProvider.themeMode == ThemeMode.dark
                      ? Icons.nights_stay
                      : Icons.wb_sunny,
                ),
                onTap: () {
                  themeProvider.toggleTheme(
                      themeProvider.themeMode != ThemeMode.dark);
                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                print("Boton de Game Pass");
              },
              child: Text('Game Pass'),
            ),
            ElevatedButton(
              onPressed: () {
                print("Boton de Play Station Plus");
              },
              child: Text('Play Station Plus'),
            ),
            ElevatedButton(
              onPressed: () {
                print("Boton de Nintedo Online");
              },
              child: Text('Nintendo Onine'),
            ),
          ],
        ),
      ),
    );
  }
}