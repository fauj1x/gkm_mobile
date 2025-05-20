class ProdukMahasiswa {
  final int id;
  final int userId;
  final String namaMahasiswa;
  final String namaProduk;
  final String deskripsiProduk;
  final String bukti; // Bisa berupa URL atau path file
  final String tahun;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProdukMahasiswa({
    required this.id,
    required this.userId,
    required this.namaMahasiswa,
    required this.namaProduk,
    required this.deskripsiProduk,
    required this.bukti,
    required this.tahun,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProdukMahasiswa.fromJson(Map<String, dynamic> json) {
    return ProdukMahasiswa(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      namaMahasiswa: json['nama_mahasiswa'] ?? '',
      namaProduk: json['nama_produk'] ?? '',
      deskripsiProduk: json['deskripsi_produk'] ?? '',
      bukti: json['bukti'] ?? '',
      tahun: json['tahun'] ?? '',
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}