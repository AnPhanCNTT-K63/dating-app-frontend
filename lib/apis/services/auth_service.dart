import 'package:app/apis/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<void> loginGoogle(String token) async {
     await _apiService.post("auth/google-login", {
      "token": token,
    });
  }
// Register
  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final response = await _apiService.post("auth/signup", {
      "username": username,
      "email": email,
      "password": password,
      "fmcToken": ''
    });

    return response;
  }
}