class Kinerja_Pagelaran { // Ubah nama kelas menjadi Kinerja_Pagelaran
  final int? id;
  final int userId;
  final String namaDosen;
  final String judulArtikel;
  final String jenisArtikel;
  final String tahun;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Kinerja_Pagelaran({ // Ubah nama constructor
    this.id,
    required this.userId,
    required this.namaDosen,
    required this.judulArtikel,
    required this.jenisArtikel,
    required this.tahun,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Kinerja_Pagelaran.fromJson(Map<String, dynamic> json) { // Ubah nama factory constructor
    return Kinerja_Pagelaran( // Ubah nama kelas di sini
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      namaDosen: json['nama_dosen'] ?? '',
      judulArtikel: json['judul_artikel'] ?? '',
      jenisArtikel: json['jenis_artikel'] ?? '',
      tahun: json['tahun'] ?? '',

      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'].toString())
          : null,
      createdAt: DateTime.parse(json['created_at'].toString()),
      updatedAt: DateTime.parse(json['updated_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'nama_dosen': namaDosen,
      'judul_artikel': judulArtikel,
      'jenis_artikel': jenisArtikel,
      'tahun': tahun,
    };
  }
}