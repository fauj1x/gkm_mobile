class IntegrasiPenelitianModel {
  final int id;
  final int userId;
  final String judulPenelitian;
  final String namaDosen;
  final String mataKuliah;
  final String bentukIntegrasi;
  final int tahun;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  IntegrasiPenelitianModel({
    required this.id,
    required this.userId,
    required this.judulPenelitian,
    required this.namaDosen,
    required this.mataKuliah,
    required this.bentukIntegrasi,
    required this.tahun,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IntegrasiPenelitianModel.fromJson(Map<String, dynamic> json) {
    return IntegrasiPenelitianModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      judulPenelitian: json['judul_penelitian'] ?? '',
      namaDosen: json['nama_dosen'] ?? '',
      mataKuliah: json['mata_kuliah'] ?? '',
      bentukIntegrasi: json['bentuk_integrasi'] ?? '',
      tahun: int.tryParse(json['tahun'].toString()) ?? 0,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
