class PenelitianDtpsModel {
  final int id;
  final int userId;
  final int jumlahJudul;
  final String sumberDana;
  final String tahunPenelitian;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  PenelitianDtpsModel({
    required this.id,
    required this.userId,
    required this.jumlahJudul,
    required this.sumberDana,
    required this.tahunPenelitian,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PenelitianDtpsModel.fromJson(Map<String, dynamic> json) {
    return PenelitianDtpsModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      jumlahJudul: int.tryParse(json['jumlah_judul'].toString()) ?? 0,
      sumberDana: json['sumber_dana'] ?? '',
      tahunPenelitian: json['tahun_penelitian'] ?? '',
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
      createdAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']) ?? DateTime.now(),
    );
  }
}
