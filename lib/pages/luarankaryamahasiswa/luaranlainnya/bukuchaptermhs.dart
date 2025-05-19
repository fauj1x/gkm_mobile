import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gkm_mobile/models/luaranmhs_bukuchptrmhs.dart';// Pastikan path sesuai
import 'package:gkm_mobile/services/api_services.dart';

class BukuChapterMhsScreen extends StatefulWidget {
  final dynamic tahunAjaran; // Jika diperlukan
  const BukuChapterMhsScreen({Key? key, this.tahunAjaran}) : super(key: key);

  @override
  _BukuChapterMhsScreenState createState() => _BukuChapterMhsScreenState();
}

class _BukuChapterMhsScreenState extends State<BukuChapterMhsScreen> {
  List<BukuChapterMhs> dataList = [];
  ApiService apiService = ApiService();

  String menuName = "Buku Chapter Mahasiswa";
  String endPoint = "buku-chapter-mhs"; // Sesuaikan endpoint API kamu
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
      final data = await apiService.getData(BukuChapterMhs.fromJson, endPoint);
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
      await apiService.postData(BukuChapterMhs.fromJson, newData, endPoint);
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
      await apiService.updateData(BukuChapterMhs.fromJson, id, updatedData, endPoint);
      _fetchData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil diupdate!')),
      );
    } catch (e) {
      print("Error updating data: $e");
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
                      _headerCell("Judul Buku", 200),
                      _headerCell("Tahun", 80),
                      _headerCell("Keterangan", 200),
                      _headerCell("Aksi", 50),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final data = dataList[index];
                      return TableRowWidget(
                        index: index,
                        data: data,
                        onEdit: () => _showEditDialog(data),
                        onDelete: () => _deleteData(data.id),
                      );
                    },
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

  void _showAddDialog() {
    final TextEditingController judulController = TextEditingController();
    final TextEditingController tahunController = TextEditingController();
    final TextEditingController keteranganController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tambah Buku Chapter Mahasiswa'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: judulController, decoration: const InputDecoration(labelText: 'Judul Buku')),
              TextField(controller: tahunController, decoration: const InputDecoration(labelText: 'Tahun')),
              TextField(controller: keteranganController, decoration: const InputDecoration(labelText: 'Keterangan')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              if (judulController.text.isEmpty || tahunController.text.isEmpty || keteranganController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua field harus diisi')));
                return;
              }
              _addData({
                'user_id': userId,
                'luaran_penelitian': judulController.text,
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

  void _showEditDialog(BukuChapterMhs data) {
    final TextEditingController judulController = TextEditingController(text: data.luaranPenelitian);
    final TextEditingController tahunController = TextEditingController(text: data.tahun);
    final TextEditingController keteranganController = TextEditingController(text: data.keterangan);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Buku Chapter Mahasiswa'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: judulController, decoration: const InputDecoration(labelText: 'Judul Buku')),
              TextField(controller: tahunController, decoration: const InputDecoration(labelText: 'Tahun')),
              TextField(controller: keteranganController, decoration: const InputDecoration(labelText: 'Keterangan')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              if (judulController.text.isEmpty || tahunController.text.isEmpty || keteranganController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua field harus diisi')));
                return;
              }
              _editData(data.id, {
                'luaran_penelitian': judulController.text,
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

// Widget untuk menampilkan baris data
class TableRowWidget extends StatelessWidget {
  final int index;
  final BukuChapterMhs data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TableRowWidget({
    Key? key,
    required this.index,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _cell((index + 1).toString(), 50),
        _cell(data.luaranPenelitian, 200),
        _cell(data.tahun, 80),
        _cell(data.keterangan, 200),
        _actionsCell(onEdit, onDelete),
      ],
    );
  }

  Widget _cell(String text, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8.0),
      child: Text(text),
    );
  }

  Widget _actionsCell(VoidCallback onEdit, VoidCallback onDelete) {
    return Container(
      width: 50,
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        onSelected: (choice) {
          if (choice == 'edit') {
            onEdit();
          } else if (choice == 'delete') {
            onDelete();
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Edit'),
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Hapus'),
            ),
          ),
        ],
      ),
    );
  }
}