import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gkm_mobile/models/luaranmhs_hkihakmhs.dart'; // Pastikan path sesuai
import 'package:gkm_mobile/services/api_services.dart';

class HkiHakCiptaMhsScreen extends StatefulWidget {
  final dynamic tahunAjaran; // Sesuaikan tipe data
  const HkiHakCiptaMhsScreen({Key? key, required this.tahunAjaran}) : super(key: key);

  @override
  _HkiHakCiptaMhsScreenState createState() => _HkiHakCiptaMhsScreenState();
}

class _HkiHakCiptaMhsScreenState extends State<HkiHakCiptaMhsScreen> {
  List<HkiHakCiptaMhs> dataList = [];
  ApiService apiService = ApiService();

  String menuName = "Hak Cipta Mahasiswa";
  String subMenuName = "";
  String endPoint = "hki-hak-cipta-mhs";
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
      final data = await apiService.getData(HkiHakCiptaMhs.fromJson, endPoint);
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
      await apiService.postData(HkiHakCiptaMhs.fromJson, newData, endPoint);
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
      await apiService.updateData(HkiHakCiptaMhs.fromJson, id, updatedData, endPoint);
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header tabel
                Container(
                  color: Colors.teal,
                  child: Row(
                    children: [
                      _headerCell("No", 50),
                      _headerCell("Luaran Penelitian", 150),
                      _headerCell("Tahun", 80),
                      _headerCell("Keterangan", 200),
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
                          2: FixedColumnWidth(150),
                          3: FixedColumnWidth(80),
                          4: FixedColumnWidth(200),
                          5: FixedColumnWidth(50),
                        },
                        children: dataList.asMap().entries.map((entry) {
                          int index = entry.key;
                          final data = entry.value;
                          return TableRow(
                            children: [
                              _buildCell((index + 1).toString()),
                              _buildCell(data.luaranPenelitian),
                              _buildCell(data.tahun),
                              _buildCell(data.keterangan),
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
          // Floating button
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
            final data = dataList.firstWhere((element) => element.id == id);
            _showEditDialog(id, {
              'luaran_penelitian': data.luaranPenelitian,
              'tahun': data.tahun,
              'keterangan': data.keterangan,
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
    final TextEditingController luaranPenelitianController = TextEditingController();
    final TextEditingController tahunController = TextEditingController();
    final TextEditingController keteranganController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tambah Hak Cipta Mahasiswa'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: luaranPenelitianController, decoration: const InputDecoration(labelText: 'Luaran Penelitian')),
              TextField(controller: tahunController, decoration: const InputDecoration(labelText: 'Tahun')),
              TextField(controller: keteranganController, decoration: const InputDecoration(labelText: 'Keterangan')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              if (
                  luaranPenelitianController.text.isEmpty ||
                  tahunController.text.isEmpty ||
                  keteranganController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua field harus diisi')));
                return;
              }
              _addData({
                'user_id': userId,
                'luaran_penelitian': luaranPenelitianController.text,
                'tahun': tahunController.text,
                'keterangan': keteranganController.text,
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
    final TextEditingController luaranPenelitianController = TextEditingController(text: currentData['luaran_penelitian']);
    final TextEditingController tahunController = TextEditingController(text: currentData['tahun']);
    final TextEditingController keteranganController = TextEditingController(text: currentData['keterangan']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Hak Cipta Mahasiswa'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: luaranPenelitianController, decoration: const InputDecoration(labelText: 'Luaran Penelitian')),
              TextField(controller: tahunController, decoration: const InputDecoration(labelText: 'Tahun')),
              TextField(controller: keteranganController, decoration: const InputDecoration(labelText: 'Keterangan')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              if (
                  luaranPenelitianController.text.isEmpty ||
                  tahunController.text.isEmpty ||
                  keteranganController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua field harus diisi')));
                return;
              }
              _editData(id, {
                'luaran_penelitian': luaranPenelitianController.text,
                'tahun': tahunController.text,
                'keterangan': keteranganController.text,
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