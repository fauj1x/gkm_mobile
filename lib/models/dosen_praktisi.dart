class DosenPraktisi {
  final int id;
  final int userId;
  final int tahunAjaranId;
  final String namaDosen;
  final String nidk;
  final String perusahaan;
  final String pendidikanTertinggi;
  final String bidangKeahlian;
  final String sertifikatKompetensi;
  final int mkDiampu;
  final double bobotKreditSks;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DosenPraktisi({
    required this.id,
    required this.userId,
    required this.tahunAjaranId,
    required this.namaDosen,
    required this.nidk,
    required this.perusahaan,
    required this.pendidikanTertinggi,
    required this.bidangKeahlian,
    required this.sertifikatKompetensi,
    required this.mkDiampu,
    required this.bobotKreditSks,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DosenPraktisi.fromJson(Map<String, dynamic> json) {
    return DosenPraktisi(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tahunAjaranId: int.tryParse(json['tahun_ajaran_id'].toString()) ?? 0,
      namaDosen: json['nama_dosen'] as String,
      nidk: json['nidk'] as String,
      perusahaan: json['perusahaan'] as String,
      pendidikanTertinggi: json['pendidikan_tertinggi'] as String,
      bidangKeahlian: json['bidang_keahlian'] as String,
      sertifikatKompetensi: json['sertifikat_kompetensi'] as String,
      mkDiampu: int.tryParse(json['mk_diampu'].toString()) ?? 0,
      bobotKreditSks: (json['bobot_kredit_sks'] as num?)?.toDouble() ?? 0.0,
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'tahun_ajaran_id': tahunAjaranId,
      'nama_dosen': namaDosen,
      'nidk': nidk,
      'perusahaan': perusahaan,
      'pendidikan_tertinggi': pendidikanTertinggi,
      'bidang_keahlian': bidangKeahlian,
      'sertifikat_kompetensi': sertifikatKompetensi,
      'mk_diampu': mkDiampu,
      'bobot_kredit_sks': bobotKreditSks,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
