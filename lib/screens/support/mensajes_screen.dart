import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarea_integradora/screens/calif/calif_support_form_screen.dart';
//import 'package:tarea_integradora/screens/calif/calificaciones_screen.dart';
import 'package:tarea_integradora/screens/support/tickets_screen.dart';
import '../../apiservices/api_services.dart';

class MensajesScreen extends StatefulWidget {
  final int ticketId;
  final String ticketTitle;
  final String ticketEstatus;
  final int userId;
  final int idOperador;
  final String userRol;
  final String userCorreo;
  final String userNombre;

  const MensajesScreen(
    {
      super.key,
      required this.ticketId,
      required this.ticketTitle,
      required this.ticketEstatus,
      required this.userId,
      required this.userRol,
      required this.idOperador,
      required this.userCorreo,
      required this.userNombre
    }
  );

  @override
  _MensajesScreenState createState() => _MensajesScreenState();
}

class _MensajesScreenState extends State<MensajesScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<dynamic> messages = [];
  bool _isPolling = true;
  bool isShowingAlert =
      false;

  @override
  void initState() {
    super.initState();
    fetchMessages();
    startPolling();
  }

  @override
  void dispose() {
    _isPolling = false;
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchMessages() async {
    try {
      final fetchedMessages = await ApiServices.fetchMessages(widget.ticketId);
      setState(() {
        messages = fetchedMessages;
      });
      _scrollToBottom();
    } catch (e) {
      print('Error: $e');
    }
  }

  void startPolling() async {
    const duration = Duration(seconds: 2);
    while (_isPolling) {
      await fetchMessages();
      await Future.delayed(duration);
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    try {
      await ApiServices.sendMessage(
        widget.ticketId,
        widget.userId,
        _messageController.text.trim(),
      );
      _messageController.clear();
      await fetchMessages();
    } catch (e) {
      print('Error: $e');
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  Future<void> cerrarTicket(BuildContext context) async {
    try {
      await ApiServices.cerrarTicket(widget.ticketId);
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> _cerrarTicket() async {
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
            title: const Text('Cerrar ticket'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Deseas cerrar el ticket?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Si',
                    style: TextStyle(color: Colors.greenAccent)),
                onPressed: () {
                  cerrarTicket(context);
                  Navigator.of(context).pop();
                  setState(() {
                    isShowingAlert = false;
                  });
                  _calificarSoporte();
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

  Future<void> _calificarSoporte() async {
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
            title: const Text('Calificar soporte técnico'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Deseas calificar el soporte que se te brindó?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Si',
                    style: TextStyle(color: Colors.greenAccent)),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalifSupportFormScreen(idOperador: widget.idOperador, tituloMensaje: widget.ticketTitle, userId: widget.userId, userRol: widget.userRol, userCorreo: widget.userCorreo, userNombre: widget.userNombre),
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketsScreen(
                          userId: widget.userId,
                          userRol: widget.userRol,
                          userCorreo: widget.userCorreo,
                          userNombre: widget.userNombre),
                    ),
                  );
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
        title: widget.userRol == "Cliente"
            ? Text(
                widget.ticketTitle,
                style: TextStyle(fontSize: 20),
              )
            : Text(
                widget.ticketTitle,
                style: TextStyle(fontSize: 22),
              ),
        centerTitle: widget.userRol == "Cliente" 
        ? widget.ticketEstatus == "abierto"
        ? false 
        :
        true
        : true,
        actions: [
          widget.userRol == "Cliente"
              ? widget.ticketEstatus == "abierto"
              ? TextButton(
                  onPressed: _cerrarTicket,
                  child: Text(
                    "Cerrar Ticket",
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                )
              :Text("")
              : Text("")
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(child: Text('No hay mensajes'))
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message['id_usuario'] == widget.userId;
                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: isMe
                                ? const Color.fromARGB(255, 4, 84, 150)
                                : const Color.fromARGB(255, 48, 48, 48),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['mensaje'],
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              SizedBox(height: 5),
                              Text(
                                '${message['fecha']} - ${message['nombre']}',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Escribir un mensaje...',
                      border: OutlineInputBorder(),
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
