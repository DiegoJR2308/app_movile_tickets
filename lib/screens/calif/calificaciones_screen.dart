import 'package:flutter/material.dart';
import '../../apiservices/api_services.dart';

class CalificacionesScreen extends StatefulWidget {
  const CalificacionesScreen({super.key});

  @override
  _CalificacionesScreenState createState() => _CalificacionesScreenState();
}

class _CalificacionesScreenState extends State<CalificacionesScreen> {
  List<Map<String, dynamic>> calificaciones = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCalificaciones();
  }

  Future<void> fetchCalificaciones() async {
    try {
      final fetchedCalificaciones = await ApiServices.fetchCalificaciones();
      setState(() {
        calificaciones = fetchedCalificaciones;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildStars(int calificacion) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      stars.add(Icon(
        i < calificacion ? Icons.star : Icons.star_border,
        color: Colors.amber,
      ));
    }
    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xff282828) : const Color.fromARGB(255, 247, 247, 247),
      appBar: AppBar(
        backgroundColor: isDarkMode ? Color(0xff282828) : const Color.fromARGB(255, 247, 247, 247),
        title: Text('Calificaciones de Servicios'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
              )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: calificaciones.length,
                itemBuilder: (context, index) {
                  final calificacion = calificaciones[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    elevation: 12,
                    child: ListTile(
                      title: Text(
                          '${calificacion['nombre']} ${calificacion['apellido_paterno']} ${calificacion['apellido_materno']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Servicio: ${calificacion['nombre_servicio']}'),
                          _buildStars(int.parse(calificacion['calificacion'])),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
