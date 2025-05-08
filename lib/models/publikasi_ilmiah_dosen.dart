class PublikasiIlmiahDosenModel {
  final int id;
  final int userId;
  final String namaDosen;
  final String judulArtikel;
  final String jenisArtikel;
  final String tahun;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  PublikasiIlmiahDosenModel({
    required this.id,
    required this.userId,
    required this.namaDosen,
    required this.judulArtikel,
    required this.jenisArtikel,
    required this.tahun,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PublikasiIlmiahDosenModel.fromJson(Map<String, dynamic> json) {
    return PublikasiIlmiahDosenModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      namaDosen: json['nama_dosen'] ?? '',
      judulArtikel: json['judul_artikel'] ?? '',
      jenisArtikel: json['jenis_artikel'] ?? '',
      tahun: json['tahun'] ?? '',
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
      createdAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']) ?? DateTime.now(),
    );
  }
}
