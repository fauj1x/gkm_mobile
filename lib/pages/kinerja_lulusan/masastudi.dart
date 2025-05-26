import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/kinerjalulusan_masastudi.dart'; // Sesuaikan path ini jika perlu
import 'package:gkm_mobile/models/tahun_ajaran.dart'; // Jika masih relevan, pertahankan
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MasaStudiLulusan extends StatefulWidget {
  final TahunAjaran? tahunAjaran; // Dapat dihapus jika tidak digunakan
  const MasaStudiLulusan({Key? key, this.tahunAjaran}) : super(key: key);

  @override
  MasaStudiLulusanState createState() => MasaStudiLulusanState();
}

class MasaStudiLulusanState extends State<MasaStudiLulusan> {
  List<MasaStudiLulusanModel> dataList = [];
  ApiService apiService = ApiService();
  String menuName = "Data Masa Studi Lulusan";
  String subMenuName = ""; // Biarkan kosong jika tidak ada sub-menu
  String endPoint = "masa-studi-lulusan"; // Endpoint API untuk Masa Studi Lulusan
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
    });
  }

  Future<void> _fetchData() async {
    try {
      final data = await apiService.getData(MasaStudiLulusanModel.fromJson, endPoint);
      setState(() {
        dataList = data;
      });
    } catch (e) {
      print("Error fetching data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data: $e')),
      );
    }
  }

  Future<void> _addData(Map<String, dynamic> newData) async {
    try {
      await apiService.postData(MasaStudiLulusanModel.fromJson, newData, endPoint);
      _fetchData(); // Refresh data setelah menambahkan
    } catch (e) {
      print("Error adding data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan data: $e')),
      );
    }
  }

  Future<void> _deleteData(int id) async {
    try {
      await apiService.deleteData(id, endPoint);
      _fetchData(); // Refresh data setelah menghapus
    } catch (e) {
      print("Error deleting data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data: $e')),
      );
    }
  }

  Future<void> _editData(int id, Map<String, dynamic> updatedData) async {
    try {
      await apiService.updateData(MasaStudiLulusanModel.fromJson, id, updatedData, endPoint);
      _fetchData(); // Refresh data setelah mengedit
    } catch (e) {
      print("Error editing data: $e");
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
                                _headerCell("No.", 50),
                                _headerCell("Tahun", 100),
                                _headerCell("Masa Studi", 120), // New header
                                _headerCell("Mhs Diterima", 120), // New header
                                _headerCell("Lulus TS", 100), // New header
                                _headerCell("Lulus TS-1", 100), // New header
                                _headerCell("Lulus TS-2", 100), // New header
                                _headerCell("Lulus TS-3", 100), // New header
                                _headerCell("Lulus TS-4", 100), // New header
                                _headerCell("Lulus TS-5", 100), // New header
                                _headerCell("Lulus TS-6", 100), // New header
                                _headerCell("Jumlah Lulusan", 120),
                                _headerCell("Mean Masa Studi", 150), // New header
                                _headerCell("Aksi", 80),
                              ],
                            ),
                          ),

                          // Isi Data Tabel
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50),
                              1: FixedColumnWidth(100),
                              2: FixedColumnWidth(120), // Masa Studi
                              3: FixedColumnWidth(120), // Mhs Diterima
                              4: FixedColumnWidth(100), // Lulus TS
                              5: FixedColumnWidth(100), // Lulus TS-1
                              6: FixedColumnWidth(100), // Lulus TS-2
                              7: FixedColumnWidth(100), // Lulus TS-3
                              8: FixedColumnWidth(100), // Lulus TS-4
                              9: FixedColumnWidth(100), // Lulus TS-5
                              10: FixedColumnWidth(100), // Lulus TS-6
                              11: FixedColumnWidth(120), // Jumlah Lulusan
                              12: FixedColumnWidth(150), // Mean Masa Studi
                              13: FixedColumnWidth(80), // Aksi
                            },
                            children: dataList.asMap().entries.map((entry) {
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
                                      child: Center(child: Text(data.masaStudi ?? '-')), // Display masaStudi
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahMhsDiterima.toString())), // Display jumlahMhsDiterima
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahMhsLulusAkhirTs.toString())), // Display jumlahMhsLulusAkhirTs
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahMhsLulusAkhirTs1.toString())), // Display jumlahMhsLulusAkhirTs1
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahMhsLulusAkhirTs2.toString())), // Display jumlahMhsLulusAkhirTs2
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahMhsLulusAkhirTs3.toString())), // Display jumlahMhsLulusAkhirTs3
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahMhsLulusAkhirTs4.toString())), // Display jumlahMhsLulusAkhirTs4
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahMhsLulusAkhirTs5.toString())), // Display jumlahMhsLulusAkhirTs5
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahMhsLulusAkhirTs6.toString())), // Display jumlahMhsLulusAkhirTs6
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
                                      child: Center(child: Text(data.meanMasaStudi.toStringAsFixed(2))), // Display meanMasaStudi
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

  Widget _headerCell(String text, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54), // Menambahkan border
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
    final TextEditingController masaStudiController = TextEditingController();
    final TextEditingController jumlahMhsDiterimaController = TextEditingController();
    final TextEditingController jumlahMhsLulusAkhirTsController = TextEditingController();
    final TextEditingController jumlahMhsLulusAkhirTs1Controller = TextEditingController();
    final TextEditingController jumlahMhsLulusAkhirTs2Controller = TextEditingController();
    final TextEditingController jumlahMhsLulusAkhirTs3Controller = TextEditingController();
    final TextEditingController jumlahMhsLulusAkhirTs4Controller = TextEditingController();
    final TextEditingController jumlahMhsLulusAkhirTs5Controller = TextEditingController();
    final TextEditingController jumlahMhsLulusAkhirTs6Controller = TextEditingController();
    final TextEditingController jumlahLulusanController = TextEditingController();
    final TextEditingController meanMasaStudiController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data Masa Studi Lulusan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tahunController,
                  decoration: const InputDecoration(labelText: 'Tahun'),
                  keyboardType: TextInputType.text, // Changed to text
                ),
                TextField(
                  controller: masaStudiController,
                  decoration: const InputDecoration(labelText: 'Masa Studi'),
                  keyboardType: TextInputType.text, // Can be text or number based on input type
                ),
                TextField(
                  controller: jumlahMhsDiterimaController,
                  decoration: const InputDecoration(labelText: 'Jumlah Mahasiswa Diterima'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahMhsLulusAkhirTsController,
                  decoration: const InputDecoration(labelText: 'Jumlah Mahasiswa Lulus Akhir TS'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahMhsLulusAkhirTs1Controller,
                  decoration: const InputDecoration(labelText: 'Jumlah Mahasiswa Lulus Akhir TS-1'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahMhsLulusAkhirTs2Controller,
                  decoration: const InputDecoration(labelText: 'Jumlah Mahasiswa Lulus Akhir TS-2'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahMhsLulusAkhirTs3Controller,
                  decoration: const InputDecoration(labelText: 'Jumlah Mahasiswa Lulus Akhir TS-3'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahMhsLulusAkhirTs4Controller,
                  decoration: const InputDecoration(labelText: 'Jumlah Mahasiswa Lulus Akhir TS-4'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahMhsLulusAkhirTs5Controller,
                  decoration: const InputDecoration(labelText: 'Jumlah Mahasiswa Lulus Akhir TS-5'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahMhsLulusAkhirTs6Controller,
                  decoration: const InputDecoration(labelText: 'Jumlah Mahasiswa Lulus Akhir TS-6'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: meanMasaStudiController,
                  decoration: const InputDecoration(labelText: 'Mean Masa Studi'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                if (tahunController.text.isEmpty ||
                    jumlahMhsDiterimaController.text.isEmpty ||
                    jumlahMhsLulusAkhirTsController.text.isEmpty ||
                    jumlahMhsLulusAkhirTs1Controller.text.isEmpty ||
                    jumlahMhsLulusAkhirTs2Controller.text.isEmpty ||
                    jumlahMhsLulusAkhirTs3Controller.text.isEmpty ||
                    jumlahMhsLulusAkhirTs4Controller.text.isEmpty ||
                    jumlahMhsLulusAkhirTs5Controller.text.isEmpty ||
                    jumlahMhsLulusAkhirTs6Controller.text.isEmpty ||
                    jumlahLulusanController.text.isEmpty ||
                    meanMasaStudiController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua bidang harus diisi')),
                  );
                  return;
                }

                _addData({
                  'user_id': userId,
                  'tahun': tahunController.text,
                  'masa_studi': masaStudiController.text.isNotEmpty ? masaStudiController.text : null, // Send null if empty
                  'jumlah_mhs_diterima': int.tryParse(jumlahMhsDiterimaController.text) ?? 0,
                  'jumlah_mhs_lulus_akhir_ts': int.tryParse(jumlahMhsLulusAkhirTsController.text) ?? 0,
                  'jumlah_mhs_lulus_akhir_ts_1': int.tryParse(jumlahMhsLulusAkhirTs1Controller.text) ?? 0,
                  'jumlah_mhs_lulus_akhir_ts_2': int.tryParse(jumlahMhsLulusAkhirTs2Controller.text) ?? 0,
                  'jumlah_mhs_lulus_akhir_ts_3': int.tryParse(jumlahMhsLulusAkhirTs3Controller.text) ?? 0,
                  'jumlah_mhs_lulus_akhir_ts_4': int.tryParse(jumlahMhsLulusAkhirTs4Controller.text) ?? 0,
                  'jumlah_mhs_lulus_akhir_ts_5': int.tryParse(jumlahMhsLulusAkhirTs5Controller.text) ?? 0,
                  'jumlah_mhs_lulus_akhir_ts_6': int.tryParse(jumlahMhsLulusAkhirTs6Controller.text) ?? 0,
                  'jumlah_lulusan': int.tryParse(jumlahLulusanController.text) ?? 0,
                  'mean_masa_studi': double.tryParse(meanMasaStudiController.text) ?? 0.0,
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

  void _showEditDialog(int id, MasaStudiLulusanModel currentData) {
    final TextEditingController tahunController = TextEditingController(text: currentData.tahun);
    final TextEditingController masaStudiController = TextEditingController(text: currentData.masaStudi);
    final TextEditingController jumlahMhsDiterimaController = TextEditingController(text: currentData.jumlahMhsDiterima.toString());
    final TextEditingController jumlahMhsLulusAkhirTsController = TextEditingController(text: currentData.jumlahMhsLulusAkhirTs.toString());
    final TextEditingController jumlahMhsLulusAkhirTs1Controller = TextEditingController(text: currentData.jumlahMhsLulusAkhirTs1.toString());
    final TextEditingController jumlahMhsLulusAkhirTs2Controller = TextEditingController(text: currentData.jumlahMhsLulusAkhirTs2.toString());
    final TextEditingController jumlahMhsLulusAkhirTs3Controller = TextEditingController(text: currentData.jumlahMhsLulusAkhirTs3.toString());
    final TextEditingController jumlahMhsLulusAkhirTs4Controller = TextEditingController(text: currentData.jumlahMhsLulusAkhirTs4.toString());
    final TextEditingController jumlahMhsLulusAkhirTs5Controller = TextEditingController(text: currentData.jumlahMhsLulusAkhirTs5.toString());
    final TextEditingController jumlahMhsLulusAkhirTs6Controller = TextEditingController(text: currentData.jumlahMhsLulusAkhirTs6.toString());
    final TextEditingController jumlahLulusanController = TextEditingController(text: currentData.jumlahLulusan.toString());
    final TextEditingController meanMasaStudiController = TextEditingController(text: currentData.meanMasaStudi.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Masa Studi Lulusan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tahunController,
                  decoration: const InputDecoration(labelText: 'Tahun'),
                  keyboardType: TextInputType.text, // Changed to text
                ),
                TextField(
                  controller: masaStudiController,
                  decoration: const InputDecoration(labelText: 'Masa Studi'),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: jumlahMhsDiterimaController,
                  decoration: const InputDecoration(labelText: 'Jumlah Mahasiswa Diterima'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahMhsLulusAkhirTsController,
                  decoration: const InputDecoration(labelText: 'Jumlah Mahasiswa Lulus Akhir TS'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahMhsLulusAkhirTs1Controller,
                  decoration: const InputDecoration(labelText: 'Jumlah Mahasiswa Lulus Akhir TS-1'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahMhsLulusAkhirTs2Controller,
                  decoration: const InputDecoration(labelText: 'Jumlah Mahasiswa Lulus Akhir TS-2'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahMhsLulusAkhirTs3Controller,
                  decoration: const InputDecoration(labelText: 'Jumlah Mahasiswa Lulus Akhir TS-3'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahMhsLulusAkhirTs4Controller,
                  decoration: const InputDecoration(labelText: 'Jumlah Mahasiswa Lulus Akhir TS-4'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahMhsLulusAkhirTs5Controller,
                  decoration: const InputDecoration(labelText: 'Jumlah Mahasiswa Lulus Akhir TS-5'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahMhsLulusAkhirTs6Controller,
                  decoration: const InputDecoration(labelText: 'Jumlah Mahasiswa Lulus Akhir TS-6'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: meanMasaStudiController,
                  decoration: const InputDecoration(labelText: 'Mean Masa Studi'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                if (tahunController.text.isEmpty ||
                    jumlahMhsDiterimaController.text.isEmpty ||
                    jumlahMhsLulusAkhirTsController.text.isEmpty ||
                    jumlahMhsLulusAkhirTs1Controller.text.isEmpty ||
                    jumlahMhsLulusAkhirTs2Controller.text.isEmpty ||
                    jumlahMhsLulusAkhirTs3Controller.text.isEmpty ||
                    jumlahMhsLulusAkhirTs4Controller.text.isEmpty ||
                    jumlahMhsLulusAkhirTs5Controller.text.isEmpty ||
                    jumlahMhsLulusAkhirTs6Controller.text.isEmpty ||
                    jumlahLulusanController.text.isEmpty ||
                    meanMasaStudiController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua bidang harus diisi')),
                  );
                  return;
                }

                _editData(id, {
                  'id': id, // Pastikan ID dikirim kembali untuk update
                  'user_id': userId,
                  'tahun': tahunController.text,
                  'masa_studi': masaStudiController.text.isNotEmpty ? masaStudiController.text : null, // Send null if empty
                  'jumlah_mhs_diterima': int.tryParse(jumlahMhsDiterimaController.text) ?? 0,
                  'jumlah_mhs_lulus_akhir_ts': int.tryParse(jumlahMhsLulusAkhirTsController.text) ?? 0,
                  'jumlah_mhs_lulus_akhir_ts_1': int.tryParse(jumlahMhsLulusAkhirTs1Controller.text) ?? 0,
                  'jumlah_mhs_lulus_akhir_ts_2': int.tryParse(jumlahMhsLulusAkhirTs2Controller.text) ?? 0,
                  'jumlah_mhs_lulus_akhir_ts_3': int.tryParse(jumlahMhsLulusAkhirTs3Controller.text) ?? 0,
                  'jumlah_mhs_lulus_akhir_ts_4': int.tryParse(jumlahMhsLulusAkhirTs4Controller.text) ?? 0,
                  'jumlah_mhs_lulus_akhir_ts_5': int.tryParse(jumlahMhsLulusAkhirTs5Controller.text) ?? 0,
                  'jumlah_mhs_lulus_akhir_ts_6': int.tryParse(jumlahMhsLulusAkhirTs6Controller.text) ?? 0,
                  'jumlah_lulusan': int.tryParse(jumlahLulusanController.text) ?? 0,
                  'mean_masa_studi': double.tryParse(meanMasaStudiController.text) ?? 0.0,
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