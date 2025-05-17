class sitasimahasiswa {
  final int id;
  final int userId;
  final String namaMahasiswa;
  final String judulArtikel;
  final int jumlahSitasi;
  final String tahun;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  sitasimahasiswa({
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

  factory sitasimahasiswa.fromJson(Map<String, dynamic> json) {
    return sitasimahasiswa(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      namaMahasiswa: json['nama_mahasiswa'] ?? '',
      judulArtikel: json['judul_artikel'] ?? '',
      jumlahSitasi: int.tryParse(json['jumlah_sitasi'].toString()) ?? 0,
      tahun: json['tahun'] ?? '',
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}