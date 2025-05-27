import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/models/user_profiles.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String baseUrl = ApiService().baseUrl;

  Future<int> login(String email, String password) async {
    var status = 0;
    final response = await http.post(Uri.parse('$baseUrl/token'), body: {
      'email': email,
      'password': password,
    }, headers: {
      'Accept': 'application/json',
    });
    final decodedResponse = jsonDecode(response.body);
    status = response.statusCode;

    switch (status) {
      case 200:
        await setTokenId(
            decodedResponse['token'], decodedResponse['id'].toString());
        notifyListeners();
        return status;
      case 401:
        debugPrint('Login failed: Email atau password salah');
        return status;
      case 403:
        debugPrint('Login failed: Email belum diverifikasi.');
        return status;
      case 422:
        debugPrint('Login failed: Validasi gagal.');
        return status;
      default:
        debugPrint('Login failed: response_code: $status');
        debugPrint('Login failed: response_body: $decodedResponse');
        return status;
    }
  }

  Future<int> register(
      String name, String username, String email, String password) async {
    var status = 0;
    final response = await http.post(Uri.parse('$baseUrl/register'), body: {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'password_confirmation': password,
    }, headers: {
      'Accept': 'application/json',
    });
    final decodedResponse = jsonDecode(response.body);
    status = response.statusCode;

    switch (status) {
      case 200:
        return status;
      case 401:
        debugPrint('Register failed: Validasi gagal.');
        return status;
      default:
        debugPrint('Register failed: response_code: $status');
        debugPrint('Register failed: response_body: $decodedResponse');
        return status;
    }
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
    if (token == null || token.isEmpty) {
      return false;
    }
    try {
      await ApiService().getData<TahunAjaran>(
        TahunAjaran.fromJson,
        'tahun-ajaran',
      );
    } catch (e) {
      print('Error fetching user profile: $e');
      return false;
    }
    return true;
  }
}
