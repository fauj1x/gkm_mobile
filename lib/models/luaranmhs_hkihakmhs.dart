class HkiHakCiptaMhs {
  final int id;
  final int userId;
  final String luaranPenelitian;
  final String tahun;
  final String keterangan;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  HkiHakCiptaMhs({
    required this.id,
    required this.userId,
    required this.luaranPenelitian,
    required this.tahun,
    required this.keterangan,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HkiHakCiptaMhs.fromJson(Map<String, dynamic> json) {
    return HkiHakCiptaMhs(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      luaranPenelitian: json['luaran_penelitian'] ?? '',
      tahun: json['tahun'] ?? '',
      keterangan: json['keterangan'] ?? '',
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}