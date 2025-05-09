class DosenPembimbingTaModel {
  final int id;
  final int userId;
  final int tahunAjaranId;
  final String namaDosen;
  final int? mhsBimbinganPs;
  final int? mhsBimbinganPsLain;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DosenPembimbingTaModel({
    required this.id,
    required this.userId,
    required this.tahunAjaranId,
    required this.namaDosen,
    this.mhsBimbinganPs,
    this.mhsBimbinganPsLain,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DosenPembimbingTaModel.fromJson(Map<String, dynamic> json) {
    return DosenPembimbingTaModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tahunAjaranId: int.tryParse(json['tahun_ajaran_id'].toString()) ?? 0,
      namaDosen: json['nama_dosen'] as String,
      mhsBimbinganPs: json['mhs_bimbingan_ps'] != null
          ? int.tryParse(json['mhs_bimbingan_ps'].toString())
          : null,
      mhsBimbinganPsLain: json['mhs_bimbingan_ps_lain'] != null
          ? int.tryParse(json['mhs_bimbingan_ps_lain'].toString())
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
