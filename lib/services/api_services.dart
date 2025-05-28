import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:gkm_mobile/services/auth.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Utility untuk mengubah CamelCase ke snake_case
String _camelToSnake(String input) {
  final RegExp regex = RegExp(r'(?<=[a-z])[A-Z]');
  return input
      .replaceAllMapped(regex, (Match m) => '_${m.group(0)}')
      .toLowerCase();
}

class ApiService {
  // String baseUrl = "https://www.gkm-polije.com/api";
  String baseUrl = "http://10.0.2.2:8000/api";

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

  Future<Map<String, dynamic>> getRekapData({
    required String tahunAjaranSlug, // contoh: "2023-2024-ganjil"
    required int userId,
    String? semester, // opsional
  }) async {
    // Susun path endpoint sesuai route baru
    String path = "$baseUrl/rekap/$userId/$tahunAjaranSlug";

    // Bangun Uri dengan query semester jika ada
    final uri = Uri.parse(path).replace(
      queryParameters: semester != null && semester.isNotEmpty
          ? {"semester": semester}
          : null,
    );

    final response = await http.get(
      uri,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthProvider().getToken()}",
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['data'];
    } else {
      throw Exception("Gagal mengambil data rekap: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> importExcel({
    required int userId,
    required String filePath,
  }) async {
    final url = Uri.parse("$baseUrl/import-excel/$userId");
    final token = await AuthProvider().getToken();

    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    print('DEBUG: Mulai request import excel');
    print('DEBUG: url: $url');
    print('DEBUG: userId: $userId');

    final request = http.MultipartRequest('POST', url)
      ..headers.addAll(headers)
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          filePath,
          filename: filePath.split('/').last,
        ),
      );

    print('DEBUG: Headers: ${request.headers}');
    print('DEBUG: Files: ${request.files.length}');

    final streamedResponse = await request.send();
    print('DEBUG: streamedResponse statusCode: ${streamedResponse.statusCode}');
    print('DEBUG: streamedResponse message: ${streamedResponse.reasonPhrase}');

    final response = await http.Response.fromStream(streamedResponse);
    print('DEBUG: response.statusCode: ${response.statusCode}');
    print('DEBUG: response.body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('DEBUG: Import excel berhasil');
      return jsonDecode(response.body);
    } else {
      print('DEBUG: Import excel gagal');
      throw Exception("Gagal import excel: ${response.body}");
    }
  }

  Future<Uint8List> exportExcel({
    required int userId,
  }) async {
    final url = Uri.parse("$baseUrl/export-excel/$userId");
    final token = await AuthProvider().getToken();

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('DEBUG: Berhasil mengunduh file Excel');
      return response.bodyBytes;
    } else {
      throw Exception("Gagal mengunduh file: ${response.body}");
    }
  }
}
