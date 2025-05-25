// lib/models/matakuliah.dart
class MataKuliah {
  final int id;
  final int? userId; // nullable
  final String namaMataKuliah;
  final String kodeMataKuliah;
  final bool? mataKuliahKompetensi; // tinyint(1) usually maps to boolean
  final int? sksKuliah; // nullable
  final int? sksSeminar; // nullable
  final int? sksPraktikum; // nullable
  final int? konversiSks; // nullable
  final int? sks; // Field 'sks' yang dibutuhkan backend
  final int? semester; // Diubah kembali menjadi nullable sesuai struktur data
  final String? metodePembelajaran; // nullable
  final String? dokumen; // nullable
  final String? unitPenyelenggara; // nullable
  final bool? capaianKuliahSikap; // tinyint(1)
  final bool? capaianKuliahPengetahuan; // tinyint(1)
  final bool? capaianKuliahKeterampilanUmum; // tinyint(1)
  final bool? capaianKuliahKeterampilanKhusus; // tinyint(1)
  final String? tahun; // nullable
  final DateTime? deletedAt; // nullable timestamp
  final DateTime? createdAt; // nullable timestamp, assuming it can be null if not set yet
  final DateTime? updatedAt; // nullable timestamp, assuming it can be null if not set yet

  MataKuliah({
    required this.id,
    this.userId,
    required this.namaMataKuliah,
    required this.kodeMataKuliah,
    this.mataKuliahKompetensi,
    this.sksKuliah,
    this.sksSeminar,
    this.sksPraktikum,
    this.konversiSks,
    this.sks, // Tambahkan ke constructor
    this.semester, // Diubah kembali menjadi nullable
    this.metodePembelajaran,
    this.dokumen,
    this.unitPenyelenggara,
    this.capaianKuliahSikap,
    this.capaianKuliahPengetahuan,
    this.capaianKuliahKeterampilanUmum,
    this.capaianKuliahKeterampilanKhusus,
    this.tahun,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory MataKuliah.fromJson(Map<String, dynamic> json) {
    // Logika untuk menghitung 'sks' saat menerima data dari JSON
    // Prioritaskan 'konversi_sks' jika ada, jika tidak, jumlahkan SKS lainnya
    int? calculatedSks;
    if (json['konversi_sks'] != null) {
      calculatedSks = json['konversi_sks'] as int;
    } else {
      int sksKuliah = json['sks_kuliah'] as int? ?? 0;
      int sksSeminar = json['sks_seminar'] as int? ?? 0;
      int sksPraktikum = json['sks_praktikum'] as int? ?? 0;
      calculatedSks = sksKuliah + sksSeminar + sksPraktikum;
    }

    return MataKuliah(
      id: json['id'] as int, // id is NOT NULL
      userId: json['user_id'] as int?,
      namaMataKuliah: json['nama_mata_kuliah'] as String, // NOT NULL
      kodeMataKuliah: json['kode_mata_kuliah'] as String, // NOT NULL
      mataKuliahKompetensi: json['mata_kuliah_kompetensi'] == null
          ? null
          : (json['mata_kuliah_kompetensi'] as int) == 1, // Convert 0/1 to bool
      sksKuliah: json['sks_kuliah'] as int?,
      sksSeminar: json['sks_seminar'] as int?,
      sksPraktikum: json['sks_praktikum'] as int?,
      konversiSks: json['konversi_sks'] as int?,
      sks: json['sks'] as int? ?? calculatedSks, // Ambil 'sks' jika ada, atau gunakan yang dihitung
      semester: json['semester'] as int?, // Diubah kembali menjadi nullable
      metodePembelajaran: json['metode_pembelajaran'] as String?,
      dokumen: json['dokumen'] as String?,
      unitPenyelenggara: json['unit_penyelenggara'] as String?,
      capaianKuliahSikap: json['capaian_kuliah_sikap'] == null
          ? null
          : (json['capaian_kuliah_sikap'] as int) == 1, // Convert 0/1 to bool
      capaianKuliahPengetahuan: json['capaian_kuliah_pengetahuan'] == null
          ? null
          : (json['capaian_kuliah_pengetahuan'] as int) == 1, // Convert 0/1 to bool
      capaianKuliahKeterampilanUmum: json['capaian_kuliah_keterampilan_umum'] == null
          ? null
          : (json['capaian_kuliah_keterampilan_umum'] as int) == 1, // Convert 0/1 to bool
      capaianKuliahKeterampilanKhusus: json['capaian_kuliah_keterampilan_khusus'] == null
          ? null
          : (json['capaian_kuliah_keterampilan_khusus'] as int) == 1, // Convert 0/1 to bool
      tahun: json['tahun'] as String?,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    // Logika untuk menghitung 'sks' saat mengirim data ke JSON
    // Prioritaskan 'konversi_sks' jika ada, jika tidak, jumlahkan SKS lainnya
    int? calculatedSks;
    if (konversiSks != null && konversiSks! > 0) {
      calculatedSks = konversiSks;
    } else {
      calculatedSks = (sksKuliah ?? 0) + (sksSeminar ?? 0) + (sksPraktikum ?? 0);
    }

    return {
      'id': id,
      'user_id': userId,
      'nama_mata_kuliah': namaMataKuliah,
      'kode_mata_kuliah': kodeMataKuliah,
      'mata_kuliah_kompetensi': mataKuliahKompetensi == null
          ? null
          : (mataKuliahKompetensi! ? 1 : 0), // Convert bool to 0/1
      'sks_kuliah': sksKuliah,
      'sks_seminar': sksSeminar,
      'sks_praktikum': sksPraktikum,
      'konversi_sks': konversiSks,
      'sks': calculatedSks, // Tambahkan field 'sks' yang dihitung di sini
      'semester': semester, // Diubah kembali menjadi nullable
      'metode_pembelajaran': metodePembelajaran,
      'dokumen': dokumen,
      'unit_penyelenggara': unitPenyelenggara,
      'capaian_kuliah_sikap': capaianKuliahSikap == null
          ? null
          : (capaianKuliahSikap! ? 1 : 0), // Convert bool to 0/1
      'capaian_kuliah_pengetahuan': capaianKuliahPengetahuan == null
          ? null
          : (capaianKuliahPengetahuan! ? 1 : 0), // Convert bool to 0/1
      'capaian_kuliah_keterampilan_umum': capaianKuliahKeterampilanUmum == null
          ? null
          : (capaianKuliahKeterampilanUmum! ? 1 : 0), // Convert bool to 0/1
      'capaian_kuliah_keterampilan_khusus': capaianKuliahKeterampilanKhusus == null
          ? null
          : (capaianKuliahKeterampilanKhusus! ? 1 : 0), // Convert bool to 0/1
      'tahun': tahun,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
