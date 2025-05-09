class PengakuanRekognisiDosenModel {
  final int id;
  final int userId;
  final String namaDosen;
  final String bidangKeahlian;
  final String namaRekognisi;
  final String buktiPendukung;
  final String tingkat;
  final String tahun;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  PengakuanRekognisiDosenModel({
    required this.id,
    required this.userId,
    required this.namaDosen,
    required this.bidangKeahlian,
    required this.namaRekognisi,
    required this.buktiPendukung,
    required this.tingkat,
    required this.tahun,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PengakuanRekognisiDosenModel.fromJson(Map<String, dynamic> json) {
    return PengakuanRekognisiDosenModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      namaDosen: json['nama_dosen'] ?? '',
      bidangKeahlian: json['bidang_keahlian'] ?? '',
      namaRekognisi: json['nama_rekognisi'] ?? '',
      buktiPendukung: json['bukti_pendukung'] ?? '',
      tingkat: json['tingkat'] ?? '',
      tahun: json['tahun'] ?? '',
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'nama_dosen': namaDosen,
      'bidang_keahlian': bidangKeahlian,
      'nama_rekognisi': namaRekognisi,
      'bukti_pendukung': buktiPendukung,
      'tingkat': tingkat,
      'tahun': tahun,
    };
  }
}
