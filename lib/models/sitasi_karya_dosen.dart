class SitasiKaryaDosenModel {
  final int id;
  final int userId;
  final String namaDosen;
  final String judulArtikel;
  final String jumlahSitasi;
  final String tahun;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  SitasiKaryaDosenModel({
    required this.id,
    required this.userId,
    required this.namaDosen,
    required this.judulArtikel,
    required this.jumlahSitasi,
    required this.tahun,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SitasiKaryaDosenModel.fromJson(Map<String, dynamic> json) {
    return SitasiKaryaDosenModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      namaDosen: json['nama_dosen'] ?? '',
      judulArtikel: json['judul_artikel'] ?? '',
      jumlahSitasi: json['jumlah_sitasi']?.toString() ?? '',
      tahun: json['tahun'] ?? '',
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
      createdAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']) ?? DateTime.now(),
    );
  }
}
