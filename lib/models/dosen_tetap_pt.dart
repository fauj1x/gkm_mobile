class DosenTetapPtModel {
  final int id;
  final int userId;
  final int tahunAjaranId;
  final String namaDosen;
  final String nidnNidk;
  final String gelarMagister;
  final String? gelarDoktor;
  final String? bidangKeahlian;
  final bool? kesesuaianKompetensi;
  final String? jabatanAkademik;
  final String? sertifikatPendidik;
  final String? sertifikatKompetensi;
  final String? mkDiampu;
  final bool? kesesuaianKeahlianMk;
  final String? mkPsLain;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DosenTetapPtModel({
    required this.id,
    required this.userId,
    required this.tahunAjaranId,
    required this.namaDosen,
    required this.nidnNidk,
    required this.gelarMagister,
    this.gelarDoktor,
    this.bidangKeahlian,
    this.kesesuaianKompetensi,
    this.jabatanAkademik,
    this.sertifikatPendidik,
    this.sertifikatKompetensi,
    this.mkDiampu,
    this.kesesuaianKeahlianMk,
    this.mkPsLain,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DosenTetapPtModel.fromJson(Map<String, dynamic> json) {
    return DosenTetapPtModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tahunAjaranId: int.tryParse(json['tahun_ajaran_id'].toString()) ?? 0,
      namaDosen: json['nama_dosen'] as String,
      nidnNidk: json['nidn_nidk'] as String,
      gelarMagister: json['gelar_magister'] as String,
      gelarDoktor: json['gelar_doktor']?.toString(),
      bidangKeahlian: json['bidang_keahlian']?.toString(),
      kesesuaianKompetensi: json['kesesuaian_kompetensi'] is bool
          ? json['kesesuaian_kompetensi']
          : json['kesesuaian_kompetensi'] == '1' ||
              json['kesesuaian_kompetensi'] == 1,
      jabatanAkademik: json['jabatan_akademik']?.toString(),
      sertifikatPendidik: json['sertifikat_pendidik']?.toString(),
      sertifikatKompetensi: json['sertifikat_kompetensi']?.toString(),
      mkDiampu: json['mk_diampu']?.toString(),
      kesesuaianKeahlianMk: json['kesesuaian_keahlian_mk'] is bool
          ? json['kesesuaian_keahlian_mk']
          : json['kesesuaian_keahlian_mk'] == '1' ||
              json['kesesuaian_keahlian_mk'] == 1,
      mkPsLain: json['mk_ps_lain']?.toString(),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
