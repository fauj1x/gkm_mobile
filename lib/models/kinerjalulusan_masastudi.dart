import 'package:flutter/material.dart';

class MasaStudiLulusanModel {
  final int id;
  final int userId;
  final String tahun;
  final String? masaStudi; // New field, can be null
  final int jumlahMhsDiterima;
  final int jumlahMhsLulusAkhirTs;
  final int jumlahMhsLulusAkhirTs1;
  final int jumlahMhsLulusAkhirTs2;
  final int jumlahMhsLulusAkhirTs3;
  final int jumlahMhsLulusAkhirTs4;
  final int jumlahMhsLulusAkhirTs5;
  final int jumlahMhsLulusAkhirTs6;
  final int jumlahLulusan;
  final double meanMasaStudi; // Changed to double as per API validation

  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  MasaStudiLulusanModel({
    required this.id,
    required this.userId,
    required this.tahun,
    this.masaStudi,
    required this.jumlahMhsDiterima,
    required this.jumlahMhsLulusAkhirTs,
    required this.jumlahMhsLulusAkhirTs1,
    required this.jumlahMhsLulusAkhirTs2,
    required this.jumlahMhsLulusAkhirTs3,
    required this.jumlahMhsLulusAkhirTs4,
    required this.jumlahMhsLulusAkhirTs5,
    required this.jumlahMhsLulusAkhirTs6,
    required this.jumlahLulusan,
    required this.meanMasaStudi,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MasaStudiLulusanModel.fromJson(Map<String, dynamic> json) {
    return MasaStudiLulusanModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tahun: json['tahun'] as String,
      masaStudi: json['masa_studi'] as String?, // Handle nullable string
      jumlahMhsDiterima: int.tryParse(json['jumlah_mhs_diterima'].toString()) ?? 0,
      jumlahMhsLulusAkhirTs: int.tryParse(json['jumlah_mhs_lulus_akhir_ts'].toString()) ?? 0,
      jumlahMhsLulusAkhirTs1: int.tryParse(json['jumlah_mhs_lulus_akhir_ts_1'].toString()) ?? 0,
      jumlahMhsLulusAkhirTs2: int.tryParse(json['jumlah_mhs_lulus_akhir_ts_2'].toString()) ?? 0,
      jumlahMhsLulusAkhirTs3: int.tryParse(json['jumlah_mhs_lulus_akhir_ts_3'].toString()) ?? 0,
      jumlahMhsLulusAkhirTs4: int.tryParse(json['jumlah_mhs_lulus_akhir_ts_4'].toString()) ?? 0,
      jumlahMhsLulusAkhirTs5: int.tryParse(json['jumlah_mhs_lulus_akhir_ts_5'].toString()) ?? 0,
      jumlahMhsLulusAkhirTs6: int.tryParse(json['jumlah_mhs_lulus_akhir_ts_6'].toString()) ?? 0,
      jumlahLulusan: int.tryParse(json['jumlah_lulusan'].toString()) ?? 0,
      meanMasaStudi: double.tryParse(json['mean_masa_studi'].toString()) ?? 0.0,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}