// lib/models/user_profile.dart
import 'package:flutter/foundation.dart'; // Digunakan untuk @required jika diperlukan, tapi tidak wajib untuk final.

class UserProfile {
  final int id;
  final String nip;
  final String nik;
  final String nidn;
  final String nama;
  final String jabatanFungsional;
  final int jabatanId;
  final String handphone;
  final int userId;

  UserProfile({
    required this.id,
    required this.nip,
    required this.nik,
    required this.nidn,
    required this.nama,
    required this.jabatanFungsional,
    required this.jabatanId,
    required this.handphone,
    required this.userId,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      // Menggunakan operator null-aware coalescing (??) dan tryParse untuk keamanan
      id: int.tryParse(json['id'].toString()) ?? 0,
      nip: json['nip'] as String? ?? '',
      nik: json['nik'] as String? ?? '',
      nidn: json['nidn'] as String? ?? '',
      nama: json['nama'] as String? ?? '',
      jabatanFungsional: json['jabatan_fungsional'] as String? ?? '',
      jabatanId: int.tryParse(json['jabatan_id'].toString()) ?? 0,
      handphone: json['handphone'] as String? ?? '',
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
    );
  }

  // Menambahkan metode toJson untuk kemudahan serialisasi data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nip': nip,
      'nik': nik,
      'nidn': nidn,
      'nama': nama,
      'jabatan_fungsional': jabatanFungsional,
      'jabatan_id': jabatanId,
      'handphone': handphone,
      'user_id': userId,
    };
  }
}
