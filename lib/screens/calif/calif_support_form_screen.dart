import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tarea_integradora/screens/support/tickets_screen.dart';
import '../../apiservices/api_services.dart';

class CalifSupportFormScreen extends StatefulWidget {
  final int userId;
  final String userRol;
  final String userCorreo;
  final String userNombre;

  final int idOperador;
  final String tituloMensaje;

  const CalifSupportFormScreen(
      {super.key,
      required this.idOperador,
      required this.tituloMensaje,
      required this.userId,
      required this.userRol,
      required this.userCorreo,
      required this.userNombre});

  @override
  _CalifSupportFormScreenState createState() => _CalifSupportFormScreenState();
}

class _CalifSupportFormScreenState extends State<CalifSupportFormScreen> {
  final List<double> _ratings = List<double>.filled(5, 0.0);
  bool _isLoading = false;

  Future<void> _submitCalificacion() async {
    setState(() {
      _isLoading = true;
    });

    final calificacionData = {
      'p1': _ratings[0].round(),
      'p2': _ratings[1].round(),
      'p3': _ratings[2].round(),
      'p4': _ratings[3].round(),
      'p5': _ratings[4].round(),
      'id_operador': widget.idOperador,
      'numero_serie': widget.tituloMensaje,
    };

    try {
      await ApiServices.calificarSoporte(calificacionData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Calificación enviada exitosamente')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TicketsScreen(userId: widget.userId, userRol: widget.userRol, userCorreo: widget.userCorreo, userNombre: widget.userNombre),
        ),
      ); // Regresar a la pantalla anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar la calificación: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildRatingBar(int index) {
    return RatingBar.builder(
      initialRating: _ratings[index],
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _ratings[index] = rating;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xff282828) : const Color.fromARGB(255, 247, 247, 247),
      appBar: AppBar(
        backgroundColor: isDarkMode ? Color(0xff282828) : const Color.fromARGB(255, 247, 247, 247),
        title: Text('Calificar Soporte Técnico'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(
                    'Calificar al operador por: ${widget.tituloMensaje}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text('Pregunta 1: ¿Cómo calificas la atención del operador?'),
                  _buildRatingBar(0),
                  SizedBox(height: 20),
                  Text('Pregunta 2: ¿Qué tal la rapidez en la respuesta?'),
                  _buildRatingBar(1),
                  SizedBox(height: 20),
                  Text(
                      'Pregunta 3: ¿Cómo evaluarías la solución del problema?'),
                  _buildRatingBar(2),
                  SizedBox(height: 20),
                  Text(
                      'Pregunta 4: ¿Fue claro el operador en sus explicaciones?'),
                  _buildRatingBar(3),
                  SizedBox(height: 20),
                  Text('Pregunta 5: ¿Recomendarías este operador?'),
                  _buildRatingBar(4),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _submitCalificacion,
                    child: Text('Enviar Calificación'),
                  ),
                ],
              ),
            ),
    );
  }
}
