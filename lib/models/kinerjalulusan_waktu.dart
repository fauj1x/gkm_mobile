class WaktuTungguModel {
  final int id;
  final int userId;
  final String tahun;
  final String masaStudi;
  final int jumlahLulusan;
  final int jumlahLulusanTerlacak;
  final int jumlahLulusanTerlacakDipesan;
  final int jumlahLulusanWaktuTigaBulan;
  final int jumlahLulusanWaktuEnamBulan;
  final int jumlahLulusanWaktuSembilanBulan;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  WaktuTungguModel({
    required this.id,
    required this.userId,
    required this.tahun,
    required this.masaStudi,
    required this.jumlahLulusan,
    required this.jumlahLulusanTerlacak,
    required this.jumlahLulusanTerlacakDipesan,
    required this.jumlahLulusanWaktuTigaBulan,
    required this.jumlahLulusanWaktuEnamBulan,
    required this.jumlahLulusanWaktuSembilanBulan,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WaktuTungguModel.fromJson(Map<String, dynamic> json) {
    return WaktuTungguModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tahun: json['tahun'] as String,
      masaStudi: json['masa_studi'] as String,
      jumlahLulusan: int.tryParse(json['jumlah_lulusan'].toString()) ?? 0,
      jumlahLulusanTerlacak: int.tryParse(json['jumlah_lulusan_terlacak'].toString()) ?? 0,
      jumlahLulusanTerlacakDipesan: int.tryParse(json['jumlah_lulusan_terlacak_dipesan'].toString()) ?? 0,
      jumlahLulusanWaktuTigaBulan: int.tryParse(json['jumlah_lulusan_waktu_tiga_bulan'].toString()) ?? 0,
      jumlahLulusanWaktuEnamBulan: int.tryParse(json['jumlah_lulusan_waktu_enam_bulan'].toString()) ?? 0,
      jumlahLulusanWaktuSembilanBulan: int.tryParse(json['jumlah_lulusan_waktu_sembilan_bulan'].toString()) ?? 0,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}