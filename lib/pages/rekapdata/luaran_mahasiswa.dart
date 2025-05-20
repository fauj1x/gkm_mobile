import 'package:flutter/material.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/pages/rekapdata/tambahdataKT.dart';

class luaranmahasiswa extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const luaranmahasiswa({Key? key, required this.tahunAjaran}) : super(key: key);

  @override
  _LuaranmahasiswaState createState() => _LuaranmahasiswaState();
}

class _LuaranmahasiswaState extends State<luaranmahasiswa> {
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
        tahun_ajaran_id: widget.tahunAjaran.tahunAjaran,
        userId: userId,
      );
      setState(() {
        dataList = [
          [
            "1",
            "Pagelaran/Pameran/Presentasi/Publikasi Ilmiah Mahasiswa",
            data["Tabel 8.f.1) Pagelaran/Pameran/Presentasi/Publikasi Ilmiah Mahasiswa"]["count"].toString(),
            data["Tabel 8.f.1) Pagelaran/Pameran/Presentasi/Publikasi Ilmiah Mahasiswa"]["status"]
          ],
          [
            "2",
            "Karya Ilmiah Mahasiswa yang Disitasi",
            data["Tabel 8.f.2) Karya Ilmiah Mahasiswa yang Disitasi"]["count"].toString(),
            data["Tabel 8.f.2) Karya Ilmiah Mahasiswa yang Disitasi"]["status"]
          ],
          [
            "3",
            "Produk/Jasa Mahasiswa yang Diadopsi oleh Industri/Masyarakat",
            data["Tabel 8.f.3) Produk/Jasa Mahasiswa yang Diadopsi oleh Industri/Masyarakat"]["count"].toString(),
            data["Tabel 8.f.3) Produk/Jasa Mahasiswa yang Diadopsi oleh Industri/Masyarakat"]["status"]
          ],
          [
            "4",
            "Luaran Penelitian yang Dihasilkan Mahasiswa - HKI (Paten, Paten Sederhana)",
            data["Tabel 8.f.4) Luaran Penelitian yang Dihasilkan Mahasiswa - HKI (Paten, Paten Sederhana)"]["count"].toString(),
            data["Tabel 8.f.4) Luaran Penelitian yang Dihasilkan Mahasiswa - HKI (Paten, Paten Sederhana)"]["status"]
          ],
          [
            "5",
            "Luaran Penelitian yang Dihasilkan Mahasiswa - HKI (Hak Cipta, Desain Produk Industri, dll.)",
            data["Tabel 8.f.5) Luaran Penelitian yang Dihasilkan Mahasiswa - HKI (Hak Cipta, Desain Produk Industri, dll.)"]["count"].toString(),
            data["Tabel 8.f.5) Luaran Penelitian yang Dihasilkan Mahasiswa - HKI (Hak Cipta, Desain Produk Industri, dll.)"]["status"]
          ],
          [
            "6",
            "Luaran Penelitian yang Dihasilkan Mahasiswa - Teknologi Tepat Guna, Produk, Karya Seni, Rekayasa Sosial",
            data["Tabel 8.f.6) Luaran Penelitian yang Dihasilkan Mahasiswa - Teknologi Tepat Guna, Produk, Karya Seni, Rekayasa Sosial"]["count"].toString(),
            data["Tabel 8.f.6) Luaran Penelitian yang Dihasilkan Mahasiswa - Teknologi Tepat Guna, Produk, Karya Seni, Rekayasa Sosial"]["status"]
          ],
          [
            "7",
            "Luaran Penelitian yang Dihasilkan Mahasiswa - Buku ber-ISBN, Book Chapter",
            data["Tabel 8.f.7) Luaran Penelitian yang Dihasilkan Mahasiswa - Buku ber-ISBN, Book Chapter"]["count"].toString(),
            data["Tabel 8.f.7) Luaran Penelitian yang Dihasilkan Mahasiswa - Buku ber-ISBN, Book Chapter"]["status"]
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
              "Luaran Karya Mahasiswa",
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
      body: SingleChildScrollView(
        child: Padding(
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
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Color(0xFF009688)),
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Color(0xFF009688)),
                        decoration: InputDecoration(
                          hintText: "Cari data...",
                          hintStyle: TextStyle(color: Color(0xFF009688)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tabel Luaran Karya Mahasiswa",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              SingleChildScrollView(
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
            ],
          ),
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
