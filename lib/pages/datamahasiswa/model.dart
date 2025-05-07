class SeleksiMahasiswaBaru {
  final int? id; // ← ubah ini jadi nullable
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
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  SeleksiMahasiswaBaru({
    this.id, // ← ini juga, hapus `required`
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
    this.createdAt,
    this.updatedAt,
  });

  factory SeleksiMahasiswaBaru.fromJson(Map<String, dynamic> json) {
    return SeleksiMahasiswaBaru(
      id: json['id'],
      userId: json['user_id'],
      tahunAjaranId: json['tahun_ajaran_id'],
      tahunAkademik: json['tahun_akademik'],
      dayaTampung: json['daya_tampung'],
      pendaftar: json['pendaftar'],
      lulusSeleksi: json['lulus_seleksi'],
      mabaReguler: json['maba_reguler'],
      mabaTransfer: json['maba_transfer'],
      mhsAktifReguler: json['mhs_aktif_reguler'],
      mhsAktifTransfer: json['mhs_aktif_transfer'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'tahun_ajaran_id': tahunAjaranId,
      'tahun_akademik': tahunAkademik,
      'daya_tampung': dayaTampung,
      'pendaftar': pendaftar,
      'lulus_seleksi': lulusSeleksi,
      'maba_reguler': mabaReguler,
      'maba_transfer': mabaTransfer,
      'mhs_aktif_reguler': mhsAktifReguler,
      'mhs_aktif_transfer': mhsAktifTransfer,
    };
  }
}
