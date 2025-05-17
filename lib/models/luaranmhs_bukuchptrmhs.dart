// lib/models/bukuchaptermhs.dart
class BukuChapterMhs {
  final int id;
  final int userId;
  final String luaranPenelitian;
  final String tahun;
  final String keterangan;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  BukuChapterMhs({
    required this.id,
    required this.userId,
    required this.luaranPenelitian,
    required this.tahun,
    required this.keterangan,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BukuChapterMhs.fromJson(Map<String, dynamic> json) {
    return BukuChapterMhs(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      luaranPenelitian: json['luaran_penelitian'] ?? '',
      tahun: json['tahun'] ?? '',
      keterangan: json['keterangan'] ?? '',
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
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