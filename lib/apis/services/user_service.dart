import 'package:app/apis/api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();


  Future<Map<String, dynamic>> getAllUsers() async {
    var response = await _apiService.get("user");

    return response;
  }

}