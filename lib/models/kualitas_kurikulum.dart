class kualitas_kurikulum { // Nama kelas diubah
  final int? id;
  final int userId;
  final String nama_mata_kuliah; // Dari struktur data baru
  final String kode_mata_kuliah; // Dari struktur data baru
  final String mata_kuliah_kompetensi; // Dari struktur data baru
  final int sks_kuliah; // Dari struktur data baru (sesuaikan tipe data jika perlu)
  final int sks_seminar; // Dari struktur data baru (sesuaikan tipe data jika perlu)
  final int sks_praktikum; // Dari struktur data baru (sesuaikan tipe data jika perlu)
  final int konversi_sks; // Dari struktur data baru (sesuaikan tipe data jika perlu)
  final String semester; // Dari struktur data baru
  final String metode_pembelajaran; // Dari struktur data baru
  final String dokumen; // Dari struktur data baru
  final String unit_penyelenggara; // Dari struktur data baru
  final String capaian_kuliah_sikap; // Dari struktur data baru
  final String capaian_kuliah_pengetahuan; // Dari struktur data baru
  final String capaian_kuliah_keterampilan_umum; // Dari struktur data baru
  final String capaian_kuliah_keterampilan_khusus; // Dari struktur data baru
  final String tahun; // Dari struktur data baru (sesuaikan tipe data jika perlu)
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

 kualitas_kurikulum({ // Constructor disesuaikan
    this.id,
    required this.userId,
    required this.nama_mata_kuliah,
    required this.kode_mata_kuliah,
    required this.mata_kuliah_kompetensi,
    required this.sks_kuliah,
    required this.sks_seminar,
    required this.sks_praktikum,
    required this.konversi_sks,
    required this.semester,
    required this.metode_pembelajaran,
    required this.dokumen,
    required this.unit_penyelenggara,
    required this.capaian_kuliah_sikap,
    required this.capaian_kuliah_pengetahuan,
    required this.capaian_kuliah_keterampilan_umum,
    required this.capaian_kuliah_keterampilan_khusus,
    required this.tahun,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory kualitas_kurikulum.fromJson(Map<String, dynamic> json) { // Factory disesuaikan
    return kualitas_kurikulum( // Nama kelas diubah
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      nama_mata_kuliah: json['nama_mata_kuliah'] ?? '',
      kode_mata_kuliah: json['kode_mata_kuliah'] ?? '',
      mata_kuliah_kompetensi: json['mata_kuliah_kompetensi'] ?? '',
      sks_kuliah: int.tryParse(json['sks_kuliah'].toString()) ?? 0, // Ambil dan parse
      sks_seminar: int.tryParse(json['sks_seminar'].toString()) ?? 0, // Ambil dan parse
      sks_praktikum: int.tryParse(json['sks_praktikum'].toString()) ?? 0, // Ambil dan parse
      konversi_sks: int.tryParse(json['konversi_sks'].toString()) ?? 0, // Ambil dan parse
      semester: json['semester'] ?? '',
      metode_pembelajaran: json['metode_pembelajaran'] ?? '',
      dokumen: json['dokumen'] ?? '',
      unit_penyelenggara: json['unit_penyelenggara'] ?? '',
      capaian_kuliah_sikap: json['capaian_kuliah_sikap'] ?? '',
      capaian_kuliah_pengetahuan: json['capaian_kuliah_pengetahuan'] ?? '',
      capaian_kuliah_keterampilan_umum: json['capaian_kuliah_keterampilan_umum'] ?? '',
      capaian_kuliah_keterampilan_khusus: json['capaian_kuliah_keterampilan_khusus'] ?? '',
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
      'nama_mata_kuliah': nama_mata_kuliah,
      'kode_mata_kuliah': kode_mata_kuliah,
      'mata_kuliah_kompetensi': mata_kuliah_kompetensi,
      'sks_kuliah': sks_kuliah,
      'sks_seminar': sks_seminar,
      'sks_praktikum': sks_praktikum,
      'konversi_sks': konversi_sks,
      'semester': semester,
      'metode_pembelajaran': metode_pembelajaran,
      'dokumen': dokumen,
      'unit_penyelenggara': unit_penyelenggara,
      'capaian_kuliah_sikap': capaian_kuliah_sikap,
      'capaian_kuliah_pengetahuan': capaian_kuliah_pengetahuan,
      'capaian_kuliah_keterampilan_umum': capaian_kuliah_keterampilan_umum,
      'capaian_kuliah_keterampilan_khusus': capaian_kuliah_keterampilan_khusus,
      'tahun': tahun, // Kirim
    };
  }
}