class TempatKerjaModel {
  final int id;
  final int userId;
  final String tahun;
  final int jumlahLulusan;
  final int jumlahLulusanTerlacak;
  final int jumlahLulusanBekerjaLokal;
  final int jumlahLulusanBekerjaNasional;
  final int jumlahLulusanBekerjaInternasional;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  TempatKerjaModel({
    required this.id,
    required this.userId,
    required this.tahun,
    required this.jumlahLulusan,
    required this.jumlahLulusanTerlacak,
    required this.jumlahLulusanBekerjaLokal,
    required this.jumlahLulusanBekerjaNasional,
    required this.jumlahLulusanBekerjaInternasional,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TempatKerjaModel.fromJson(Map<String, dynamic> json) {
    return TempatKerjaModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tahun: json['tahun'] as String,
      jumlahLulusan: int.tryParse(json['jumlah_lulusan'].toString()) ?? 0,
      jumlahLulusanTerlacak: int.tryParse(json['jumlah_lulusan_terlacak'].toString()) ?? 0,
      jumlahLulusanBekerjaLokal: int.tryParse(json['jumlah_lulusan_bekerja_lokal'].toString()) ?? 0,
      jumlahLulusanBekerjaNasional: int.tryParse(json['jumlah_lulusan_bekerja_nasional'].toString()) ?? 0,
      jumlahLulusanBekerjaInternasional: int.tryParse(json['jumlah_lulusan_bekerja_internasional'].toString()) ?? 0,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}