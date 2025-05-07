class PenelitianDTPS {
  final int? id;
  final int userId;
  final int jumlahJudul;
  final String sumberDana;
  final String tahunPenelitian;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  var judulKegiatan;

  var manfaat;

  var waktuDurasi;

  var buktiKerjasama;

  var tahunBerakhir;

  PenelitianDTPS({
    this.id,
    required this.userId,
    required this.jumlahJudul,
    required this.sumberDana,
    required this.tahunPenelitian,
   // Tambahkan di constructor (opsional jika tidak selalu ada)
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PenelitianDTPS.fromJson(Map<String, dynamic> json) {
    return PenelitianDTPS(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      jumlahJudul: int.tryParse(json['jumlah_judul'].toString()) ?? 0,
      sumberDana: json['sumber_dana'] ?? '',
      tahunPenelitian: json['tahun_penelitian'] ?? '',

      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'].toString())
          : null,
      createdAt: DateTime.parse(json['created_at'].toString()),
      updatedAt: DateTime.parse(json['updated_at'].toString()),
    );
  }

  get tingkat => null;

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'jumlah_judul': jumlahJudul,
      'sumber_dana': sumberDana,
      'tahun_penelitian': tahunPenelitian,
       // Pastikan ini dikirim dalam JSON
      // Field deleted_at, created_at, dan updated_at biasanya TIDAK dikirim saat MENAMBAH data baru.
      // Laravel akan mengelola ini secara otomatis.
      // Hapus baris berikut jika Anda mengirim data baru:
      // 'deleted_at': deletedAt?.toIso8601String(),
      // 'created_at': createdAt.toIso8601String(),
      // 'updated_at': updatedAt.toIso8601String(),
    };
  }
}