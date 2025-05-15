import 'package:flutter/material.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/pages/rekapdata/tambahdataKT.dart';

class dosen extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const dosen({Key? key, required this.tahunAjaran}) : super(key: key);

  @override
  _DosenState createState() => _DosenState();
}

class _DosenState extends State<dosen> {
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
      final data = await apiService.getRekapData(widget.tahunAjaran.id, userId);

      setState(() {
        dataList = [
          [
            "1",
            "Dosen Tetap Perguruan Tinggi",
            data["Tabel 3.a.1) Dosen Tetap Perguruan Tinggi"]["count"].toString(),
            data["Tabel 3.a.1) Dosen Tetap Perguruan Tinggi"]["status"]
          ],
          [
            "2",
            "Dosen Pembimbing Utama Tugas Akhir",
            data["Tabel 3.a.2) Dosen Pembimbing Utama Tugas Akhir"]["count"].toString(),
            data["Tabel 3.a.2) Dosen Pembimbing Utama Tugas Akhir"]["status"]
          ],
          [
            "3",
            "Ekuivalen Waktu Mengajar Penuh (EWMP) Dosen Tetap Perguruan Tinggi",
            data["Tabel 3.a.3) Ekuivalen Waktu Mengajar Penuh (EWMP) Dosen Tetap Perguruan Tinggi"]["count"].toString(),
            data["Tabel 3.a.3) Ekuivalen Waktu Mengajar Penuh (EWMP) Dosen Tetap Perguruan Tinggi"]["status"]
          ],
          [
            "4",
            "Dosen Tidak Tetap",
            data["Tabel 3.a.4) Dosen Tidak Tetap"]["count"].toString(),
            data["Tabel 3.a.4) Dosen Tidak Tetap"]["status"]
          ],
          [
            "5",
            "Dosen Industri/Praktisi",
            data["Tabel 3.a.5) Dosen Industri/Praktisi"]["count"].toString(),
            data["Tabel 3.a.5) Dosen Industri/Praktisi"]["status"]
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
              "Data Dosen",
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
              "Tabel Data Dosen",
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
