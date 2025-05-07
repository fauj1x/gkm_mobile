class Pkm_DTPS {
  final int? id;
  final int userId;
  final int jumlahJudul;
  final String sumberDana;
  final String tahun_penelitian; // Nama properti sesuai dengan struktur baru
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

 Pkm_DTPS({
    this.id,
    required this.userId,
    required this.jumlahJudul,
    required this.sumberDana,
    required this.tahun_penelitian, // Nama properti sesuai dengan struktur baru
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pkm_DTPS.fromJson(Map<String, dynamic> json) {
    return Pkm_DTPS(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      jumlahJudul: int.tryParse(json['jumlah_judul'].toString()) ?? 0,
      sumberDana: json['sumber_dana'] ?? '',
      tahun_penelitian: json['tahun_penelitian'] ?? '', // Ambil dari JSON dengan nama 'tahun'
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'].toString())
          : null,
      createdAt: DateTime.parse(json['created_at'].toString()),
      updatedAt: DateTime.parse(json['updated_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    // Untuk operasi POST (menambah data), biasanya hanya kirim field data,
    // bukan metadata seperti id, deleted_at, created_at, updated_at
    return {
      'user_id': userId,
      'jumlah_judul': jumlahJudul,
      'sumber_dana': sumberDana,
      'tahun_penelitian': tahun_penelitian, // Kirim dengan nama 'tahun'
      // 'deleted_at': deletedAt?.toIso8601String(), // Biasanya tidak dikirim saat POST/PUT
      // 'created_at': createdAt.toIso8601String(), // Biasanya tidak dikirim saat POST/PUT
      // 'updated_at': updatedAt.toIso8601String(), // Biasanya tidak dikirim saat POST/PUT
    };
  }
}