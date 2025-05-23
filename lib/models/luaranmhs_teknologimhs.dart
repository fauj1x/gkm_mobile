// lib/models/teknologi_karya_mahasiswa_model.dart
import 'package:flutter/material.dart'; // Hanya untuk DateTime, bisa dihapus jika tidak ada DateTime

class TeknologiKaryaMahasiswaModel {
  final int id;
  final int userId;
  final String luaranPenelitian;
  final String tahun;
  final String keterangan;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  TeknologiKaryaMahasiswaModel({
    required this.id,
    required this.userId,
    required this.luaranPenelitian,
    required this.tahun,
    required this.keterangan,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeknologiKaryaMahasiswaModel.fromJson(Map<String, dynamic> json) {
    return TeknologiKaryaMahasiswaModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      luaranPenelitian: json['luaran_penelitian'] as String,
      tahun: json['tahun'] as String,
      keterangan: json['keterangan'] as String,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'luaran_penelitian': luaranPenelitian,
      'tahun': tahun,
      'keterangan': keterangan,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}