import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/integrasi_penelitian.dart'; // Pastikan path ini benar
import 'package:gkm_mobile/models/tahun_ajaran.dart'; // Pastikan path ini benar
import 'package:gkm_mobile/services/api_services.dart'; // Pastikan path ini benar
import 'package:shared_preferences/shared_preferences.dart';

class IntegrasiPenelitian extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const IntegrasiPenelitian({Key? key, required this.tahunAjaran})
      : super(key: key);
  @override
  IntegrasiPenelitianState createState() => IntegrasiPenelitianState();
}

class IntegrasiPenelitianState extends State<IntegrasiPenelitian> {
  List<IntegrasiPenelitianModel> dataList = [];
  ApiService apiService = ApiService();
  String menuName = "Kualitas Pembelajaran";
  String subMenuName = "Integrasi Kegiatan Penelitian/PkM dalam Pembelajaran";
  String endPoint = "integrasi-penelitian";
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _fetchData();
  }

  Future<void> _fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = int.parse(prefs.getString('id') ?? '0');
      print('Fetched User ID: $userId'); // Debug: Cek user ID yang terambil
    });
  }

  Future<void> _fetchData() async {
    try {
      final data =
          await apiService.getData(IntegrasiPenelitianModel.fromJson, endPoint);
      setState(() {
        dataList = data;
      });
      print('Data fetched successfully. Total items: ${dataList.length}'); // Debug
    } catch (e) {
      print("Error fetching data: $e"); // Debug: Periksa error fetch data
    }
  }

  Future<void> _addData(Map<String, dynamic> newData) async {
    print("Attempting to add data with payload: $newData"); // Debug: Lihat payload yang dikirim
    try {
      await apiService.postData(
          IntegrasiPenelitianModel.fromJson, newData, endPoint);
      _fetchData(); // Refresh data setelah penambahan
      print("Data added successfully!"); // Debug
    } catch (e) {
      print("Error adding data: $e"); // Debug: Periksa error saat menambahkan data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan data: $e')),
      );
    }
  }

  Future<void> _deleteData(int id) async { // Parameter diubah menjadi 'id'
    print("Attempting to delete data with ID: $id"); // Debug
    try {
      await apiService.deleteData(id, endPoint);
      _fetchData(); // Refresh data setelah penghapusan
      print("Data deleted successfully!"); // Debug
    } catch (e) {
      print("Error deleting data: $e"); // Debug: Periksa error saat menghapus data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data: $e')),
      );
    }
  }

  Future<void> _editData(int id, Map<String, dynamic> updatedData) async { // Parameter diubah menjadi 'id'
    print("Attempting to edit data with ID: $id and payload: $updatedData"); // Debug
    try {
      await apiService.updateData(
          IntegrasiPenelitianModel.fromJson, id, updatedData, endPoint);
      _fetchData(); // Refresh data setelah pengeditan
      print("Data edited successfully!"); // Debug
    } catch (e) {
      print("Error editing data: $e"); // Debug: Periksa error saat mengedit data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengedit data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          children: [
            Text(
              menuName,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 2),
            Text(
              subMenuName,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
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
                Text(
                  "Tabel $menuName $subMenuName",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          // Header Baris 1
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _headerCell("No.", 50),
                                _headerCell("Judul Penelitian/PkM", 150), // Lebar disesuaikan
                                _headerCell("Nama Dosen", 120), // Lebar disesuaikan
                                _headerCell("Mata Kuliah", 120), // Lebar disesuaikan
                                _headerCell("Bentuk Integrasi", 150), // Lebar disesuaikan
                                _headerCell("Tahun (YYYY)", 100),
                                _headerCell("Aksi", 80), // Lebar disesuaikan
                              ],
                            ),
                          ),

                          // Isi Data
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50),
                              1: FixedColumnWidth(150),
                              2: FixedColumnWidth(120),
                              3: FixedColumnWidth(120),
                              4: FixedColumnWidth(150),
                              5: FixedColumnWidth(100),
                              6: FixedColumnWidth(80),
                            },
                            children: dataList.asMap().entries.map((entry) {
                              List<String> row = [
                                (entry.key + 1).toString(),
                                entry.value.judulPenelitian,
                                entry.value.namaDosen,
                                entry.value.mataKuliah,
                                entry.value.bentukIntegrasi,
                                entry.value.tahun.toString(),
                              ];
                              return TableRow(
                                children: [
                                  ...row.map((cell) {
                                    return TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                                cell.isEmpty ? "-" : cell)),
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
                                            _showEditDialog(entry.value.id!, { // Pastikan ID tidak null
                                              'judul_penelitian':
                                                  entry.value.judulPenelitian,
                                              'nama_dosen':
                                                  entry.value.namaDosen,
                                              'mata_kuliah':
                                                  entry.value.mataKuliah,
                                              'bentuk_integrasi':
                                                  entry.value.bentukIntegrasi,
                                              'tahun': entry.value.tahun,
                                              'user_id': userId,
                                            });
                                          } else if (choice == "Hapus") {
                                            _deleteData(entry.value.id!); // Pastikan ID tidak null
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
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),

          // Floating Button
          Positioned(
            bottom: 48,
            right: 24,
            child: FloatingActionButton.extended(
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Tambah Data",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.teal,
            ),
          ),
        ],
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

  void _showAddDialog() {
    final TextEditingController namaDosenController = TextEditingController();
    final TextEditingController judulPenelitianController = TextEditingController();
    final TextEditingController mataKuliahController = TextEditingController();
    final TextEditingController bentukIntegrasiController = TextEditingController();
    final TextEditingController tahunController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data Integrasi Penelitian/PkM'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Penting agar column tidak memenuhi seluruh tinggi
              children: [
                TextField(
                  controller: namaDosenController,
                  decoration: const InputDecoration(labelText: "Nama Dosen"),
                ),
                TextField(
                  controller: judulPenelitianController,
                  decoration:
                      const InputDecoration(labelText: "Judul Penelitian/PkM"),
                ),
                TextField(
                  controller: mataKuliahController,
                  decoration: const InputDecoration(labelText: "Mata Kuliah"),
                ),
                TextField(
                  controller: bentukIntegrasiController,
                  decoration:
                      const InputDecoration(labelText: "Bentuk Integrasi"),
                ),
                TextField(
                  controller: tahunController,
                  keyboardType: TextInputType.number, // Hanya menerima angka
                  decoration: const InputDecoration(labelText: "Tahun (YYYY)"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Validasi input
                if (namaDosenController.text.isEmpty ||
                    judulPenelitianController.text.isEmpty ||
                    mataKuliahController.text.isEmpty ||
                    bentukIntegrasiController.text.isEmpty ||
                    tahunController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua kolom harus diisi.')),
                  );
                  return; // Jangan lanjutkan jika ada kolom kosong
                }

                final int? tahun = int.tryParse(tahunController.text);
                if (tahun == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tahun harus berupa angka.')),
                  );
                  return; // Jangan lanjutkan jika tahun bukan angka
                }

                _addData({
                  'nama_dosen': namaDosenController.text,
                  'judul_penelitian': judulPenelitianController.text,
                  'mata_kuliah': mataKuliahController.text,
                  'bentuk_integrasi': bentukIntegrasiController.text,
                  'tahun': tahun,
                  'user_id': userId,
                });
                Navigator.pop(context); // Tutup dialog setelah data ditambahkan
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(int id, Map<String, dynamic> currentData) {
    final TextEditingController namaDosenController =
        TextEditingController(text: currentData['nama_dosen']);
    final TextEditingController judulPenelitianController =
        TextEditingController(text: currentData['judul_penelitian']);
    final TextEditingController mataKuliahController =
        TextEditingController(text: currentData['mata_kuliah']);
    final TextEditingController bentukIntegrasiController =
        TextEditingController(text: currentData['bentuk_integrasi']);
    final TextEditingController tahunController =
        TextEditingController(text: currentData['tahun'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Integrasi Penelitian/PkM'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Penting agar column tidak memenuhi seluruh tinggi
              children: [
                TextField(
                  controller: namaDosenController,
                  decoration: const InputDecoration(labelText: "Nama Dosen"),
                ),
                TextField(
                  controller: judulPenelitianController,
                  decoration:
                      const InputDecoration(labelText: "Judul Penelitian/PkM"),
                ),
                TextField(
                  controller: mataKuliahController,
                  decoration: const InputDecoration(labelText: "Mata Kuliah"),
                ),
                TextField(
                  controller: bentukIntegrasiController,
                  decoration:
                      const InputDecoration(labelText: "Bentuk Integrasi"),
                ),
                TextField(
                  controller: tahunController,
                  keyboardType: TextInputType.number, // Hanya menerima angka
                  decoration: const InputDecoration(labelText: "Tahun (YYYY)"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Validasi input untuk edit
                if (namaDosenController.text.isEmpty ||
                    judulPenelitianController.text.isEmpty ||
                    mataKuliahController.text.isEmpty ||
                    bentukIntegrasiController.text.isEmpty ||
                    tahunController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua kolom harus diisi.')),
                  );
                  return;
                }

                final int? tahun = int.tryParse(tahunController.text);
                if (tahun == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tahun harus berupa angka.')),
                  );
                  return;
                }

                _editData(id, {
                  'nama_dosen': namaDosenController.text,
                  'judul_penelitian': judulPenelitianController.text,
                  'mata_kuliah': mataKuliahController.text,
                  'bentuk_integrasi': bentukIntegrasiController.text,
                  'tahun': tahun,
                  'user_id': userId,
                });
                Navigator.pop(context); // Tutup dialog setelah data diupdate
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}