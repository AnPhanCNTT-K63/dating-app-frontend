import 'package:app/apis/api_service.dart';
import 'package:app/models/user-profile_model.dart';

class ProfileService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> updateProfile(UserProfile profile) async {

    var response = await _apiService.patch("profile/update", profile.toJson());

    return response;
  }

  Future<Map<String, dynamic>> getProfile(String id) async {
    var response = await _apiService.get("user/$id");

    return response;
  }

  Future<Map<String, dynamic>> getAllUsers() async {
    var response = await _apiService.get("user");

    return response;
  }

}