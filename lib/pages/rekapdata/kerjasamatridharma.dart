import 'package:flutter/material.dart';
import 'package:gkm_mobile/pages/rekapdata/tambahdataKT.dart';
import 'package:gkm_mobile/main.dart';


class kerjasamatridharma extends StatefulWidget {
  const kerjasamatridharma({super.key});

  @override
  _PendidikanState createState() => _PendidikanState();
}

class _PendidikanState extends State<kerjasamatridharma> {
  List<List<String>> dataList = [
    ["1", "Kerjasama Tridharma - Pendidikan", "", ""],
    ["2", "Kerjasama Tridharma - Penelitian", "", ""],
    ["3", "Kerjasama Tridharma - Pengabdian Kepada Masyarakat", "", ""],
  ];

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
              "Kerjasama Tridharma",
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
            // Input Search
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
              "Tabel Rekap Kerjasama Tridharma",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),

            // Tabel Scrollable
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    // Header Baris 1
                    Container(
                      color: Colors.teal,
                      child: Row(
                        children: [
                          _headerCell("No", 50),
                          _headerCell("Komponen", 150),
                          _headerCell("Total", 270),
                          _headerCell("Keterangan", 200),
                          _headerCell("Aksi", 50),
                        ],
                      ),
                    ),

                    // Isi Data
                    Table(
                      border: TableBorder.all(color: Colors.black54),
                      columnWidths: const {
                        0: FixedColumnWidth(50),
                        1: FixedColumnWidth(150),
                        2: FixedColumnWidth(270),
                        3: FixedColumnWidth(200),
                        4: FixedColumnWidth(50),
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

                            // Aksi Button
                            TableCell(
                              child: Center(
                                child: PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert, color: Colors.black87),
                                  onSelected: (String choice) {
                                    if (choice == "Edit") {
                                      _editData(index);
                                    } else if (choice == "Hapus") {
                                      _hapusData(index);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: "Edit",
                                      child: ListTile(
                                        leading: Icon(Icons.edit, color: Colors.blue),
                                        title: Text("Edit"),
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: "Hapus",
                                      child: ListTile(
                                        leading: Icon(Icons.delete, color: Colors.red),
                                        title: Text("Hapus"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Tombol Tambah Data di Bawah Tabel
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _tambahData(context),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Tambah Data", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  Widget _emptyCell(double width) {
    return SizedBox(width: width, height: 40);
  }
}
