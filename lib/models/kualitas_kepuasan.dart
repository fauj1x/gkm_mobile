class kualitas_kepuasan { // Nama kelas diubah
  final int? id;
  final int userId;
  final String aspek_penilaian; // Dari struktur data baru
  final String tingkat_kepuasan_sangat_baik; // Dari struktur data baru (sesuaikan tipe data jika perlu)
  final String tingkat_kepuasan_baik; // Dari struktur data baru (sesuaikan tipe data jika perlu)
  final String tingkat_kepuasan_cukup; // Dari struktur data baru (sesuaikan tipe data jika perlu)
  final String tingkat_kepuasan_kurang; // Dari struktur data baru (sesuaikan tipe data jika perlu)
  final String rencana_tindakan; // Dari struktur data baru
  final String tahun; // Dari struktur data baru (sesuaikan tipe data jika perlu)
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

 kualitas_kepuasan({ // Constructor disesuaikan
    this.id,
    required this.userId,
    required this.aspek_penilaian,
    required this.tingkat_kepuasan_sangat_baik,
    required this.tingkat_kepuasan_baik,
    required this.tingkat_kepuasan_cukup,
    required this.tingkat_kepuasan_kurang,
    required this.rencana_tindakan,
    required this.tahun,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory kualitas_kepuasan.fromJson(Map<String, dynamic> json) { // Factory disesuaikan
    return kualitas_kepuasan( // Nama kelas diubah
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      aspek_penilaian: json['aspek_penilaian'] ?? '',
      tingkat_kepuasan_sangat_baik: json['tingkat_kepuasan_sangat_baik']?.toString() ?? '', // Ambil dan konversi ke String
      tingkat_kepuasan_baik: json['tingkat_kepuasan_baik']?.toString() ?? '', // Ambil dan konversi ke String
      tingkat_kepuasan_cukup: json['tingkat_kepuasan_cukup']?.toString() ?? '', // Ambil dan konversi ke String
      tingkat_kepuasan_kurang: json['tingkat_kepuasan_kurang']?.toString() ?? '', // Ambil dan konversi ke String
      rencana_tindakan: json['rencana_tindakan'] ?? '',
      tahun: json['tahun'] ?? '', // Ambil dari JSON
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'].toString())
          : null,
      createdAt: DateTime.parse(json['created_at'].toString()),
      updatedAt: DateTime.parse(json['updated_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    // Untuk operasi POST (menambah data), biasanya hanya kirim field data
    return {
      'user_id': userId,
      'aspek_penilaian': aspek_penilaian,
      'tingkat_kepuasan_sangat_baik': tingkat_kepuasan_sangat_baik, // Kirim
      'tingkat_kepuasan_baik': tingkat_kepuasan_baik, // Kirim
      'tingkat_kepuasan_cukup': tingkat_kepuasan_cukup, // Kirim
      'tingkat_kepuasan_kurang': tingkat_kepuasan_kurang, // Kirim
      'rencana_tindakan': rencana_tindakan,
      'tahun': tahun, // Kirim
    };
  }
}