import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String baseUrl = ApiService().baseUrl;

  Future<bool> login(String email, String password) async {
    final response = await http.post(Uri.parse('$baseUrl/token'), body: {
      'email': email,
      'password': password,
    }, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      await setTokenId(decodedResponse['token'], decodedResponse['id'].toString());
      notifyListeners();
      return true;
    }

    return false;
  }

  setTokenId(String token, String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('id', id);
  }

  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }

  Future<bool> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null;
  }
}
