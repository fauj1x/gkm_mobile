import 'package:flutter/material.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:gkm_mobile/services/auth_service.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/pages/rekapdata/tambahdataKT.dart';

class kinerjadosenRD extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const kinerjadosenRD({Key? key, required this.tahunAjaran}) : super(key: key);

  @override
  _KinerjaDosenState createState() => _KinerjaDosenState();
}

class _KinerjaDosenState extends State<kinerjadosenRD> {
  int userId = 0;
  List<List<String>> dataList = [];

  @override
  void initState() {
    super.initState();
    _fetchUserIdAndRekap();
  }

  Future<void> _fetchUserIdAndRekap() async {
    // Ambil userId dari AuthProvider, bukan dari SharedPreferences
    final userIdStr = await AuthProvider().getId();
    userId = int.tryParse(userIdStr) ?? 0;
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
            "Pengakuan/Rekognisi Dosen",
            (data["Tabel 3.b.1) Pengakuan/Rekognisi Dosen"]?["count"] ?? "-").toString(),
            (data["Tabel 3.b.1) Pengakuan/Rekognisi Dosen"]?["status"] ?? "-")
          ],
          [
            "2",
            "Penelitian DTPS",
            (data["Tabel 3.b.2) Penelitian DTPS"]?["count"] ?? "-").toString(),
            (data["Tabel 3.b.2) Penelitian DTPS"]?["status"] ?? "-")
          ],
          [
            "3",
            "PKM DTPS",
            (data["Tabel 3.b.3) PkM DTPS"]?["count"] ?? "-").toString(),
            (data["Tabel 3.b.3) PkM DTPS"]?["status"] ?? "-")
          ],
          [
            "4",
            "Pagelaran/Pameran/Publikasi Ilmiah DTPS",
            (data["Tabel 3.b.4) Pagelaran/Pameran/Publikasi Ilmiah DTPS"]?["count"] ?? "-").toString(),
            (data["Tabel 3.b.4) Pagelaran/Pameran/Publikasi Ilmiah DTPS"]?["status"] ?? "-")
          ],
          [
            "5",
            "Karya Ilmiah DTPS yang Disitasi",
            (data["Tabel 3.b.5) Karya Ilmiah DTPS yang Disitasi"]?["count"] ?? "-").toString(),
            (data["Tabel 3.b.5) Karya Ilmiah DTPS yang Disitasi"]?["status"] ?? "-")
          ],
          [
            "6",
            "Produk/Jasa DTPS yang Diadopsi",
            (data["Tabel 3.b.6) Produk/Jasa DTPS yang Diadopsi"]?["count"] ?? "-").toString(),
            (data["Tabel 3.b.6) Produk/Jasa DTPS yang Diadopsi"]?["status"] ?? "-")
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
              "Kinerja Dosen",
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
              ),
              const SizedBox(height: 10),
              const Text(
                "Tabel Kinerja Dosen",
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