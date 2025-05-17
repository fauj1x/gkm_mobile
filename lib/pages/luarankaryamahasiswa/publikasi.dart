import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gkm_mobile/models/luaranmhs_publikasi.dart'; // Pastikan path ini sesuai
import 'package:gkm_mobile/services/api_services.dart';

class PublikasiMahasiswaScreen extends StatefulWidget {
  final dynamic tahunAjaran; // Sesuaikan tipe sesuai
  const PublikasiMahasiswaScreen({Key? key, required this.tahunAjaran}) : super(key: key);

  @override
  _PublikasiMahasiswaScreenState createState() => _PublikasiMahasiswaScreenState();
}

class _PublikasiMahasiswaScreenState extends State<PublikasiMahasiswaScreen> {
  List<PublikasiMahasiswa> dataList = [];
  ApiService apiService = ApiService();

  String menuName = "Publikasi Mahasiswa";
  String subMenuName = "";
  String endPoint = "publikasi-mahasiswa";
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
      final data = await apiService.getData(PublikasiMahasiswa.fromJson, endPoint);
      setState(() {
        dataList = data;
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
      await apiService.postData(PublikasiMahasiswa.fromJson, newData, endPoint);
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
      await apiService.updateData(PublikasiMahasiswa.fromJson, id, updatedData, endPoint);
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
      appBar: AppBar(
        title: Text(menuName),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Isi tabel dan tampilan
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Tabel Header
                Container(
                  color: Colors.teal,
                  child: Row(
                    children: [
                      _headerCell("No", 50),
                      _headerCell("Nama Mahasiswa", 150),
                      _headerCell("Judul Artikel", 200),
                      _headerCell("Jenis Artikel", 120),
                      _headerCell("Tahun", 80),
                      _headerCell("Aksi", 50),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: Table(
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
                              _buildCell((index + 1).toString()),
                              _buildCell(data.namaMahasiswa),
                              _buildCell(data.judulArtikel),
                              _buildCell(data.jenisArtikel),
                              _buildCell(data.tahun),
                              _buildActionsCell(data.id),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Floating Button
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton.extended(
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Tambah Data"),
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
      color: Colors.teal,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text),
    );
  }

  Widget _buildActionsCell(int id) {
    return Center(
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, color: Colors.black87),
        onSelected: (choice) {
          if (choice == "Edit") {
            // Cari data berdasarkan id
            final data = dataList.firstWhere((element) => element.id == id);
            _showEditDialog(id, {
              'nama_mahasiswa': data.namaMahasiswa,
              'judul_artikel': data.judulArtikel,
              'jenis_artikel': data.jenisArtikel,
              'tahun': data.tahun,
            });
          } else if (choice == "Hapus") {
            _deleteData(id);
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
    );
  }

  void _showAddDialog() {
    final TextEditingController namaController = TextEditingController();
    final TextEditingController judulController = TextEditingController();
    final TextEditingController jenisController = TextEditingController();
    final TextEditingController tahunController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tambah Publikasi Mahasiswa'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: namaController, decoration: const InputDecoration(labelText: 'Nama Mahasiswa')),
              TextField(controller: judulController, decoration: const InputDecoration(labelText: 'Judul Artikel')),
              TextField(controller: jenisController, decoration: const InputDecoration(labelText: 'Jenis Artikel')),
              TextField(controller: tahunController, decoration: const InputDecoration(labelText: 'Tahun')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              if (namaController.text.isEmpty || judulController.text.isEmpty || jenisController.text.isEmpty || tahunController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua field harus diisi')));
                return;
              }
              _addData({
                'user_id': userId,
                'nama_mahasiswa': namaController.text,
                'judul_artikel': judulController.text,
                'jenis_artikel': jenisController.text,
                'tahun': tahunController.text,
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(int id, Map<String, dynamic> currentData) {
    final TextEditingController namaController = TextEditingController(text: currentData['nama_mahasiswa']);
    final TextEditingController judulController = TextEditingController(text: currentData['judul_artikel']);
    final TextEditingController jenisController = TextEditingController(text: currentData['jenis_artikel']);
    final TextEditingController tahunController = TextEditingController(text: currentData['tahun']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Publikasi Mahasiswa'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: namaController, decoration: const InputDecoration(labelText: 'Nama Mahasiswa')),
              TextField(controller: judulController, decoration: const InputDecoration(labelText: 'Judul Artikel')),
              TextField(controller: jenisController, decoration: const InputDecoration(labelText: 'Jenis Artikel')),
              TextField(controller: tahunController, decoration: const InputDecoration(labelText: 'Tahun')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              if (namaController.text.isEmpty || judulController.text.isEmpty || jenisController.text.isEmpty || tahunController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua field harus diisi')));
                return;
              }
              _editData(id, {
                'nama_mahasiswa': namaController.text,
                'judul_artikel': judulController.text,
                'jenis_artikel': jenisController.text,
                'tahun': tahunController.text,
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}