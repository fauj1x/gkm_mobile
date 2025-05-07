class Kinerja_Produk { // Nama kelas diubah
  final int? id;
  final int userId;
  final String nama_dosen; // Dari struktur data baru
  final String nama_produk; // Dari struktur data baru
  final String deskripsi_produk; // Dari struktur data baru
  final String bukti; // Dari struktur data baru
  final String tahun; // Dari struktur data baru (sesuaikan tipe data jika perlu, di sini String)
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

 Kinerja_Produk({ // Constructor disesuaikan
    this.id,
    required this.userId,
    required this.nama_dosen, // Dari struktur data baru
    required this.nama_produk, // Dari struktur data baru
    required this.deskripsi_produk, // Dari struktur data baru
    required this.bukti, // Dari struktur data baru
    required this.tahun, // Dari struktur data baru
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Kinerja_Produk.fromJson(Map<String, dynamic> json) { // Factory disesuaikan
    return Kinerja_Produk( // Nama kelas diubah
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      nama_dosen: json['nama_dosen'] ?? '', // Ambil dari JSON
      nama_produk: json['nama_produk'] ?? '', // Ambil dari JSON
      deskripsi_produk: json['deskripsi_produk'] ?? '', // Ambil dari JSON
      bukti: json['bukti'] ?? '', // Ambil dari JSON
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
      'nama_produk': nama_produk, // Kirim
      'deskripsi_produk': deskripsi_produk, // Kirim
      'bukti': bukti, // Kirim
      'tahun': tahun, // Kirim
    };
  }
}