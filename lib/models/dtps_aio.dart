class DtpsAioModel {
  final int id;
  final int userId;
  final String namaDosen;
  final String temaPenelitian;
  final String namaMahasiswa;
  final String judul;
  final String tahun;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DtpsAioModel({
    required this.id,
    required this.userId,
    required this.namaDosen,
    required this.temaPenelitian,
    required this.namaMahasiswa,
    required this.judul,
    required this.tahun,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DtpsAioModel.fromJson(Map<String, dynamic> json) {
    return DtpsAioModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      namaDosen: json['nama_dosen'] ?? '',
      temaPenelitian: json['tema_penelitian'] ?? '',
      namaMahasiswa: json['nama_mahasiswa'] ?? '',
      judul: json['judul'] ?? '',
      tahun: json['tahun'] ?? '',
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
