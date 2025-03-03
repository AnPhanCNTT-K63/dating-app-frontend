import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:3000";

  Future<Map<String, dynamic>> test() async {
    final url = Uri.parse("$baseUrl/");

    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to connect");
    }
  }
}

void main() async {
  ApiService apiService = ApiService();

  try {
    final result = await apiService.test();
    print("API Response: $result");
  } catch (e) {
    print("Error: $e");
  }
}
