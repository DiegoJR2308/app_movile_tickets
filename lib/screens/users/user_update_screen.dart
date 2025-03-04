import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarea_integradora/screens/users/users_screen.dart';
import '../../apiservices/api_services.dart';

class UserUpdateScreen extends StatefulWidget {
  final int userId;
  final String userRole;
  final String userNombre;
  final String userCorreo;

  const UserUpdateScreen({super.key, required this.userId, required this.userRole, required this.userNombre, required this.userCorreo});

  @override
  _UserUpdateScreenState createState() => _UserUpdateScreenState();
}

class _UserUpdateScreenState extends State<UserUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? userDetails;
  bool isLoading = true;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _aPaternoController = TextEditingController();
  final TextEditingController _aMaternoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  List<dynamic> _roles = [];
  int? _selectedRolId;
  bool isShowingAlert = false;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    fetchRoles();
  }

  Future<void> fetchRoles() async {
    try {
      final fetchedRoles = await ApiServices.fetchRoles();
      setState(() {
        _roles = fetchedRoles;
        _setSelectedRolId();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchUserDetails() async {
    try {
      final details = await ApiServices.fetchUserDetails(widget.userId);
      setState(() {
        userDetails = details as Map<String, dynamic>?;
        isLoading = false;
        _nombreController.text = userDetails!['nombre'];
        _aPaternoController.text = userDetails!['apellido_paterno'];
        _aMaternoController.text = userDetails!['apellido_materno'];
        _emailController.text = userDetails!['correo'];
        _setSelectedRolId();
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _setSelectedRolId() {
    if (userDetails != null && _roles.isNotEmpty) {
      final userRolName = userDetails!['rol'];
      final selectedRol = _roles.firstWhere(
          (role) => role['nombre'] == userRolName,
          orElse: () => null);
      if (selectedRol != null) {
        setState(() {
          _selectedRolId = selectedRol['id'];
        });
      }
    }
  }

  Future<void> updateUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await ApiServices.updateUser(
          userDetails!['id'] as int,
          _selectedRolId!,
          _nombreController.text,
          _aPaternoController.text,
          _aMaternoController.text,
          _emailController.text,
        );

        if (response['success'] == true) {
          print("Usuario actualizado correctamente");
          Navigator.pop(context, true); // Indicar que la actualización fue exitosa
        } else {
          print('Error: ${response['error']}');
        }
      } catch (e) {
        print('Error acaaaaaaaa: $e');
      }
    }
  }

  Future<void> _updateUser() async {
    if (isShowingAlert) return;
    setState(() {
      isShowingAlert = true;
    });
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            setState(() {
              isShowingAlert = false;
            });
            return true;
          },
          child: CupertinoAlertDialog(
            title: const Text('Actualizar info de usuario'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Deseas actualizar la información del usuario?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Sí',
                    style: TextStyle(color: Colors.greenAccent)),
                onPressed: () {
                  updateUser(context);
                  Navigator.of(context).pop(); // Mover esta línea aquí
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UsersScreen(userRole: widget.userRole, userId: widget.userId.toString(), userNombre:widget.userNombre, userCorreo: widget.userCorreo),
                    ),
                  );
                  setState(() {
                    isShowingAlert = false;
                  });
                },
              ),
              TextButton(
                child: const Text('No', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    isShowingAlert = false;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xff282828) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Color(0xff282828) : Colors.white,
        title: Text('Actualizar Usuario'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userDetails == null
              ? Center(child: Text('Error al cargar los detalles del usuario'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: _nombreController,
                          decoration: InputDecoration(labelText: 'Nombre'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa un nombre';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _aPaternoController,
                          decoration:
                              InputDecoration(labelText: 'Apellido Paterno'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa un nombre';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _aMaternoController,
                          decoration:
                              InputDecoration(labelText: 'Apellido Materno'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa un nombre';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _emailController,
                          decoration:
                              InputDecoration(labelText: 'Correo Electrónico'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa un correo electrónico';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            labelText: 'Rol',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor:
                                isDarkMode ? Colors.grey[800] : Colors.white,
                            labelStyle: TextStyle(
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
                          ),
                          items: _roles.map<DropdownMenuItem<int>>((role) {
                            return DropdownMenuItem<int>(
                              value: role['id'],
                              child: Text(role['nombre']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRolId = value;
                              print(_selectedRolId);
                            });
                          },
                          value: _selectedRolId,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _updateUser,
                          child: Text('Actualizar Usuario'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
