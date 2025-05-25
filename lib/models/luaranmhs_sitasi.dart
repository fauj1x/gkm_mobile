class SitasiMahasiswa {
  final int id;
  final int? userId;  // nullable sesuai database (Yes NULL)
  final String namaMahasiswa;
  final String judulArtikel;
  final int jumlahSitasi;
  final String? tahun; // nullable sesuai database (Yes NULL)
  final DateTime? deletedAt; // nullable timestamp
  final DateTime? createdAt; // nullable timestamp
  final DateTime? updatedAt; // nullable timestamp

  SitasiMahasiswa({
    required this.id,
    this.userId,
    required this.namaMahasiswa,
    required this.judulArtikel,
    required this.jumlahSitasi,
    this.tahun,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory SitasiMahasiswa.fromJson(Map<String, dynamic> json) {
    return SitasiMahasiswa(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null,
      namaMahasiswa: json['nama_mahasiswa'] ?? '',
      judulArtikel: json['judul_artikel'] ?? '',
      jumlahSitasi: json['jumlah_sitasi'] is int
          ? json['jumlah_sitasi']
          : int.tryParse(json['jumlah_sitasi'].toString()) ?? 0,
      tahun: json['tahun'],
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'nama_mahasiswa': namaMahasiswa,
      'judul_artikel': judulArtikel,
      'jumlah_sitasi': jumlahSitasi,
      'tahun': tahun,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
