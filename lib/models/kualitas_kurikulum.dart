class KualitasKurikulum {
  final int? id;
  final int userId;
  final String namaMataKuliah;
  final String kodeMataKuliah;
  final bool? mataKuliahKompetensi;
  final int? sksKuliah;
  final int? sksSeminar;
  final int? sksPraktikum;
  final int? konversiSks;
  final int? semester;
  final String? metodePembelajaran;
  final String? dokumen;
  final String? unitPenyelenggara;
  final bool? capaianKuliahSikap;
  final bool? capaianKuliahPengetahuan;
  final bool? capaianKuliahKeterampilanUmum;
  final bool? capaianKuliahKeterampilanKhusus;
  final String? tahun;
  final DateTime? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  KualitasKurikulum({
    this.id,
    required this.userId,
    required this.namaMataKuliah,
    required this.kodeMataKuliah,
    this.mataKuliahKompetensi,
    this.sksKuliah,
    this.sksSeminar,
    this.sksPraktikum,
    this.konversiSks,
    this.semester,
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

  factory KualitasKurikulum.fromJson(Map<String, dynamic> json) {
    return KualitasKurikulum(
      id: json['id'] as int?,
      userId: json['user_id'] as int? ?? 0,
      namaMataKuliah: json['nama_mata_kuliah'] ?? '',
      kodeMataKuliah: json['kode_mata_kuliah'] ?? '',
      mataKuliahKompetensi: json['mata_kuliah_kompetensi'] == null
          ? null
          : json['mata_kuliah_kompetensi'] == 1,
      sksKuliah: json['sks_kuliah'] as int?,
      sksSeminar: json['sks_seminar'] as int?,
      sksPraktikum: json['sks_praktikum'] as int?,
      konversiSks: json['konversi_sks'] as int?,
      semester: json['semester'] as int?,
      metodePembelajaran: json['metode_pembelajaran'],
      dokumen: json['dokumen'],
      unitPenyelenggara: json['unit_penyelenggara'],
      capaianKuliahSikap: json['capaian_kuliah_sikap'] == null
          ? null
          : json['capaian_kuliah_sikap'] == 1,
      capaianKuliahPengetahuan: json['capaian_kuliah_pengetahuan'] == null
          ? null
          : json['capaian_kuliah_pengetahuan'] == 1,
      capaianKuliahKeterampilanUmum: json['capaian_kuliah_keterampilan_umum'] == null
          ? null
          : json['capaian_kuliah_keterampilan_umum'] == 1,
      capaianKuliahKeterampilanKhusus: json['capaian_kuliah_keterampilan_khusus'] == null
          ? null
          : json['capaian_kuliah_keterampilan_khusus'] == 1,
      tahun: json['tahun'],
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'nama_mata_kuliah': namaMataKuliah,
      'kode_mata_kuliah': kodeMataKuliah,
      'mata_kuliah_kompetensi': mataKuliahKompetensi == true ? 1 : 0,
      'sks_kuliah': sksKuliah,
      'sks_seminar': sksSeminar,
      'sks_praktikum': sksPraktikum,
      'konversi_sks': konversiSks,
      'semester': semester,
      'metode_pembelajaran': metodePembelajaran,
      'dokumen': dokumen,
      'unit_penyelenggara': unitPenyelenggara,
      'capaian_kuliah_sikap': capaianKuliahSikap == true ? 1 : 0,
      'capaian_kuliah_pengetahuan': capaianKuliahPengetahuan == true ? 1 : 0,
      'capaian_kuliah_keterampilan_umum':
          capaianKuliahKeterampilanUmum == true ? 1 : 0,
      'capaian_kuliah_keterampilan_khusus':
          capaianKuliahKeterampilanKhusus == true ? 1 : 0,
      'tahun': tahun,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
