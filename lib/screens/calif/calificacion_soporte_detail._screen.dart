import 'package:flutter/material.dart';
import '../../apiservices/api_services.dart';

class CalificacionSoporteDetailScreen extends StatefulWidget {
  final int calificacionId;
  final String nombreOperador;
  final double promedio;
  final String numeroSerie;

  const CalificacionSoporteDetailScreen({
    super.key,
    required this.calificacionId,
    required this.nombreOperador,
    required this.promedio,
    required this.numeroSerie,
  });

  @override
  _CalificacionSoporteDetailScreenState createState() => _CalificacionSoporteDetailScreenState();
}

class _CalificacionSoporteDetailScreenState extends State<CalificacionSoporteDetailScreen> {
  Map<String, dynamic>? calificacion;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCalificacion();
  }

  Future<void> fetchCalificacion() async {
    try {
      final fetchedCalificaciones = await ApiServices.fetchCalificacionDetailSoporte(widget.calificacionId);
      setState(() {
        if (fetchedCalificaciones.isNotEmpty) {
          calificacion = fetchedCalificaciones.first;
        }
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
        title: Text('Detalle de Calificación'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 46, 46, 46),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Ticket: ${widget.numeroSerie}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Promedio: ${widget.promedio}',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 10),
                              _buildStars(widget.promedio),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 46, 46, 46),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Calificacion por pregunta',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('1. ¿Cómo calificas la atención del operador?'),
                              SizedBox(height: 5),
                              _buildStars(calificacion != null ? calificacion!['p1'].toDouble() : 0.0),
                              SizedBox(height: 10),
                              Text('2. ¿Qué tal la rapidez en la respuesta?'),
                              SizedBox(height: 5),
                              _buildStars(calificacion != null ? calificacion!['p2'].toDouble() : 0.0),
                              SizedBox(height: 10),
                              Text('3. ¿Cómo evaluarías la solución del problema?'),
                              SizedBox(height: 5),
                              _buildStars(calificacion != null ? calificacion!['p3'].toDouble() : 0.0),
                              SizedBox(height: 10),
                              Text('4. ¿Fue claro el operador en sus explicaciones?'),
                              SizedBox(height: 5),
                              _buildStars(calificacion != null ? calificacion!['p4'].toDouble() : 0.0),
                              SizedBox(height: 10),
                              Text('5. ¿Recomendarías este operador?'),
                              SizedBox(height: 5),
                              _buildStars(calificacion != null ? calificacion!['p5'].toDouble() : 0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
