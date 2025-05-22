// lib/models/sitasi_mahasiswa.dart
import 'package:flutter/material.dart'; // Import ini hanya jika Anda menggunakan DateTime, jika tidak bisa dihapus.

class SitasiMahasiswa {
  final int id;
  final int userId;
  final String namaMahasiswa;
  final String judulArtikel;
  final int jumlahSitasi;
  final String tahun;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  SitasiMahasiswa({
    required this.id,
    required this.userId,
    required this.namaMahasiswa,
    required this.judulArtikel,
    required this.jumlahSitasi,
    required this.tahun,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor untuk membuat instance dari Map (JSON)
  factory SitasiMahasiswa.fromJson(Map<String, dynamic> json) {
    return SitasiMahasiswa(
      // Menggunakan int.tryParse dan null-aware operator untuk keamanan konversi
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      namaMahasiswa: json['nama_mahasiswa'] as String? ?? '', // Default string kosong jika null
      judulArtikel: json['judul_artikel'] as String? ?? '', // Default string kosong jika null
      jumlahSitasi: int.tryParse(json['jumlah_sitasi'].toString()) ?? 0,
      tahun: json['tahun'] as String? ?? '', // Default string kosong jika null
      // Menggunakan DateTime.tryParse untuk tanggal yang bisa null
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']), // Diasumsikan selalu ada
      updatedAt: DateTime.parse(json['updated_at']), // Diasumsikan selalu ada
    );
  }

  // Metode untuk mengkonversi instance ke Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'nama_mahasiswa': namaMahasiswa,
      'judul_artikel': judulArtikel,
      'jumlah_sitasi': jumlahSitasi,
      'tahun': tahun,
      'deleted_at': deletedAt?.toIso8601String(), // Menggunakan ?. untuk null-safety
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
