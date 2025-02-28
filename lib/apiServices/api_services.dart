import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String baseUrl = 'https://codexxdev.com/ws';

  static Future<Map<String, dynamic>> login(
      String correo, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login2'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'correo': correo,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchTickets() async {
    final response = await http.get(Uri.parse('$baseUrl/tickets'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar los tickets');
    }
  }

  static Future<List<dynamic>> fetchTicketsByCliente(int clienteId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/tickets?id_cliente=$clienteId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar los tickets del cliente');
    }
  }

  static Future<List<dynamic>> fetchTicketsByOperador(int operadorId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/tickets?id_operador=$operadorId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar los tickets del operador');
    }
  }

  static Future<List<dynamic>> fetchMessages(int ticketId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/mensajes?ticket_id=$ticketId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar los mensajes');
    }
  }

  static Future<void> sendMessage(
      int ticketId, int userId, String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/mensajes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_ticket': ticketId,
        'id_usuario': userId,
        'mensaje': message,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al enviar el mensaje');
    }
  }

  // Nueva función para crear cuenta
  static Future<Map<String, dynamic>> createAccount(
      String rol,
      String nombre,
      String apPaterno,
      String apMaterno,
      String correo,
      String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuariosM'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'rol': rol,
        'nombre': nombre,
        'apellido_materno': apMaterno,
        'apellido_paterno': apPaterno,
        'correo': correo,
        'contrasena': password
      }),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      throw Exception('Error al crear la cuenta: ${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchServices() async {
    final response = await http.get(Uri.parse('$baseUrl/servicioM'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar los servicios');
    }
  }

  static Future<Map<String, dynamic>> createTicket(
      int userId, String titulo, String descripcion, int idServicio) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tickets'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_cliente': userId,
        'descripcion': descripcion,
        'id_servicio': idServicio
      }),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      throw Exception('Error al crear el ticket: ${response.statusCode}');
    }
  }

  static Future<Map> fetchAccount(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/usuariosM?id=$userId'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse is List) {
        return jsonResponse[0] as Map<String,
            dynamic>; // Devuelve el primer elemento si es una lista
      } else if (jsonResponse is Map) {
        return jsonResponse;
      } else {
        throw Exception('Respuesta inesperada del servidor');
      }
    } else {
      throw Exception('Error al obtener los detalles del usuario');
    }
  }

  static Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/usuariosM'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar los mensajes');
    }
  }

  static Future<Map> fetchUserDetails(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/usuariosM?id=$userId'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse is List) {
        return jsonResponse[0] as Map<String,
            dynamic>; // Devuelve el primer elemento si es una lista
      } else if (jsonResponse is Map) {
        return jsonResponse;
      } else {
        throw Exception('Respuesta inesperada del servidor');
      }
    } else {
      throw Exception('Error al obtener los detalles del usuario');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchCalificaciones() async {
    final response = await http.get(Uri.parse('$baseUrl/calificacion'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener las calificaciones');
    }
  }

  static Future<void> calificarSoporte(
      Map<String, dynamic> calificacionData) async {
    final url = Uri.parse('$baseUrl/calificacion_soporte');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(calificacionData),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al enviar la calificación');
    }
  }

  static Future<void> cerrarTicket(int ticketId) async {
    final url = Uri.parse('$baseUrl/tickets');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': ticketId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al cerrar el ticket');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchCalificacionesSoporte(
      int idOperador) async {
    final response = await http.get(
        Uri.parse('$baseUrl/calificacion_soporte?id_operador=$idOperador'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener las calificaciones');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchCalificacionDetailSoporte(
      int calificacionId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/calificacion_soporte?id=$calificacionId'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener las calificaciones');
    }
  }

  static Future<List<dynamic>> fetchRoles() async {
    final response = await http.get(Uri.parse('$baseUrl/roles'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar los roles');
    }
  }

  static Future<Map<String, dynamic>> updateUser(int userId, int rol,
      String nombre, String apPaterno, String apMaterno, String correo) async {
    final response = await http.put(
      Uri.parse('$baseUrl/usuariosM'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': userId.toString(),
        'rol': rol.toString(),
        'nombre': nombre,
        'apellido_materno': apMaterno,
        'apellido_paterno': apPaterno,
        'correo': correo,
      }),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      throw Exception('Error al actualizar el usuario: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> createRol(String nombre) async {
    final response = await http.post(
      Uri.parse('$baseUrl/roles'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'rol': nombre,
      }),
    );
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      throw Exception('Error al crear el ticket: ${response.statusCode}');
    }
  }
}
