class Pengakuan_rekognisi {
  final int? id;
  final int userId;
  final String namaDosen; // Tambahkan properti namaDosen
  final String bidangKeahlian; // Tambahkan properti bidangKeahlian
  final String namaRekognisi; // Tambahkan properti namaRekognisi
  final String buktiPendukung; // Tambahkan properti buktiPendukung
  final String tingkat; // Tambahkan properti tingkat
  final String tahun; // Nama properti sesuai dengan struktur baru
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

 Pengakuan_rekognisi({
    this.id,
    required this.userId,
    required this.namaDosen,
    required this.bidangKeahlian,
    required this.namaRekognisi,
    required this.buktiPendukung,
    required this.tingkat,
    required this.tahun, // Nama properti sesuai dengan struktur baru
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pengakuan_rekognisi.fromJson(Map<String, dynamic> json) {
    return Pengakuan_rekognisi(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      namaDosen: json['nama_dosen'] ?? '', // Ambil dari JSON
      bidangKeahlian: json['bidang_keahlian'] ?? '', // Ambil dari JSON
      namaRekognisi: json['nama_rekognisi'] ?? '', // Ambil dari JSON
      buktiPendukung: json['bukti_pendukung'] ?? '', // Ambil dari JSON
      tingkat: json['tingkat'] ?? '', // Ambil dari JSON
      tahun: json['tahun'] ?? '', // Ambil dari JSON dengan nama 'tahun'
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
      'nama_dosen': namaDosen,
      'bidang_keahlian': bidangKeahlian,
      'nama_rekognisi': namaRekognisi,
      'bukti_pendukung': buktiPendukung,
      'tingkat': tingkat,
      'tahun': tahun, // Kirim dengan nama 'tahun'
      // 'deleted_at': deletedAt?.toIso8601String(), // Biasanya tidak dikirim saat POST/PUT
      // 'created_at': createdAt.toIso8601String(), // Biasanya tidak dikirim saat POST/PUT
      // 'updated_at': updatedAt.toIso8601String(), // Biasanya tidak dikirim saat POST/PUT
    };
  }
}