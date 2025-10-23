import 'dart:convert';

import 'package:http/http.dart' as http;

class FeedbackApi {
  static const String _baseUrl = 'https://eopljh2fwathrfi.m.pipedream.net';

  Future<String> sendFeedback(String comment) async {
    try {
      final uri = Uri.parse(_baseUrl);
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'comment': comment}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final token = data['token'] as String?;

        if (token != null) {
          return token;
        }
      }
      throw Exception('Respuesta inválida');
    } catch (e) {
      throw Exception('Respuesta inválida');
    }
  }
}
