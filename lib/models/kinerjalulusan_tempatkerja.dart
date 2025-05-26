import 'dart:convert'; // Required for jsonEncode/jsonDecode if used outside ApiService

class TempatKerjaModel {
  final int? id; // Nullable for new entries before they get an ID from the backend
  final int userId;
  final String tahun;
  final int jumlahLulusan;
  final int jumlahLulusanTerlacak;
  final int jumlahLulusanBekerjaLokal;
  final int jumlahLulusanBekerjaNasional;
  final int jumlahLulusanBekerjaInternasional;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt; // Nullable for soft deletes

  TempatKerjaModel({
    this.id,
    required this.userId,
    required this.tahun,
    required this.jumlahLulusan,
    required this.jumlahLulusanTerlacak,
    required this.jumlahLulusanBekerjaLokal,
    required this.jumlahLulusanBekerjaNasional,
    required this.jumlahLulusanBekerjaInternasional,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  // Factory constructor for creating an AlumniTracking instance from JSON
  factory TempatKerjaModel.fromJson(Map<String, dynamic> json) {
    return TempatKerjaModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int,
      tahun: json['tahun'] as String,
      jumlahLulusan: json['jumlah_lulusan'] as int,
      jumlahLulusanTerlacak: json['jumlah_lulusan_terlacak'] as int,
      jumlahLulusanBekerjaLokal: json['jumlah_lulusan_bekerja_lokal'] as int,
      jumlahLulusanBekerjaNasional: json['jumlah_lulusan_bekerja_nasional'] as int,
      jumlahLulusanBekerjaInternasional: json['jumlah_lulusan_bekerja_internasional'] as int,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
    );
  }

  // Method for converting an AlumniTracking instance to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      // 'id' is typically not sent for creation, but might be for updates
      'id': id,
      'user_id': userId,
      'tahun': tahun,
      'jumlah_lulusan': jumlahLulusan,
      'jumlah_lulusan_terlacak': jumlahLulusanTerlacak,
      'jumlah_lulusan_bekerja_lokal': jumlahLulusanBekerjaLokal,
      'jumlah_lulusan_bekerja_nasional': jumlahLulusanBekerjaNasional,
      'jumlah_lulusan_bekerja_internasional': jumlahLulusanBekerjaInternasional,
      // created_at, updated_at, deleted_at are usually handled by the backend
      // so we typically don't send them in the request body.
    };
  }
}