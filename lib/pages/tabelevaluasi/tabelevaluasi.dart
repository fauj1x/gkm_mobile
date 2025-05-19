import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/auth.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:gkm_mobile/utils/kategori_tabel.dart';
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
import 'package:gkm_mobile/pages/rekapdata/kerjasamatridharma.dart';
import 'package:gkm_mobile/pages/rekapdata/mahasiswa.dart';
import '../rekapdata/kinerjadosenRD.dart';

class tabelevaluasi extends StatefulWidget {
  const tabelevaluasi({super.key});

  @override
  State<tabelevaluasi> createState() => _tabelevaluasiState();
}

class _tabelevaluasiState extends State<tabelevaluasi> {
  TahunAjaran? selectedTahunAjaran;

  List<TahunAjaran> tahunAjaranList = [];
  bool isLoadingTahunAjaran = false;
  bool isLoadingRekap = false;

  final List<Map<String, dynamic>> rekapData = [
    {"judul": "Kerjasama Tridharma", "progress": 0.0, "status": "", "score": 0},
    {"judul": "Data Mahasiswa", "progress": 0.0, "status": "", "score": 0},
    {"judul": "Data Dosen", "progress": 0.0, "status": "", "score": 0},
    {"judul": "Kinerja Dosen", "progress": 0.0, "status": "", "score": 0},
    {"judul": "Luaran Lainnya", "progress": 0.0, "status": "", "score": 0},
    {"judul": "Kualitas Pembelajaran", "progress": 0.0, "status": "", "score": 0},
    {"judul": "Penelitian DTPS", "progress": 0.0, "status": "", "score": 0},
    {"judul": "PKM DTPS", "progress": 0.0, "status": "", "score": 0},
    {"judul": "IPK Lulusan", "progress": 0.0, "status": "", "score": 0},
    {"judul": "Prestasi Mahasiswa", "progress": 0.0, "status": "", "score": 0},
    {"judul": "Masa Studi Lulusan", "progress": 0.0, "status": "", "score": 0},
    {"judul": "Evaluasi Lulusan", "progress": 0.0, "status": "", "score": 0},
    {"judul": "Luaran Karya Mahasiswa", "progress": 0.0, "status": "", "score": 0},
  ];

  final Map<String, Widget Function(TahunAjaran)> formRoutes = {
    "Kerjasama Tridharma": (ta) => kerjasamatridharma(tahunAjaran: ta),
    "Data Mahasiswa": (ta) => MahasiswaPage(tahunAjaran: ta),
    "Data Dosen": (ta) => dosen(tahunAjaran: ta),
    "Kinerja Dosen": (ta) => kinerjadosenRD(tahunAjaran: ta),
    "Luaran Lainnya": (ta) => luaranlainnya(tahunAjaran: ta),
    "Kualitas Pembelajaran": (ta) => KualitasPembelajaran(tahunAjaran: ta),
    "Penelitian DTPS": (ta) => PenelitianDtps(tahunAjaran: ta),
    "PKM DTPS": (ta) => Pkm_Dtps(tahunAjaran: ta),
    "IPK Lulusan": (ta) => IpkLulusan(tahunAjaran: ta),
    "Prestasi Mahasiswa": (ta) => PrestasiMahasiswa(tahunAjaran: ta),
    "Masa Studi Lulusan": (ta) => MasaStudiLulusan(tahunAjaran: ta),
    "Evaluasi Lulusan": (ta) => EvaluasiLulusan(tahunAjaran: ta),
    "Luaran Karya Mahasiswa": (ta) => luaranmahasiswa(tahunAjaran: ta),
  };

  @override
  void initState() {
    super.initState();
    fetchTahunAjaran();
  }

  Future<void> fetchTahunAjaran() async {
    setState(() => isLoadingTahunAjaran = true);
    try {
      final list = await ApiService().getData<TahunAjaran>(
            (json) => TahunAjaran.fromJson(json),
        "tahun-ajaran", // endpoint sesuai API kamu
      );
      setState(() {
        tahunAjaranList = list;
        if (tahunAjaranList.isNotEmpty) {
          selectedTahunAjaran = tahunAjaranList.first;
        }
        isLoadingTahunAjaran = false;
      });
      if (tahunAjaranList.isNotEmpty) {
        await fetchAndMapDataFromAPI();
      }
    } catch (e) {
      setState(() => isLoadingTahunAjaran = false);
      debugPrint("❌ Gagal mengambil tahun ajaran: $e");
    }
  }

  Future<void> fetchAndMapDataFromAPI() async {
    if (selectedTahunAjaran == null) return;
    setState(() => isLoadingRekap = true);
    try {
      final userIdStr = await AuthProvider().getId();
      final userId = int.parse(userIdStr);
      final apiService = ApiService();

      final data = await apiService.getRekapData(
        selectedTahunAjaran!.slug!,
        userId,
      );

      setState(() {
        for (var item in rekapData) {
          final kategori = item["judul"];
          final tabelKeys = kategoriTabel[kategori] ?? [];

          final statusList = tabelKeys
              .map((k) => data[k]?["status"]?.toString().toLowerCase() ?? "")
              .toList();

          double progress = 0.0;
          int complete = statusList.where((s) => s == "memenuhi").length;
          if (statusList.isNotEmpty) {
            progress = complete / statusList.length;
          }

          String statusText = "Belum ada kemajuan";
          if (progress == 1.0) {
            statusText = "Lengkap";
          } else if (progress >= 0.7) {
            statusText = "Hampir lengkap";
          } else if (progress >= 0.5) {
            statusText = "Perlu peningkatan";
          } else if (progress >= 0.3) {
            statusText = "Kurang peningkatan";
          }

          item["progress"] = progress;
          item["status"] = statusText;
          item["score"] = (progress * 100).round();
        }
        isLoadingRekap = false;
      });
    } catch (e) {
      setState(() => isLoadingRekap = false);
      debugPrint("❌ Gagal mengambil rekap data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rekap Data & Evaluasi", style: GoogleFonts.poppins()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tabel Evaluasi",
                    style: GoogleFonts.poppins(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 160,
                  child: DropdownButton<TahunAjaran>(
                    isExpanded: true,
                    value: tahunAjaranList.contains(selectedTahunAjaran) ? selectedTahunAjaran : null,
                    style: GoogleFonts.poppins(color: Colors.black),
                    icon: const Icon(Icons.arrow_drop_down),
                    borderRadius: BorderRadius.circular(10),
                    onChanged: isLoadingTahunAjaran
                        ? null
                        : (TahunAjaran? newValue) async {
                      if (newValue != null) {
                        setState(() {
                          selectedTahunAjaran = newValue;
                        });
                        await fetchAndMapDataFromAPI();
                      }
                    },
                    hint: isLoadingTahunAjaran
                        ? const Text('Memuat...')
                        : const Text('Pilih Tahun Ajaran'),
                    items: tahunAjaranList.map<DropdownMenuItem<TahunAjaran>>((TahunAjaran value) {
                      return DropdownMenuItem<TahunAjaran>(
                        value: value,
                        child: Text("${value.tahunAjaran} - ${value.semester}"),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isLoadingRekap
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: rekapData.length,
                itemBuilder: (context, index) {
                  var item = rekapData[index];
                  return InkWell(
                    onTap: () {
                      final builder = formRoutes[item["judul"]];
                      if (builder != null && selectedTahunAjaran != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                builder(selectedTahunAjaran!),
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
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(item["judul"],
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text("Skor: ${item["score"]}",
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white)),
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
                            Text(item["status"],
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 12,
                                    color: Colors.black87)),
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