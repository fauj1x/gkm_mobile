class EvalKepuasanModel {
  final int id;
  final int userId;
  final String jenisKemampuan;
  final int tingkatKepuasanSangatBaik;
  final int tingkatKepuasanBaik;
  final int tingkatKepuasanCukup;
  final int tingkatKepuasanKurang;
  final String rencanaTindakan;
  final int jumlahLulusan;
  final int jumlahResponden;
  final String tahun;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  EvalKepuasanModel({
    required this.id,
    required this.userId,
    required this.jenisKemampuan,
    required this.tingkatKepuasanSangatBaik,
    required this.tingkatKepuasanBaik,
    required this.tingkatKepuasanCukup,
    required this.tingkatKepuasanKurang,
    required this.rencanaTindakan,
    required this.jumlahLulusan,
    required this.jumlahResponden,
    required this.tahun,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EvalKepuasanModel.fromJson(Map<String, dynamic> json) {
    return EvalKepuasanModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      jenisKemampuan: json['jenis_kemampuan'] as String,
      tingkatKepuasanSangatBaik: int.tryParse(json['tingkat_kepuasan_sangat_baik'].toString()) ?? 0,
      tingkatKepuasanBaik: int.tryParse(json['tingkat_kepuasan_baik'].toString()) ?? 0,
      tingkatKepuasanCukup: int.tryParse(json['tingkat_kepuasan_cukup'].toString()) ?? 0,
      tingkatKepuasanKurang: int.tryParse(json['tingkat_kepuasan_kurang'].toString()) ?? 0,
      rencanaTindakan: json['rencana_tindakan'] as String,
      jumlahLulusan: int.tryParse(json['jumlah_lulusan'].toString()) ?? 0,
      jumlahResponden: int.tryParse(json['jumlah_responden'].toString()) ?? 0,
      tahun: json['tahun'] as String,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}