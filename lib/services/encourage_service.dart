import 'dart:convert';
import 'package:http/http.dart' as http;

class EncourageService {
    final String _baseUrl =
        const String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:8000');

    Future<Map<String, dynamic>> encourage(Map<String, dynamic> expense) async {
        final res = await http.post(
            Uri.parse('$_baseUrl/encourage'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(expense),
        );

        if (res.statusCode == 200) {
            return jsonDecode(res.body) as Map<String, dynamic>;
        } else {
            throw Exception('API error ${res.statusCode}: ${res.body}');
        }
    }
}
