import 'package:flutter/material.dart';
import '../../apiservices/api_services.dart';
import 'mensajes_screen.dart';
import 'create_ticket_screen.dart'; // Importa la pantalla de crear ticket
import '../home/main_screen.dart'; // Importa la pantalla principal

class TicketsScreen extends StatefulWidget {
  final int userId;
  final String userRol;
  final String userCorreo;
  final String userNombre; // Añadido para recibir el rol del usuario

  const TicketsScreen(
      {super.key,
      required this.userId,
      required this.userRol,
      required this.userCorreo,
      required this.userNombre});

  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  List<dynamic> tickets = [];

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    try {
      List<dynamic> fetchedTickets;
      if (widget.userRol == 'Cliente') {
        fetchedTickets = await ApiServices.fetchTicketsByCliente(widget.userId);
      } else if (widget.userRol == 'Operador') {
        fetchedTickets =
            await ApiServices.fetchTicketsByOperador(widget.userId);
      } else if (widget.userRol == 'Administrador') {
        fetchedTickets = await ApiServices.fetchTickets();
      } else {
        fetchedTickets = [];
      }

      setState(() {
        tickets = fetchedTickets;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(
              id: widget.userId.toString(),
              rol: widget.userRol,
              nombre: widget.userNombre,
              correo: widget.userCorreo // Proporciona el correo del usuario si es posible
            ),
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: isDarkMode ? Color(0xff282828) : Colors.white,
        appBar: AppBar(
          backgroundColor: isDarkMode ? Color(0xff282828) : Colors.white,
          title: Text("Tickets"),
        ),
        body: Center(
          child: tickets.isEmpty
              ? Text('Ningún ticket levantado')
              : ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return Card(
                      elevation: 15,
                      child: ListTile(
                        title: Text(ticket['n_serie']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fecha de creación: ${ticket['fecha_creacion']}'),  
                                                      
                            Text('Estado: ${ticket['estado']}'),
                            Text('Servicio: ${ticket['nombre_servicio']}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MensajesScreen(
                                ticketId: ticket['id'],
                                ticketTitle: ticket['n_serie'],
                                userId: widget.userId,
                                userRol: widget.userRol,
                                userCorreo: widget.userCorreo,
                                userNombre: widget.userNombre,
                                idOperador: ticket['id_operador'], 
                                ticketEstatus: ticket['estado']
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
        floatingActionButton: widget.userRol == 'Cliente'
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateTicketScreen(userId: widget.userId, userRol: widget.userRol, userCorreo: widget.userCorreo, userNombre: widget.userNombre)),
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
