import 'dart:convert';
import 'package:gkm_mobile/services/auth.dart';
import 'package:http/http.dart' as http;

/// Utility untuk mengubah CamelCase ke snake_case
String _camelToSnake(String input) {
  final RegExp regex = RegExp(r'(?<=[a-z])[A-Z]');
  return input
      .replaceAllMapped(regex, (Match m) => '_${m.group(0)}')
      .toLowerCase();
}

class ApiService {
  String baseUrl = "https://gkm-polije.com/api";
  // String baseUrl = "http://localhost:9000/api";

  // Fungsi umum untuk GET semua data
  Future<List<T>> getData<T>(
      T Function(Map<String, dynamic>) fromJson, String? customEndpoint) async {
    String endpoint = customEndpoint ?? _camelToSnake(T.toString());
    final response = await http.get(
      Uri.parse("$baseUrl/$endpoint"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthProvider().getToken()}",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = decoded is Map && decoded.containsKey('data')
          ? decoded['data']
          : decoded;
      return List<Map<String, dynamic>>.from(data)
          .map((json) => fromJson(json))
          .toList();
    } else {
      throw Exception("Gagal memuat data dari $endpoint: ${response.body}");
    }
  }

  // Fungsi POST data
  Future<T> postData<T>(T Function(Map<String, dynamic>) fromJson,
      Map<String, dynamic> body, String? customEndpoint) async {
    String endpoint = customEndpoint ?? _camelToSnake(T.toString());
    final response = await http.post(
      Uri.parse("$baseUrl/$endpoint"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthProvider().getToken()}",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Gagal menyimpan data ke $endpoint: ${response.body}");
    }
  }

  // Fungsi PUT data
  Future<T> updateData<T>(T Function(Map<String, dynamic>) fromJson, int id,
      Map<String, dynamic> body, String? customEndpoint) async {
    String endpoint = customEndpoint ?? _camelToSnake(T.toString());
    final response = await http.put(
      Uri.parse("$baseUrl/$endpoint/$id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthProvider().getToken()}",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Gagal mengupdate data di $endpoint: ${response.body}");
    }
  }

  // Fungsi DELETE data
  Future<void> deleteData<T>(
    int id,
    String? customEndpoint,
  ) async {
    String endpoint = customEndpoint ?? _camelToSnake(T.toString());
    final response = await http.delete(
      Uri.parse("$baseUrl/$endpoint/$id"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthProvider().getToken()}",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal menghapus data dari $endpoint: ${response.body}");
    }
  }
}
