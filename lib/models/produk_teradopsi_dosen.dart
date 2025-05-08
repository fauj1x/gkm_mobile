class ProdukTeradopsiDosenModel {
  final int id;
  final int userId;
  final String namaDosen;
  final String namaProduk;
  final String deskripsiProduk;
  final String bukti;
  final String tahun;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProdukTeradopsiDosenModel({
    required this.id,
    required this.userId,
    required this.namaDosen,
    required this.namaProduk,
    required this.deskripsiProduk,
    required this.bukti,
    required this.tahun,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProdukTeradopsiDosenModel.fromJson(Map<String, dynamic> json) {
    return ProdukTeradopsiDosenModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      namaDosen: json['nama_dosen'] ?? '',
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
