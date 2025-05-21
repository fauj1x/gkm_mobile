import 'package:flutter/material.dart';

class rekapdata extends StatefulWidget {
  const rekapdata({super.key});

  @override
  _KerjasamaTridarmaPageState createState() => _KerjasamaTridarmaPageState();
}

class _KerjasamaTridarmaPageState extends State<rekapdata> {
  List<List<String>> dataList = [
    ["1", "", ""],
    ["2", "", ""],
  ];

  void _tambahData() {
    setState(() {
      dataList.add(["${dataList.length + 1}", "", ""]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rekap Data",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Search
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Cari data...",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Judul Tabel
            const Text(
              "Tabel Kerjasama Pendidikan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Tabel
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    WidgetStateProperty.all(Colors.teal), // Header hijau
                columns: const [
                  DataColumn(
                    label: Text("No", style: TextStyle(color: Colors.white)),
                  ),
                  DataColumn(
                    label: Text("Lembaga Mitra",
                        style: TextStyle(color: Colors.white)),
                  ),
                  DataColumn(
                    label: Text("Internasional",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
                rows: dataList.map((row) {
                  return DataRow(
                    cells: row.map((cell) {
                      return DataCell(
                        cell.isEmpty
                            ? const Text("-") // Default kosong "-"
                            : Text(cell),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Tombol Tambah Data
            ElevatedButton.icon(
              onPressed: _tambahData,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Tambah Data",
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
