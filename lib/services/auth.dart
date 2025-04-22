import 'package:flutter/material.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  String baseUrl = ApiService().baseUrl;

  Future<bool> login(String email, String password) async {
    final response = await http.post(Uri.parse('$baseUrl/token'), body: {
      'email': email,
      'password': password,
    }, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      String token = response.body;
      await setToken(token);
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }

    return false;
  }

  setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
