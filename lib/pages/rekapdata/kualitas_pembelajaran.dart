import 'package:flutter/material.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/pages/rekapdata/tambahdataKT.dart';

class KualitasPembelajaran extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const KualitasPembelajaran({Key? key, required this.tahunAjaran}) : super(key: key);

  @override
  _KualitasPembelajaranState createState() => _KualitasPembelajaranState();
}

class _KualitasPembelajaranState extends State<KualitasPembelajaran> {
  int userId = 0;
  List<List<String>> dataList = [];

  @override
  void initState() {
    super.initState();
    _fetchUserIdAndRekap();
  }

  Future<void> _fetchUserIdAndRekap() async {
    final prefs = await SharedPreferences.getInstance();
    userId = int.parse(prefs.getString('id') ?? '0');
    await fetchRekapData();
  }

  Future<void> fetchRekapData() async {
    try {
      final apiService = ApiService();
      final data = await apiService.getRekapData(
        tahunAjaranSlug: widget.tahunAjaran.slug, // gunakan slug di sini!
        userId: userId,
      );
      setState(() {
        dataList = [
          [
            "1",
            "Kurikulum, Capaian Pembelajaran, dan Rencana Pembelajaran",
            data["Tabel 5.a Kurikulum & Rencana Pembelajaran"]["count"].toString(),
            data["Tabel 5.a Kurikulum & Rencana Pembelajaran"]["status"]
          ],
          [
            "2",
            "Integrasi Kegiatan Penelitian/PkM dalam Pembelajaran",
            data["Tabel 5.b Integrasi Penelitian/PkM"]["count"].toString(),
            data["Tabel 5.b Integrasi Penelitian/PkM"]["status"]
          ],
          [
            "3",
            "Kepuasan Mahasiswa",
            data["Tabel 5.c Kepuasan Mahasiswa"]["count"].toString(),
            data["Tabel 5.c Kepuasan Mahasiswa"]["status"]
          ],

        ];
      });
    } catch (e) {
      print("Error saat mengambil rekap: $e");
    }
  }

  void _tambahData(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormKerjasamaTridharma()),
    );
  }

  void _hapusData(int index) {
    setState(() {
      dataList.removeAt(index);
    });
  }

  void _editData(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Edit data ke-${index + 1}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kualitas Pembelajaran",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 2),
            Text(
              "Rekap Data",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tabel Kualitas Pembelajaran",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Container(
                      color: Colors.teal,
                      child: Row(
                        children: [
                          _headerCell("No", 50),
                          _headerCell("Komponen", 150),
                          _headerCell("Total", 270),
                          _headerCell("Keterangan", 200),
                        ],
                      ),
                    ),
                    Table(
                      border: TableBorder.all(color: Colors.black54),
                      columnWidths: const {
                        0: FixedColumnWidth(50),
                        1: FixedColumnWidth(150),
                        2: FixedColumnWidth(270),
                        3: FixedColumnWidth(200),
                      },
                      children: dataList.asMap().entries.map((entry) {
                        int index = entry.key;
                        List<String> row = entry.value;
                        return TableRow(
                          children: [
                            ...row.map((cell) {
                              return TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Text(cell.isEmpty ? "-" : cell)),
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(String text, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
