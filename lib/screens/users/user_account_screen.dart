import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../apiservices/api_services.dart';
import '../home/main_screen.dart';

class UserAccountScreen extends StatefulWidget {
  final int userId;

  const UserAccountScreen({super.key, required this.userId});

  @override
  _UserAccountScreenState createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  Map<String, dynamic>? userDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final details = await ApiServices.fetchAccount(widget.userId);
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

  void _updateProfile() {
    print("Validando boton de Editar Perfil");
  }

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: isDarkMode ? const Color.fromARGB(255, 30, 30, 30) : Colors.white,
      appBar: AppBar(
        //backgroundColor: Color(0x44000000),
        //backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Cuenta de Usuario'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userDetails == null
              ? Center(child: Text('Error al cargar los detalles del usuario'))
              : Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        ClipPath(
                          clipper: DrawClip(),
                          child: Container(
                            height: size.height * 0.5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Color.fromRGBO(130, 8, 252, 0.764),
                                    Color.fromRGBO(187, 120, 255, 0.75)
                                  ]),
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(bottom: 60),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 70,
                                    backgroundColor: isDarkMode
                                        ? Colors.black26
                                        : Colors.white30,
                                    child: Icon(
                                      Icons.person,
                                      color: isDarkMode
                                          ? Colors.white60
                                          : Colors.black54,
                                      size: 90,
                                    ),
                                  ),
                                  Text(
                                    "${userDetails!['nombre']} ${userDetails!['apellido_paterno']} ${userDetails!['apellido_materno']}",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${userDetails!['correo']}",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 22,
                                    ),
                                  ),
                                  userDetails!['rol'] == 'Administrador'
                                      ? Text(
                                          "${userDetails!['rol']}",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 22,
                                          ),
                                        )
                                      : Text("")
                                ])),
                      ],
                    ),
                    Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 80),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(180, 60),
                              elevation: 15,
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Color.fromRGBO(110, 121, 183, 0.749),
                              shape: StadiumBorder(),
                            ),
                            onPressed: _updateProfile,
                            child: Text(
                              'Editar perfil',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          SizedBox(height: 70),
                          TextButton(
                            onPressed: _logout,
                            child: Text(
                              'Cerrar sesión',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
    );
  }
}

class DrawClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    double xCenter = size.width * 0.5;
    double yCenter = size.height;
    path.quadraticBezierTo(xCenter, yCenter, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
