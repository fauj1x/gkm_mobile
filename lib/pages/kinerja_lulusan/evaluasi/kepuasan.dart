import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/kinerjalulusan_kepuasan.dart'; // Sesuaikan path ini jika perlu
import 'package:gkm_mobile/models/tahun_ajaran.dart'; // Jika masih relevan, pertahankan
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EvalKepuasan extends StatefulWidget {
  final TahunAjaran? tahunAjaran;
  const EvalKepuasan({Key? key, this.tahunAjaran}) : super(key: key);

  @override
  EvalKepuasanState createState() => EvalKepuasanState();
}

class EvalKepuasanState extends State<EvalKepuasan> {
  List<EvalKepuasanModel> dataList = [];
  ApiService apiService = ApiService();
  String menuName = "Data Evaluasi Kepuasan";
  String subMenuName = ""; // Biarkan kosong jika tidak ada sub-menu
  String endPoint = "kepuasan-pengguna"; // Endpoint API untuk Eval Kepuasan
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
      final data = await apiService.getData(EvalKepuasanModel.fromJson, endPoint);
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
      await apiService.postData(EvalKepuasanModel.fromJson, newData, endPoint);
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
      await apiService.updateData(EvalKepuasanModel.fromJson, id, updatedData, endPoint);
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
                                _headerCell("Jenis Kemampuan", 150),
                                _headerCell("Sangat Baik", 100),
                                _headerCell("Baik", 80),
                                _headerCell("Cukup", 80),
                                _headerCell("Kurang", 80),
                                _headerCell("Rencana Tindakan", 150),
                                _headerCell("Jml Lulusan", 100),
                                _headerCell("Jml Responden", 120),
                                _headerCell("Tahun", 80),
                                _headerCell("Aksi", 80),
                              ],
                            ),
                          ),

                          // Isi Data Tabel
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50),
                              1: FixedColumnWidth(150),
                              2: FixedColumnWidth(100),
                              3: FixedColumnWidth(80),
                              4: FixedColumnWidth(80),
                              5: FixedColumnWidth(80),
                              6: FixedColumnWidth(150),
                              7: FixedColumnWidth(100),
                              8: FixedColumnWidth(120),
                              9: FixedColumnWidth(80),
                              10: FixedColumnWidth(80),
                            },
                            children: dataList.asMap().entries.map((entry) {
                              final data = entry.value; // Ambil objek model langsung
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
                                      child: Center(child: Text(data.jenisKemampuan)),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.tingkatKepuasanSangatBaik.toString())),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.tingkatKepuasanBaik.toString())),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.tingkatKepuasanCukup.toString())),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.tingkatKepuasanKurang.toString())),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.rencanaTindakan)),
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
                                      child: Center(child: Text(data.jumlahResponden.toString())),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.tahun)),
                                    ),
                                  ),
                                  // Aksi Button
                                  TableCell(
                                    child: Center(
                                      child: PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert, color: Colors.black87),
                                        onSelected: (String choice) {
                                          if (choice == "Edit") {
                                            _showEditDialog(data.id, data); // Meneruskan objek model
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
    final TextEditingController jenisKemampuanController = TextEditingController();
    final TextEditingController sangatBaikController = TextEditingController();
    final TextEditingController baikController = TextEditingController();
    final TextEditingController cukupController = TextEditingController();
    final TextEditingController kurangController = TextEditingController();
    final TextEditingController rencanaTindakanController = TextEditingController();
    final TextEditingController jumlahLulusanController = TextEditingController();
    final TextEditingController jumlahRespondenController = TextEditingController();
    final TextEditingController tahunController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data Evaluasi Kepuasan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: jenisKemampuanController,
                  decoration: const InputDecoration(labelText: 'Jenis Kemampuan'),
                ),
                TextField(
                  controller: sangatBaikController,
                  decoration: const InputDecoration(labelText: 'Tingkat Kepuasan Sangat Baik'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: baikController,
                  decoration: const InputDecoration(labelText: 'Tingkat Kepuasan Baik'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: cukupController,
                  decoration: const InputDecoration(labelText: 'Tingkat Kepuasan Cukup'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: kurangController,
                  decoration: const InputDecoration(labelText: 'Tingkat Kepuasan Kurang'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: rencanaTindakanController,
                  decoration: const InputDecoration(labelText: 'Rencana Tindakan'),
                ),
                TextField(
                  controller: jumlahLulusanController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahRespondenController,
                  decoration: const InputDecoration(labelText: 'Jumlah Responden'),
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Validasi input
                if (jenisKemampuanController.text.isEmpty ||
                    sangatBaikController.text.isEmpty ||
                    baikController.text.isEmpty ||
                    cukupController.text.isEmpty ||
                    kurangController.text.isEmpty ||
                    rencanaTindakanController.text.isEmpty ||
                    jumlahLulusanController.text.isEmpty ||
                    jumlahRespondenController.text.isEmpty ||
                    tahunController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua bidang harus diisi')),
                  );
                  return;
                }

                _addData({
                  'user_id': userId,
                  'jenis_kemampuan': jenisKemampuanController.text,
                  'tingkat_kepuasan_sangat_baik': int.tryParse(sangatBaikController.text) ?? 0,
                  'tingkat_kepuasan_baik': int.tryParse(baikController.text) ?? 0,
                  'tingkat_kepuasan_cukup': int.tryParse(cukupController.text) ?? 0,
                  'tingkat_kepuasan_kurang': int.tryParse(kurangController.text) ?? 0,
                  'rencana_tindakan': rencanaTindakanController.text,
                  'jumlah_lulusan': int.tryParse(jumlahLulusanController.text) ?? 0,
                  'jumlah_responden': int.tryParse(jumlahRespondenController.text) ?? 0,
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

  void _showEditDialog(int id, EvalKepuasanModel currentData) {
    final TextEditingController jenisKemampuanController = TextEditingController(text: currentData.jenisKemampuan);
    final TextEditingController sangatBaikController = TextEditingController(text: currentData.tingkatKepuasanSangatBaik.toString());
    final TextEditingController baikController = TextEditingController(text: currentData.tingkatKepuasanBaik.toString());
    final TextEditingController cukupController = TextEditingController(text: currentData.tingkatKepuasanCukup.toString());
    final TextEditingController kurangController = TextEditingController(text: currentData.tingkatKepuasanKurang.toString());
    final TextEditingController rencanaTindakanController = TextEditingController(text: currentData.rencanaTindakan);
    final TextEditingController jumlahLulusanController = TextEditingController(text: currentData.jumlahLulusan.toString());
    final TextEditingController jumlahRespondenController = TextEditingController(text: currentData.jumlahResponden.toString());
    final TextEditingController tahunController = TextEditingController(text: currentData.tahun);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Evaluasi Kepuasan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: jenisKemampuanController,
                  decoration: const InputDecoration(labelText: 'Jenis Kemampuan'),
                ),
                TextField(
                  controller: sangatBaikController,
                  decoration: const InputDecoration(labelText: 'Tingkat Kepuasan Sangat Baik'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: baikController,
                  decoration: const InputDecoration(labelText: 'Tingkat Kepuasan Baik'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: cukupController,
                  decoration: const InputDecoration(labelText: 'Tingkat Kepuasan Cukup'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: kurangController,
                  decoration: const InputDecoration(labelText: 'Tingkat Kepuasan Kurang'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: rencanaTindakanController,
                  decoration: const InputDecoration(labelText: 'Rencana Tindakan'),
                ),
                TextField(
                  controller: jumlahLulusanController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahRespondenController,
                  decoration: const InputDecoration(labelText: 'Jumlah Responden'),
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Validasi input
                if (jenisKemampuanController.text.isEmpty ||
                    sangatBaikController.text.isEmpty ||
                    baikController.text.isEmpty ||
                    cukupController.text.isEmpty ||
                    kurangController.text.isEmpty ||
                    rencanaTindakanController.text.isEmpty ||
                    jumlahLulusanController.text.isEmpty ||
                    jumlahRespondenController.text.isEmpty ||
                    tahunController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua bidang harus diisi')),
                  );
                  return;
                }

                _editData(id, {
                  'id': id, // Pastikan ID dikirim kembali untuk update
                  'user_id': userId,
                  'jenis_kemampuan': jenisKemampuanController.text,
                  'tingkat_kepuasan_sangat_baik': int.tryParse(sangatBaikController.text) ?? 0,
                  'tingkat_kepuasan_baik': int.tryParse(baikController.text) ?? 0,
                  'tingkat_kepuasan_cukup': int.tryParse(cukupController.text) ?? 0,
                  'tingkat_kepuasan_kurang': int.tryParse(kurangController.text) ?? 0,
                  'rencana_tindakan': rencanaTindakanController.text,
                  'jumlah_lulusan': int.tryParse(jumlahLulusanController.text) ?? 0,
                  'jumlah_responden': int.tryParse(jumlahRespondenController.text) ?? 0,
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