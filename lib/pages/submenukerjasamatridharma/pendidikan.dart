import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/pendidikan.dart';
import 'package:gkm_mobile/services/api_services.dart';

class pendidikan extends StatefulWidget {
  @override
  _PendidikanState createState() => _PendidikanState();
}

class _PendidikanState extends State<pendidikan> {
  List<Pendidikan> dataList = [];
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data =
          await apiService.getData(Pendidikan.fromJson, "kstd-pendidikan");
      setState(() {
        dataList = data;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> _tambahData(Map<String, dynamic> newData) async {
    try {
      await apiService.postData(
          Pendidikan.fromJson, newData, "kstd-pendidikan");
      _fetchData();
    } catch (e) {
      print("Error adding data: $e");
    }
  }

  void _hapusData(int index) async {
    try {
      await apiService.deleteData(index, "kstd-pendidikan");
      _fetchData();
    } catch (e) {
      print("Error deleting data: $e");
    }
  }

  void _editData(int index, Map<String, dynamic> updatedData) async {
    try {
      await apiService.updateData(
          Pendidikan.fromJson, index, updatedData, "kstd-pendidikan");
      _fetchData();
    } catch (e) {
      print("Error editing data: $e");
    }
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
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                          _headerCell("Waktu Durasi", 150),
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
                        9: FixedColumnWidth(150),
                        10: FixedColumnWidth(50),
                      },
                      children: dataList.asMap().entries.map((entry) {
                        List<String> row = [
                          entry.value.id.toString(), // Nomor
                          entry.value.lembagaMitra, // Lembaga Mitra
                          entry.value.tingkat == "internasional"
                              ? "Internasional"
                              : "-", // Tingkat: Internasional
                          entry.value.tingkat == "nasional"
                              ? "Nasional"
                              : "-", // Tingkat: Nasional
                          entry.value.tingkat == "lokal"
                              ? "Lokal"
                              : "-", // Tingkat: Wilayah/Lokal
                          entry.value.judulKegiatan, // Judul Kerjasama
                          entry.value.manfaat, // Manfaaat
                          entry.value.waktuDurasi, // Manfaaat
                          entry.value.buktiKerjasama, // Bukti Kerjasama
                          entry.value.tahunBerakhir, // Tahun Berakhir
                        ];
                        return TableRow(
                          children: [
                            ...row.map((cell) {
                              return TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(cell.isEmpty ? "-" : cell)),
                                ),
                              );
                            }).toList(),

                            // Aksi Button
                            TableCell(
                              child: Center(
                                child: PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert,
                                      color: Colors.black87),
                                  onSelected: (String choice) {
                                    if (choice == "Edit") {
                                      _showEditDialog(entry.value.id, {
                                        'lembaga_mitra':
                                            entry.value.lembagaMitra,
                                        'tingkat': entry.value.tingkat,
                                        'judul_kegiatan':
                                            entry.value.judulKegiatan,
                                        'manfaat': entry.value.manfaat,
                                        'bukti_kerjasama':
                                            entry.value.buktiKerjasama,
                                        'waktu_durasi': entry.value.waktuDurasi,
                                        'tahun_berakhir':
                                            entry.value.tahunBerakhir,
                                      });
                                    } else if (choice == "Hapus") {
                                      _hapusData(entry.value.id);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: "Edit",
                                      child: ListTile(
                                        leading: Icon(Icons.edit,
                                            color: Colors.blue),
                                        title: Text("Edit"),
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: "Hapus",
                                      child: ListTile(
                                        leading: Icon(Icons.delete,
                                            color: Colors.red),
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
                onPressed: _showAddDialog,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Tambah Data",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
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
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _emptyCell(double width) {
    return Container(width: width, height: 40);
  }

  void _showAddDialog() {
    final TextEditingController lembagaController = TextEditingController();
    final TextEditingController tingkatController = TextEditingController();
    final TextEditingController judulController = TextEditingController();
    final TextEditingController manfaatController = TextEditingController();
    final TextEditingController waktuController = TextEditingController();
    final TextEditingController buktiController = TextEditingController();
    final TextEditingController tahunController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Data'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    controller: lembagaController,
                    decoration: InputDecoration(labelText: 'Lembaga Mitra')),
                TextField(
                    controller: tingkatController,
                    decoration: InputDecoration(labelText: 'Tingkat')),
                TextField(
                    controller: judulController,
                    decoration: InputDecoration(labelText: 'Judul Kerjasama')),
                TextField(
                    controller: manfaatController,
                    decoration: InputDecoration(labelText: 'Manfaat')),
                TextField(
                    controller: waktuController,
                    decoration: InputDecoration(labelText: 'Waktu Durasi')),
                TextField(
                    controller: buktiController,
                    decoration: InputDecoration(labelText: 'Bukti Kerjasama')),
                TextField(
                    controller: tahunController,
                    decoration: InputDecoration(labelText: 'Tahun Berakhir')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _tambahData({
                  'user_id': 5, // Ganti dengan ID user yang sesuai
                  'tahun_ajaran_id':
                      8, // Ganti dengan ID tahun ajaran yang sesuai
                  'lembaga_mitra': lembagaController.text,
                  'tingkat': tingkatController.text,
                  'judul_kegiatan': judulController.text,
                  'manfaat': manfaatController.text,
                  'waktu_durasi': waktuController.text,
                  'bukti_kerjasama': buktiController.text,
                  'tahun_berakhir': tahunController.text,
                });
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(int id, Map<String, dynamic> currentData) {
    final TextEditingController lembagaController =
        TextEditingController(text: currentData['lembaga_mitra']);
    final TextEditingController tingkatController =
        TextEditingController(text: currentData['tingkat']);
    final TextEditingController judulController =
        TextEditingController(text: currentData['judul_kegiatan']);
    final TextEditingController manfaatController =
        TextEditingController(text: currentData['manfaat']);
    final TextEditingController waktuController =
        TextEditingController(text: currentData['waktu_durasi']);
    final TextEditingController buktiController =
        TextEditingController(text: currentData['bukti_kerjasama']);
    final TextEditingController tahunController =
        TextEditingController(text: currentData['tahun_berakhir']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Data'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    controller: lembagaController,
                    decoration: InputDecoration(labelText: 'Lembaga Mitra')),
                TextField(
                    controller: tingkatController,
                    decoration: InputDecoration(labelText: 'Tingkat')),
                TextField(
                    controller: judulController,
                    decoration: InputDecoration(labelText: 'Judul Kerjasama')),
                TextField(
                    controller: manfaatController,
                    decoration: InputDecoration(labelText: 'Manfaat')),
                TextField(
                    controller: waktuController,
                    decoration: InputDecoration(labelText: 'Waktu Durasi')),
                TextField(
                    controller: buktiController,
                    decoration: InputDecoration(labelText: 'Bukti Kerjasama')),
                TextField(
                    controller: tahunController,
                    decoration: InputDecoration(labelText: 'Tahun Berakhir')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _editData(id, {
                  'lembaga_mitra': lembagaController.text,
                  'tingkat': tingkatController.text,
                  'judul_kegiatan': judulController.text,
                  'manfaat': manfaatController.text,
                  'waktu_durasi': waktuController.text,
                  'bukti_kerjasama': buktiController.text,
                  'tahun_berakhir': tahunController.text,
                });
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
