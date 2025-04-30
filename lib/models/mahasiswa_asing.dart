class MahasiswaAsingModel {
  final int id;
  final int userId;
  final int tahunAjaranId;
  final int mhsAktif;
  final int mhsAsingFulltime;
  final int mhsAsingParttime;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  MahasiswaAsingModel({
    required this.id,
    required this.userId,
    required this.tahunAjaranId,
    required this.mhsAktif,
    required this.mhsAsingFulltime,
    required this.mhsAsingParttime,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MahasiswaAsingModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaAsingModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tahunAjaranId: int.tryParse(json['tahun_ajaran_id'].toString()) ?? 0,
      mhsAktif: int.tryParse(json['mhs_aktif'].toString()) ?? 0,
      mhsAsingFulltime:
          int.tryParse(json['mhs_asing_fulltime'].toString()) ?? 0,
      mhsAsingParttime:
          int.tryParse(json['mhs_asing_parttime'].toString()) ?? 0,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
