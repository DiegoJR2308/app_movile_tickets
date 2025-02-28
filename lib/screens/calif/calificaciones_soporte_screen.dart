import 'package:flutter/material.dart';
import 'calificacion_soporte_detail._screen.dart';
import '../../apiservices/api_services.dart';

class CalificacionesSoporteScreen extends StatefulWidget {
  final int id_operador;

  const CalificacionesSoporteScreen({super.key, required this.id_operador});

  @override
  _CalificacionesSoporteScreenState createState() => _CalificacionesSoporteScreenState();
}

class _CalificacionesSoporteScreenState extends State<CalificacionesSoporteScreen> {
  List<Map<String, dynamic>> calificaciones = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCalificaciones();
  }

  Future<void> fetchCalificaciones() async {
    try {
      final fetchedCalificaciones = await ApiServices.fetchCalificacionesSoporte(widget.id_operador);
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

  Widget _buildStars(double calificacion) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (calificacion >= i) {
        stars.add(Icon(Icons.star, color: Colors.amber));
      } else if (calificacion >= i - 0.5) {
        stars.add(Icon(Icons.star_half, color: Colors.amber));
      } else {
        stars.add(Icon(Icons.star_border, color: Colors.amber));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stars,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calificaciones de Soporte'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
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
                      title: Text('${calificacion['numero_serie']}', style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Calificación promedio'),
                          _buildStars(double.tryParse(calificacion['promedio']) ?? 0.0),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CalificacionSoporteDetailScreen(
                              calificacionId: calificacion['id'],
                              nombreOperador: calificacion['nombre_operador'],
                              promedio: double.tryParse(calificacion['promedio']) ?? 0.0,
                              numeroSerie: calificacion['numero_serie'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
