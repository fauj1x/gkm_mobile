class SeleksiMahasiswaBaruModel {
  final int id;
  final int userId;
  final int tahunAjaranId;
  final String tahunAkademik;
  final int dayaTampung;
  final int pendaftar;
  final int lulusSeleksi;
  final int mabaReguler;
  final int mabaTransfer;
  final int mhsAktifReguler;
  final int mhsAktifTransfer;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  SeleksiMahasiswaBaruModel({
    required this.id,
    required this.userId,
    required this.tahunAjaranId,
    required this.tahunAkademik,
    required this.dayaTampung,
    required this.pendaftar,
    required this.lulusSeleksi,
    required this.mabaReguler,
    required this.mabaTransfer,
    required this.mhsAktifReguler,
    required this.mhsAktifTransfer,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SeleksiMahasiswaBaruModel.fromJson(Map<String, dynamic> json) {
    return SeleksiMahasiswaBaruModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tahunAjaranId: int.tryParse(json['tahun_ajaran_id'].toString()) ?? 0,
      tahunAkademik: json['tahun_akademik'] as String,
      dayaTampung: int.tryParse(json['daya_tampung'].toString()) ?? 0,
      pendaftar: int.tryParse(json['pendaftar'].toString()) ?? 0,
      lulusSeleksi: int.tryParse(json['lulus_seleksi'].toString()) ?? 0,
      mabaReguler: int.tryParse(json['maba_reguler'].toString()) ?? 0,
      mabaTransfer: int.tryParse(json['maba_transfer'].toString()) ?? 0,
      mhsAktifReguler: int.tryParse(json['mhs_aktif_reguler'].toString()) ?? 0,
      mhsAktifTransfer:
          int.tryParse(json['mhs_aktif_transfer'].toString()) ?? 0,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
