import 'package:flutter/material.dart';

class pendidikan extends StatefulWidget {
  @override
  _PendidikanState createState() => _PendidikanState();
}

class _PendidikanState extends State<pendidikan> {
  List<List<String>> dataList = [
    ["1", "Universitas A", "✓", "", "", "Judul 1", "Manfaat 1", "Bukti 1", "2024"],
    ["2", "Universitas B", "", "✓", "", "Judul 2", "Manfaat 2", "Bukti 2", "2025"],
  ];

  void _tambahData() {
    setState(() {
      dataList.add(["${dataList.length + 1}", "", "", "", "", "", "", "", ""]);
    });
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Kerjasama Tridharma",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 2),
            Text(
              "Pendidikan",
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
              child: Row(
                children: [
                  const Icon(Icons.search, color: Color(0xFF009688)),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Color(0xFF009688)),
                      decoration: const InputDecoration(
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
              "Tabel Kerjasama Pendidikan",
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
                          _headerCell("Lembaga Mitra", 150),
                          _headerCell("Tingkat", 270),
                          _headerCell("Judul Kerjasama", 200),
                          _headerCell("Manfaat bagi PS", 200),
                          _headerCell("Bukti Kerjasama", 150),
                          _headerCell("Tahun Berakhir", 150),
                          _headerCell("Aksi", 50),
                        ],
                      ),
                    ),

                    // Header Baris 2 (Tingkat)
                    Container(
                      color: const Color(0xFF009688),
                      child: Row(
                        children: [
                          _emptyCell(50),
                          _emptyCell(150),
                          _headerCell("Internasional", 90),
                          _headerCell("Nasional", 90),
                          _headerCell("Wilayah/Lokal", 90),
                          _emptyCell(200),
                          _emptyCell(200),
                          _emptyCell(150),
                          _emptyCell(150),
                          _emptyCell(50),
                        ],
                      ),
                    ),

                    // Isi Data
                    Table(
                      border: TableBorder.all(color: Colors.black54),
                      columnWidths: const {
                        0: FixedColumnWidth(50),
                        1: FixedColumnWidth(150),
                        2: FixedColumnWidth(90),
                        3: FixedColumnWidth(90),
                        4: FixedColumnWidth(90),
                        5: FixedColumnWidth(200),
                        6: FixedColumnWidth(200),
                        7: FixedColumnWidth(150),
                        8: FixedColumnWidth(150),
                        9: FixedColumnWidth(50),
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
                onPressed: _tambahData,
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
    return Container(width: width, height: 40);
  }
}
