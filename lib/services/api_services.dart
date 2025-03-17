import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gkm_mobile/models/user_profiles.dart';  // Import model dengan path yang benar

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000";

  // Get all user profiles
  Future<List<UserProfile>> getUserProfiles() async {
    final response = await http.get(Uri.parse("$baseUrl/user-profiles"));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => UserProfile.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load user profiles");
    }
  }
}
