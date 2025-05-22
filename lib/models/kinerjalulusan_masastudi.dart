class MasaStudiLulusanModel {
  final int id;
  final int userId;
  final String tahun;
  final int jumlahLulusan;
  final double ipkMinimal;
  final double ipkMaksimal;
  final double ipkRataRata;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  MasaStudiLulusanModel({
    required this.id,
    required this.userId,
    required this.tahun,
    required this.jumlahLulusan,
    required this.ipkMinimal,
    required this.ipkMaksimal,
    required this.ipkRataRata,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MasaStudiLulusanModel.fromJson(Map<String, dynamic> json) {
    return MasaStudiLulusanModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tahun: json['tahun'] as String,
      jumlahLulusan: int.tryParse(json['jumlah_lulusan'].toString()) ?? 0,
      ipkMinimal: double.tryParse(json['ipk_minimal'].toString()) ?? 0.0,
      ipkMaksimal: double.tryParse(json['ipk_maksimal'].toString()) ?? 0.0,
      ipkRataRata: double.tryParse(json['ipk_rata_rata'].toString()) ?? 0.0,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}