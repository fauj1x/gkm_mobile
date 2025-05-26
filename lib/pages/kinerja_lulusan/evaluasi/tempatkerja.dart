import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/kinerjalulusan_tempatkerja.dart'; // Your TempatKerjaModel
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TempatKerjaScreen extends StatefulWidget {
  const TempatKerjaScreen({Key? key, required TahunAjaran tahunAjaran}) : super(key: key);

  @override
  TempatKerjaState createState() => TempatKerjaState();
}

class TempatKerjaState extends State<TempatKerjaScreen> {
  List<TempatKerjaModel> dataList = [];
  final ApiService apiService = ApiService();
  final String menuName = "Data Tempat Kerja";
  final String subMenuName = "";
  final String endPoint = "tempat-kerja";
  int userId = 0;

  final TextEditingController _searchController = TextEditingController();
  List<TempatKerjaModel> filteredDataList = [];

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _fetchData();
    _searchController.addListener(_filterData);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = int.tryParse(prefs.getString('id') ?? '0') ?? 0;
    });
  }

  Future<void> _fetchData() async {
    try {
      final data = await apiService.getData(TempatKerjaModel.fromJson, endPoint);
      setState(() {
        dataList = data;
        _filterData();
      });
    } catch (e) {
      print("Error fetching data: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data: $e')),
        );
      }
    }
  }

  void _filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredDataList = dataList.where((data) {
        return data.tahun.toLowerCase().contains(query) ||
            data.jumlahLulusan.toString().contains(query) ||
            data.jumlahLulusanTerlacak.toString().contains(query) ||
            data.jumlahLulusanBekerjaLokal.toString().contains(query) ||
            data.jumlahLulusanBekerjaNasional.toString().contains(query) ||
            data.jumlahLulusanBekerjaInternasional.toString().contains(query);
      }).toList();
    });
  }

  Future<void> _addData(Map<String, dynamic> newData) async {
    try {
      await apiService.postData(TempatKerjaModel.fromJson, newData, endPoint);
      await _fetchData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil ditambahkan!')),
        );
      }
    } catch (e) {
      print("Error adding data: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan data: $e')),
        );
      }
    }
  }

  Future<void> _deleteData(int? id) async {
    if (id == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat menghapus data: ID tidak ditemukan.')),
        );
      }
      return;
    }
    try {
      await apiService.deleteData(id, endPoint);
      await _fetchData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil dihapus!')),
        );
      }
    } catch (e) {
      print("Error deleting data: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus data: $e')),
        );
      }
    }
  }

  Future<void> _editData(int? id, Map<String, dynamic> updatedData) async {
    if (id == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat mengedit data: ID tidak ditemukan.')),
        );
      }
      return;
    }
    try {
      await apiService.updateData(TempatKerjaModel.fromJson, id, updatedData, endPoint);
      await _fetchData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diupdate!')),
        );
      }
    } catch (e) {
      print("Error editing data: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengedit data: $e')),
        );
      }
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
                          controller: _searchController,
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
                          // Header Tabel
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _HeaderCell("No.", 50),
                                _HeaderCell("Tahun", 100),
                                _HeaderCell("Jumlah Lulusan", 120),
                                _HeaderCell("Lulusan Terlacak", 120),
                                _HeaderCell("Bekerja Lokal", 120),
                                _HeaderCell("Bekerja Nasional", 120),
                                _HeaderCell("Bekerja Internasional", 150),
                                _HeaderCell("Aksi", 80),
                              ],
                            ),
                          ),

                          // Isi Data Tabel
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50),
                              1: FixedColumnWidth(100),
                              2: FixedColumnWidth(120),
                              3: FixedColumnWidth(120),
                              4: FixedColumnWidth(120),
                              5: FixedColumnWidth(120),
                              6: FixedColumnWidth(150),
                              7: FixedColumnWidth(80),
                            },
                            children: filteredDataList.asMap().entries.map((entry) {
                              final data = entry.value;
                              return TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text((entry.key + 1).toString())),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.tahun)),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahLulusan.toString())),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahLulusanTerlacak.toString())),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahLulusanBekerjaLokal.toString())),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahLulusanBekerjaNasional.toString())),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahLulusanBekerjaInternasional.toString())),
                                    ),
                                  ),
                                  // Aksi Button
                                  TableCell(
                                    child: Center(
                                      child: PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert, color: Colors.black87),
                                        onSelected: (String choice) {
                                          if (choice == "Edit") {
                                            _showEditDialog(data.id, data);
                                          } else if (choice == "Hapus") {
                                            _deleteData(data.id);
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<String>>[
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

  static Widget _HeaderCell(String text, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showAddDialog() {
    final TextEditingController tahunController = TextEditingController();
    final TextEditingController jumlahLulusanController = TextEditingController();
    final TextEditingController jumlahLulusanTerlacakController = TextEditingController();
    final TextEditingController jumlahLulusanBekerjaLokalController = TextEditingController();
    final TextEditingController jumlahLulusanBekerjaNasionalController = TextEditingController();
    final TextEditingController jumlahLulusanBekerjaInternasionalController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data Alumni Tracking'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tahunController,
                  decoration: const InputDecoration(labelText: 'Tahun'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanTerlacakController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan Terlacak'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanBekerjaLokalController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan Bekerja Lokal'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanBekerjaNasionalController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan Bekerja Nasional'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanBekerjaInternasionalController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan Bekerja Internasional'),
                  keyboardType: TextInputType.number,
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
                if (tahunController.text.isEmpty ||
                    jumlahLulusanController.text.isEmpty ||
                    jumlahLulusanTerlacakController.text.isEmpty ||
                    jumlahLulusanBekerjaLokalController.text.isEmpty ||
                    jumlahLulusanBekerjaNasionalController.text.isEmpty ||
                    jumlahLulusanBekerjaInternasionalController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua bidang harus diisi')),
                  );
                  return;
                }

                _addData({
                  'user_id': userId,
                  'tahun': tahunController.text,
                  'jumlah_lulusan': int.tryParse(jumlahLulusanController.text) ?? 0,
                  'jumlah_lulusan_terlacak': int.tryParse(jumlahLulusanTerlacakController.text) ?? 0,
                  'jumlah_lulusan_bekerja_lokal': int.tryParse(jumlahLulusanBekerjaLokalController.text) ?? 0,
                  'jumlah_lulusan_bekerja_nasional': int.tryParse(jumlahLulusanBekerjaNasionalController.text) ?? 0,
                  'jumlah_lulusan_bekerja_internasional': int.tryParse(jumlahLulusanBekerjaInternasionalController.text) ?? 0,
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

  void _showEditDialog(int? id, TempatKerjaModel currentData) {
    final TextEditingController tahunController = TextEditingController(text: currentData.tahun);
    final TextEditingController jumlahLulusanController = TextEditingController(text: currentData.jumlahLulusan.toString());
    final TextEditingController jumlahLulusanTerlacakController = TextEditingController(text: currentData.jumlahLulusanTerlacak.toString());
    final TextEditingController jumlahLulusanBekerjaLokalController = TextEditingController(text: currentData.jumlahLulusanBekerjaLokal.toString());
    final TextEditingController jumlahLulusanBekerjaNasionalController = TextEditingController(text: currentData.jumlahLulusanBekerjaNasional.toString());
    final TextEditingController jumlahLulusanBekerjaInternasionalController = TextEditingController(text: currentData.jumlahLulusanBekerjaInternasional.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Alumni Tracking'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tahunController,
                  decoration: const InputDecoration(labelText: 'Tahun'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanTerlacakController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan Terlacak'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanBekerjaLokalController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan Bekerja Lokal'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanBekerjaNasionalController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan Bekerja Nasional'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanBekerjaInternasionalController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan Bekerja Internasional'),
                  keyboardType: TextInputType.number,
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
                if (tahunController.text.isEmpty ||
                    jumlahLulusanController.text.isEmpty ||
                    jumlahLulusanTerlacakController.text.isEmpty ||
                    jumlahLulusanBekerjaLokalController.text.isEmpty ||
                    jumlahLulusanBekerjaNasionalController.text.isEmpty ||
                    jumlahLulusanBekerjaInternasionalController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua bidang harus diisi')),
                  );
                  return;
                }

                _editData(id, {
                  'id': id,
                  'user_id': userId,
                  'tahun': tahunController.text,
                  'jumlah_lulusan': int.tryParse(jumlahLulusanController.text) ?? 0,
                  'jumlah_lulusan_terlacak': int.tryParse(jumlahLulusanTerlacakController.text) ?? 0,
                  'jumlah_lulusan_bekerja_lokal': int.tryParse(jumlahLulusanBekerjaLokalController.text) ?? 0,
                  'jumlah_lulusan_bekerja_nasional': int.tryParse(jumlahLulusanBekerjaNasionalController.text) ?? 0,
                  'jumlah_lulusan_bekerja_internasional': int.tryParse(jumlahLulusanBekerjaInternasionalController.text) ?? 0,
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