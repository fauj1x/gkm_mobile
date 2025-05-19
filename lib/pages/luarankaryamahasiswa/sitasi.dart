import 'package:flutter/material.dart';
// Pastikan import model yang sesuai
import 'package:gkm_mobile/models/luaran_penelitian_lain_aio.dart'; // Ganti sesuai path dan nama file
import 'package:gkm_mobile/models/luaranmhs_sitasi.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LuaranPenelitianLainAioScreen extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const LuaranPenelitianLainAioScreen({Key? key, required this.tahunAjaran}) : super(key: key);

  @override
  _LuaranPenelitianLainAioScreenState createState() => _LuaranPenelitianLainAioScreenState();
}

class _LuaranPenelitianLainAioScreenState extends State<LuaranPenelitianLainAioScreen> {
  List<sitasimahasiswa> dataList = [];
  ApiService apiService = ApiService();

  String menuName = "Luaran Mahasiswa"; // Sesuaikan
  String subMenuName = "Sitasi"; // Bisa diisi sesuai
  String endPoint = ""; // Endpoint API
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
      userId = int.tryParse(prefs.getString('id') ?? '0') ?? 0;
    });
  }

  Future<void> _fetchData() async {
    try {
      final data = await apiService.getData(
          LuaranPenelitianLainAioModel.fromJson, endPoint);
      setState(() {
        dataList = data.cast<sitasimahasiswa>();
      });
    } catch (e) {
      print("Error fetching data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data: ${e.toString()}')),
      );
    }
  }

  Future<void> _addData(Map<String, dynamic> newData) async {
    try {
      await apiService.postData(LuaranPenelitianLainAioModel.fromJson, newData, endPoint);
      _fetchData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil ditambahkan!')),
      );
    } catch (e) {
      print("Error adding data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambah data: ${e.toString()}')),
      );
    }
  }

  Future<void> _deleteData(int id) async {
    try {
      await apiService.deleteData(id, endPoint);
      _fetchData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil dihapus!')),
      );
    } catch (e) {
      print("Error deleting data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data: ${e.toString()}')),
      );
    }
  }

  Future<void> _editData(int id, Map<String, dynamic> updatedData) async {
    try {
      await apiService.updateData(LuaranPenelitianLainAioModel.fromJson, id, updatedData, endPoint);
      _fetchData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil diupdate!')),
      );
    } catch (e) {
      print("Error editing data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengupdate data: ${e.toString()}')),
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              menuName,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                // Jika ingin tambahkan search, bisa di sini
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
                          // Implementasi search jika perlu
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Tabel $menuName $subMenuName",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          // Header table
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _headerCell("No", 50),
                                _headerCell("Nama Mahasiswa", 150),
                                _headerCell("Judul Artikel", 200),
                                _headerCell("Jumlah Sitasi", 120),
                                _headerCell("Tahun", 80),
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),
                          // Data table
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50),
                              1: FixedColumnWidth(150),
                              2: FixedColumnWidth(200),
                              3: FixedColumnWidth(120),
                              4: FixedColumnWidth(80),
                              5: FixedColumnWidth(50),
                            },
                            children: dataList.asMap().entries.map((entry) {
                              int index = entry.key;
                              final data = entry.value;
                              return TableRow(
                                children: [
                                  // Nomor
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text((index + 1).toString())),
                                    ),
                                  ),
                                  // Nama Mahasiswa
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(data.namaMahasiswa),
                                    ),
                                  ),
                                  // Judul Artikel
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(data.judulArtikel),
                                    ),
                                  ),
                                  // Jumlah Sitasi
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(data.jumlahSitasi.toString()),
                                    ),
                                  ),
                                  // Tahun
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(data.tahun),
                                    ),
                                  ),
                                  // Aksi
                                  TableCell(
                                    child: Center(
                                      child: PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert, color: Colors.black87),
                                        onSelected: (choice) {
                                          if (choice == "Edit") {
                                            _showEditDialog(data.id, {
                                              'nama_mahasiswa': data.namaMahasiswa,
                                              'judul_artikel': data.judulArtikel,
                                              'jumlah_sitasi': data.jumlahSitasi,
                                              'tahun': data.tahun,
                                            });
                                          } else if (choice == "Hapus") {
                                            _deleteData(data.id);
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: "Edit",
                                            child: ListTile(
                                              leading: Icon(Icons.edit, color: Colors.blue),
                                              title: Text("Edit"),
                                            ),
                                          ),
                                          const PopupMenuItem(
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
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          // FloatingButton
          Positioned(
            bottom: 24,
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
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Dialog Tambah Data
  void _showAddDialog() {
    final TextEditingController namaMahasiswaController = TextEditingController();
    final TextEditingController judulArtikelController = TextEditingController();
    final TextEditingController jumlahSitasiController = TextEditingController();
    final TextEditingController tahunController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data Luaran Penelitian'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaMahasiswaController,
                  decoration: const InputDecoration(labelText: 'Nama Mahasiswa'),
                ),
                TextField(
                  controller: judulArtikelController,
                  decoration: const InputDecoration(labelText: 'Judul Artikel'),
                ),
                TextField(
                  controller: jumlahSitasiController,
                  decoration: const InputDecoration(labelText: 'Jumlah Sitasi'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: tahunController,
                  decoration: const InputDecoration(labelText: 'Tahun'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Validasi input
                if (namaMahasiswaController.text.isEmpty ||
                    judulArtikelController.text.isEmpty ||
                    jumlahSitasiController.text.isEmpty ||
                    tahunController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua field harus diisi')),
                  );
                  return;
                }
                _addData({
                  'user_id': userId,
                  'nama_mahasiswa': namaMahasiswaController.text,
                  'judul_artikel': judulArtikelController.text,
                  'jumlah_sitasi': int.tryParse(jumlahSitasiController.text) ?? 0,
                  'tahun': tahunController.text,
                });
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(int id, Map<String, dynamic> currentData) {
    final TextEditingController namaMahasiswaController =
        TextEditingController(text: currentData['nama_mahasiswa'] ?? '');
    final TextEditingController judulArtikelController =
        TextEditingController(text: currentData['judul_artikel'] ?? '');
    final TextEditingController jumlahSitasiController =
        TextEditingController(text: currentData['jumlah_sitasi']?.toString() ?? '');
    final TextEditingController tahunController =
        TextEditingController(text: currentData['tahun'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Luaran Penelitian'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaMahasiswaController,
                  decoration: const InputDecoration(labelText: 'Nama Mahasiswa'),
                ),
                TextField(
                  controller: judulArtikelController,
                  decoration: const InputDecoration(labelText: 'Judul Artikel'),
                ),
                TextField(
                  controller: jumlahSitasiController,
                  decoration: const InputDecoration(labelText: 'Jumlah Sitasi'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: tahunController,
                  decoration: const InputDecoration(labelText: 'Tahun'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Validasi input
                if (namaMahasiswaController.text.isEmpty ||
                    judulArtikelController.text.isEmpty ||
                    jumlahSitasiController.text.isEmpty ||
                    tahunController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua field harus diisi')),
                  );
                  return;
                }
                _editData(id, {
                  'nama_mahasiswa': namaMahasiswaController.text,
                  'judul_artikel': judulArtikelController.text,
                  'jumlah_sitasi': int.tryParse(jumlahSitasiController.text) ?? 0,
                  'tahun': tahunController.text,
                });
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}