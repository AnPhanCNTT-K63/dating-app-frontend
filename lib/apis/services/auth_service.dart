import 'package:app/apis/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<void> loginGoogle(String token) async {
     await _apiService.post("auth/google-login", {
      "token": token,
    });
  }

}