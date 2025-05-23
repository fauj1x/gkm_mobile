// lib/models/tema_penelitian_mahasiswa.dart
import 'package:flutter/material.dart'; // Hanya untuk DateTime, bisa dihapus jika tidak ada DateTime

class TemaPenelitianMahasiswa {
  final int id;
  final int userId;
  final String tema;
  final String namaMhs;
  final String judul;
  final String tahun;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  TemaPenelitianMahasiswa({
    required this.id,
    required this.userId,
    required this.tema,
    required this.namaMhs,
    required this.judul,
    required this.tahun,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TemaPenelitianMahasiswa.fromJson(Map<String, dynamic> json) {
    return TemaPenelitianMahasiswa(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tema: json['tema'] as String? ?? '',
      namaMhs: json['nama_mhs'] as String? ?? '',
      judul: json['judul'] as String? ?? '',
      tahun: json['tahun'] as String? ?? '',
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'tema': tema,
      'nama_mhs': namaMhs,
      'judul': judul,
      'tahun': tahun,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}