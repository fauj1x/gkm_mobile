class EwmpDosenModel {
  final int id;
  final int userId;
  final int tahunAjaranId;
  final String namaDosen;
  final bool? isDtps;
  final double? psDiakreditasi;
  final double? psLainDalamPt;
  final double? psLainLuarPt;
  final double? penelitian;
  final double? pkm;
  final double? tugasTambahan;
  final double? jumlahSks;
  final double? avgPerSemester;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  EwmpDosenModel({
    required this.id,
    required this.userId,
    required this.tahunAjaranId,
    required this.namaDosen,
    this.isDtps,
    this.psDiakreditasi,
    this.psLainDalamPt,
    this.psLainLuarPt,
    this.penelitian,
    this.pkm,
    this.tugasTambahan,
    this.jumlahSks,
    this.avgPerSemester,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EwmpDosenModel.fromJson(Map<String, dynamic> json) {
    return EwmpDosenModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tahunAjaranId: int.tryParse(json['tahun_ajaran_id'].toString()) ?? 0,
      namaDosen: json['nama_dosen'] as String,
      isDtps: json['is_dtps'] is bool
          ? json['is_dtps']
          : json['is_dtps'] == '1' || json['is_dtps'] == 1,
      psDiakreditasi: _toDouble(json['ps_diakreditasi']),
      psLainDalamPt: _toDouble(json['ps_lain_dalam_pt']),
      psLainLuarPt: _toDouble(json['ps_lain_luar_pt']),
      penelitian: _toDouble(json['penelitian']),
      pkm: _toDouble(json['pkm']),
      tugasTambahan: _toDouble(json['tugas_tambahan']),
      jumlahSks: _toDouble(json['jumlah_sks']),
      avgPerSemester: _toDouble(json['avg_per_semester']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null || value is String && value.isEmpty) return null;
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
