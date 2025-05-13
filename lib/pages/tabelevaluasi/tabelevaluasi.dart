import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/pages/kinerja_dosen/pkm_dtps.dart';
import 'package:gkm_mobile/pages/kinerjadosen/kinerjadosen.dart';
import 'package:gkm_mobile/pages/rekapdata/dosen.dart';
import 'package:gkm_mobile/pages/rekapdata/evaluasi_lulusan.dart';
import 'package:gkm_mobile/pages/rekapdata/ipk_lulusan.dart';
import 'package:gkm_mobile/pages/rekapdata/kualitas_pembelajaran.dart';
import 'package:gkm_mobile/pages/rekapdata/luaran_lainnya.dart';
import 'package:gkm_mobile/pages/rekapdata/luaran_mahasiswa.dart';
import 'package:gkm_mobile/pages/rekapdata/masa_studi_lulusan.dart';
import 'package:gkm_mobile/pages/rekapdata/penelitian_dpts.dart';
import 'package:gkm_mobile/pages/rekapdata/pkm_dtps.dart';
import 'package:gkm_mobile/pages/rekapdata/prestasi_mahasiswa.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gkm_mobile/pages/rekapdata/kerjasamatridharma.dart';
import 'package:gkm_mobile/pages/rekapdata/mahasiswa.dart';

import '../rekapdata/kinerjadosenRD.dart';

class tabelevaluasi extends StatefulWidget {
  const tabelevaluasi({super.key});

  @override
  State<tabelevaluasi> createState() => _tabelevaluasiState();
}

class _tabelevaluasiState extends State<tabelevaluasi> {
  // ✅ Default tahun ajaran dengan id = 2
  TahunAjaran selectedTahunAjaran = TahunAjaran(id: 2,tahunAjaran: '2023/2024', semester: 'ganjil', slug: '2023-2024-ganjil', createdAt: DateTime.now(), updatedAt: DateTime.now());

  final List<Map<String, dynamic>> rekapData = [
    {
      "judul": "Kerjasama Tridharma",
      "progress": 0.0,
      "status": "Belum ada kemajuan",
      "score": 0
    },
    {
      "judul": "Data Mahasiswa",
      "progress": 0.3,
      "status": "Kurang peningkatan",
      "score": 30
    },
    {
      "judul": "Data Dosen",
      "progress": 0.5,
      "status": "Cukup baik",
      "score": 65
    },
    {
      "judul": "Kinerja Dosen",
      "progress": 0.7,
      "status": "Perlu peningkatan",
      "score": 70
    },
    {
      "judul": "Luaran Lainnya",
      "progress": 0.7,
      "status": "Perlu peningkatan",
      "score": 70
    },
    {
      "judul": "Kualitas Pembelajaran",
      "progress": 0.8,
      "status": "Perlu peningkatan",
      "score": 80
    },
    {
      "judul": "Penelitian DTPS",
      "progress": 0.6,
      "status": "Perlu peningkatan",
      "score": 60
    },
    {
      "judul": "PKM DTPS",
      "progress": 0.5,
      "status": "Perlu peningkatan",
      "score": 50
    },
    {
      "judul": "IPK Lulusan",
      "progress": 0.3,
      "status": "Perlu peningkatan",
      "score": 30
    },
    {
      "judul": "Prestasi Mahasiswa",
      "progress": 0.7,
      "status": "Perlu peningkatan",
      "score": 70
    },
    {
      "judul": "Masa Studi Lulusan",
      "progress": 0.4,
      "status": "Perlu peningkatan",
      "score": 40
    },
    {
      "judul": "Evaluasi Lulusan",
      "progress": 0.9,
      "status": "Hampir lengkap",
      "score": 90
    },
    {
      "judul": "Luaran Karya Mahasiswa",
      "progress": 1.0,
      "status": "Lengkap",
      "score": 100
    }
  ];

  final Map<String, Widget Function(TahunAjaran)> formRoutes = {
    "Kerjasama Tridharma": (tahunAjaran) => kerjasamatridharma(tahunAjaran: tahunAjaran),
    "Data Mahasiswa": (tahunAjaran) => MahasiswaPage(tahunAjaran: tahunAjaran),
    "Data Dosen": (tahunAjaran) => dosen(tahunAjaran: tahunAjaran),
    "Kinerja Dosen": (tahunAjaran) => kinerjadosenRD(tahunAjaran: tahunAjaran),
    "Luaran Lainnya": (tahunAjaran) => luaranlainnya(tahunAjaran: tahunAjaran),
    "Kualitas Pembelajaran": (tahunAjaran) => KualitasPembelajaran(tahunAjaran: tahunAjaran),
    "Penelitian DTPS": (tahunAjaran) => PenelitianDtps(tahunAjaran: tahunAjaran),
    "PKM DTPS": (tahunAjaran) => Pkm_Dtps(tahunAjaran: tahunAjaran),
    "IPK Lulusan": (tahunAjaran) => IpkLulusan(tahunAjaran: tahunAjaran),
    "Prestasi Mahasiswa": (tahunAjaran) => PrestasiMahasiswa(tahunAjaran: tahunAjaran),
    "Masa Studi Lulusan": (tahunAjaran) => MasaStudiLulusan(tahunAjaran: tahunAjaran),
    "Evaluasi Lulusan": (tahunAjaran) => EvaluasiLulusan(tahunAjaran: tahunAjaran),
    "Luaran Karya Mahasiswa": (tahunAjaran) => luaranmahasiswa(tahunAjaran: tahunAjaran),
    // Tambahkan lainnya di sini nanti
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rekap Data & Evaluasi",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tabel Evaluasi",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: rekapData.length,
                itemBuilder: (context, index) {
                  var item = rekapData[index];
                  return InkWell(
                    onTap: () {
                      final builder = formRoutes[item["judul"]];
                      if (builder != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => builder(selectedTahunAjaran),
                          ),
                        );
                      }
                    },
                    child: Card(
                      elevation: 0.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item["judul"],
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "Skor: ${item["score"]}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: item["progress"],
                                backgroundColor: Colors.grey[300],
                                color: _getProgressColor(item["progress"]),
                                minHeight: 12,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item["status"],
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w200,
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress <= 0.3) return Colors.red;
    if (progress <= 0.5) return Colors.orange;
    if (progress <= 0.7) return Colors.yellow;
    return const Color(0xFF00B98F);
  }
}
