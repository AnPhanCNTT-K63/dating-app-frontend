import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://dating-app-api-h6tc.onrender.com/api";

  Future<Map<String, dynamic>> test() async {
    final url = Uri.parse("$baseUrl/");

    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to log in");
    }
  }
}
