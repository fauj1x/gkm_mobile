class DosenIndustriPraktisiModel {
  final int id;
  final int userId;
  final int tahunAjaranId;
  final String namaDosen;
  final String? nidk;
  final String? perusahaan;
  final String? pendidikanTertinggi;
  final String? bidangKeahlian;
  final String? sertifikatKompetensi;
  final String? mkDiampu;
  final double? bobotKreditSks;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DosenIndustriPraktisiModel({
    required this.id,
    required this.userId,
    required this.tahunAjaranId,
    required this.namaDosen,
    this.nidk,
    this.perusahaan,
    this.pendidikanTertinggi,
    this.bidangKeahlian,
    this.sertifikatKompetensi,
    this.mkDiampu,
    this.bobotKreditSks,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DosenIndustriPraktisiModel.fromJson(Map<String, dynamic> json) {
    return DosenIndustriPraktisiModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tahunAjaranId: int.tryParse(json['tahun_ajaran_id'].toString()) ?? 0,
      namaDosen: json['nama_dosen'] as String,
      nidk: json['nidk']?.toString(),
      perusahaan: json['perusahaan']?.toString(),
      pendidikanTertinggi: json['pendidikan_tertinggi']?.toString(),
      bidangKeahlian: json['bidang_keahlian']?.toString(),
      sertifikatKompetensi: json['sertifikat_kompetensi']?.toString(),
      mkDiampu: json['mk_diampu']?.toString(),
      bobotKreditSks: json['bobot_kredit_sks'] != null
          ? double.tryParse(json['bobot_kredit_sks'].toString())
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
