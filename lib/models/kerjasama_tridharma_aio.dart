class KerjasamaTridharmaAIO {
  final int id;
  final int userId;
  final int tahunAjaranId;
  final String lembagaMitra;
  final String tingkat;
  final String judulKegiatan;
  final String manfaat;
  final String waktuDurasi;
  final String buktiKerjasama;
  final String tahunBerakhir;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  KerjasamaTridharmaAIO({
    required this.id,
    required this.userId,
    required this.tahunAjaranId,
    required this.lembagaMitra,
    required this.tingkat,
    required this.judulKegiatan,
    required this.manfaat,
    required this.waktuDurasi,
    required this.buktiKerjasama,
    required this.tahunBerakhir,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KerjasamaTridharmaAIO.fromJson(Map<String, dynamic> json) {
    return KerjasamaTridharmaAIO(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tahunAjaranId: int.tryParse(json['tahun_ajaran_id'].toString()) ?? 0,
      lembagaMitra: json['lembaga_mitra'] as String,
      tingkat: json['tingkat'] as String,
      judulKegiatan: json['judul_kegiatan'] as String,
      manfaat: json['manfaat'] as String,
      waktuDurasi: json['waktu_durasi'] as String,
      buktiKerjasama: json['bukti_kerjasama'] as String,
      tahunBerakhir: json['tahun_berakhir'] as String,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
