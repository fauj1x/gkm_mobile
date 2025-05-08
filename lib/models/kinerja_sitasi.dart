class Kinerja_Sitasi { // Nama kelas tetap
  final int? id;
  final int userId;
  final String nama_dosen; // Dari struktur data asli
  final String judul_artikel; // Dari struktur data asli
  final int jumlah_sitasi; // Dari struktur data asli
  final String tahun; // Dari struktur data asli (sesuaikan tipe data jika perlu, di sini String)
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

 Kinerja_Sitasi({ // Constructor disesuaikan
    this.id,
    required this.userId,
    required this.nama_dosen, // Dari struktur data asli
    required this.judul_artikel, // Dari struktur data asli
    required this.jumlah_sitasi, // Dari struktur data asli
    required this.tahun, // Dari struktur data asli
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Kinerja_Sitasi.fromJson(Map<String, dynamic> json) { // Factory disesuaikan
    return Kinerja_Sitasi( // Nama kelas tetap
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      nama_dosen: json['nama_dosen'] ?? '', // Ambil dari JSON
      judul_artikel: json['judul_artikel'] ?? '', // Ambil dari JSON
      jumlah_sitasi: int.tryParse(json['jumlah_sitasi'].toString()) ?? 0, // Ambil dari JSON
      tahun: json['tahun'] ?? '', // Ambil dari JSON
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'].toString())
          : null,
      createdAt: DateTime.parse(json['created_at'].toString()),
      updatedAt: DateTime.parse(json['updated_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    // Untuk operasi POST (menambah data), biasanya hanya kirim field data
    return {
      'user_id': userId,
      'nama_dosen': nama_dosen, // Kirim
      'judul_artikel': judul_artikel, // Kirim
      'jumlah_sitasi': jumlah_sitasi, // Kirim
      'tahun': tahun, // Kirim
    };
  }
}