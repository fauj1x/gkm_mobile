class PrestasiNonAkademikModel {
  final int id;
  final int userId;
  final String namaKegiatan;
  final String tingkat;
  final String prestasi;
  final String tahun;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  PrestasiNonAkademikModel({
    required this.id,
    required this.userId,
    required this.namaKegiatan,
    required this.tingkat,
    required this.prestasi,
    required this.tahun,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrestasiNonAkademikModel.fromJson(Map<String, dynamic> json) {
    return PrestasiNonAkademikModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      namaKegiatan: json['nama_kegiatan'] as String,
      tingkat: json['tingkat'] as String,
      prestasi: json['prestasi'] as String,
      tahun: json['tahun'] as String,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}