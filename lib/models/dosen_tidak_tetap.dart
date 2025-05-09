class DosenTidakTetapModel {
  final int id;
  final int userId;
  final int tahunAjaranId;
  final String namaDosen;
  final String? nidnNidk;
  final String? pendidikanPascasarjana;
  final String? bidangKeahlian;
  final String? jabatanAkademik;
  final String? sertifikatPendidik;
  final String? sertifikatKompetensi;
  final String? mkDiampu;
  final bool? kesesuaianKeahlianMk;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DosenTidakTetapModel({
    required this.id,
    required this.userId,
    required this.tahunAjaranId,
    required this.namaDosen,
    this.nidnNidk,
    this.pendidikanPascasarjana,
    this.bidangKeahlian,
    this.jabatanAkademik,
    this.sertifikatPendidik,
    this.sertifikatKompetensi,
    this.mkDiampu,
    this.kesesuaianKeahlianMk,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DosenTidakTetapModel.fromJson(Map<String, dynamic> json) {
    return DosenTidakTetapModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tahunAjaranId: int.tryParse(json['tahun_ajaran_id'].toString()) ?? 0,
      namaDosen: json['nama_dosen'] ?? '',
      nidnNidk: json['nidn_nidk'],
      pendidikanPascasarjana: json['pendidikan_pascasarjana'],
      bidangKeahlian: json['bidang_keahlian'],
      jabatanAkademik: json['jabatan_akademik'],
      sertifikatPendidik: json['sertifikat_pendidik'],
      sertifikatKompetensi: json['sertifikat_kompetensi'],
      mkDiampu: json['mk_diampu'],
      kesesuaianKeahlianMk: json['kesesuaian_keahlian_mk'] is bool
          ? json['kesesuaian_keahlian_mk']
          : json['kesesuaian_keahlian_mk'] == '1' ||
              json['kesesuaian_keahlian_mk'] == 1,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
