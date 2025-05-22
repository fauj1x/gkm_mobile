import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/kinerjalulusan_waktu.dart'; // Sesuaikan path ini jika perlu
import 'package:gkm_mobile/models/tahun_ajaran.dart'; // Jika masih relevan, pertahankan
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaktuTunggu extends StatefulWidget {
  final TahunAjaran? tahunAjaran; // Dapat dihapus jika tidak digunakan
  const WaktuTunggu({Key? key, this.tahunAjaran}) : super(key: key);

  @override
  WaktuTungguState createState() => WaktuTungguState();
}

class WaktuTungguState extends State<WaktuTunggu> {
  List<WaktuTungguModel> dataList = [];
  ApiService apiService = ApiService();
  String menuName = "Data Waktu Tunggu Lulusan";
  String subMenuName = ""; // Biarkan kosong jika tidak ada sub-menu
  String endPoint = "waktu-tunggu"; // Endpoint API untuk Waktu Tunggu
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
      final data = await apiService.getData(WaktuTungguModel.fromJson, endPoint);
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
      await apiService.postData(WaktuTungguModel.fromJson, newData, endPoint);
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
      await apiService.updateData(WaktuTungguModel.fromJson, id, updatedData, endPoint);
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
                                _headerCell("Masa Studi", 100),
                                _headerCell("Jumlah Lulusan", 120),
                                _headerCell("Lulusan Terlacak", 120),
                                _headerCell("Lulusan Terlacak Dipesan", 180),
                                _headerCell("Waktu 3 Bulan", 120),
                                _headerCell("Waktu 6 Bulan", 120),
                                _headerCell("Waktu 9 Bulan", 120),
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
                              2: FixedColumnWidth(100),
                              3: FixedColumnWidth(120),
                              4: FixedColumnWidth(120),
                              5: FixedColumnWidth(180),
                              6: FixedColumnWidth(120),
                              7: FixedColumnWidth(120),
                              8: FixedColumnWidth(120),
                              9: FixedColumnWidth(80),
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
                                      child: Center(child: Text(data.masaStudi)),
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
                                      child: Center(child: Text(data.jumlahLulusanTerlacakDipesan.toString())),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahLulusanWaktuTigaBulan.toString())),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahLulusanWaktuEnamBulan.toString())),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahLulusanWaktuSembilanBulan.toString())),
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
    final TextEditingController jumlahLulusanController = TextEditingController();
    final TextEditingController jumlahLulusanTerlacakController = TextEditingController();
    final TextEditingController jumlahLulusanTerlacakDipesanController = TextEditingController();
    final TextEditingController jumlahLulusanWaktuTigaBulanController = TextEditingController();
    final TextEditingController jumlahLulusanWaktuEnamBulanController = TextEditingController();
    final TextEditingController jumlahLulusanWaktuSembilanBulanController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data Waktu Tunggu Lulusan'),
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
                  controller: masaStudiController,
                  decoration: const InputDecoration(labelText: 'Masa Studi (contoh: <= 6 Bulan)'),
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
                  controller: jumlahLulusanTerlacakDipesanController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan Terlacak Dipesan'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanWaktuTigaBulanController,
                  decoration: const InputDecoration(labelText: 'Jml Lulusan Waktu 3 Bulan'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanWaktuEnamBulanController,
                  decoration: const InputDecoration(labelText: 'Jml Lulusan Waktu 6 Bulan'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanWaktuSembilanBulanController,
                  decoration: const InputDecoration(labelText: 'Jml Lulusan Waktu 9 Bulan'),
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
                if (tahunController.text.isEmpty ||
                    masaStudiController.text.isEmpty ||
                    jumlahLulusanController.text.isEmpty ||
                    jumlahLulusanTerlacakController.text.isEmpty ||
                    jumlahLulusanTerlacakDipesanController.text.isEmpty ||
                    jumlahLulusanWaktuTigaBulanController.text.isEmpty ||
                    jumlahLulusanWaktuEnamBulanController.text.isEmpty ||
                    jumlahLulusanWaktuSembilanBulanController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua bidang harus diisi')),
                  );
                  return;
                }

                _addData({
                  'user_id': userId,
                  'tahun': tahunController.text,
                  'masa_studi': masaStudiController.text,
                  'jumlah_lulusan': int.tryParse(jumlahLulusanController.text) ?? 0,
                  'jumlah_lulusan_terlacak': int.tryParse(jumlahLulusanTerlacakController.text) ?? 0,
                  'jumlah_lulusan_terlacak_dipesan': int.tryParse(jumlahLulusanTerlacakDipesanController.text) ?? 0,
                  'jumlah_lulusan_waktu_tiga_bulan': int.tryParse(jumlahLulusanWaktuTigaBulanController.text) ?? 0,
                  'jumlah_lulusan_waktu_enam_bulan': int.tryParse(jumlahLulusanWaktuEnamBulanController.text) ?? 0,
                  'jumlah_lulusan_waktu_sembilan_bulan': int.tryParse(jumlahLulusanWaktuSembilanBulanController.text) ?? 0,
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

  void _showEditDialog(int id, WaktuTungguModel currentData) {
    final TextEditingController tahunController = TextEditingController(text: currentData.tahun);
    final TextEditingController masaStudiController = TextEditingController(text: currentData.masaStudi);
    final TextEditingController jumlahLulusanController = TextEditingController(text: currentData.jumlahLulusan.toString());
    final TextEditingController jumlahLulusanTerlacakController = TextEditingController(text: currentData.jumlahLulusanTerlacak.toString());
    final TextEditingController jumlahLulusanTerlacakDipesanController = TextEditingController(text: currentData.jumlahLulusanTerlacakDipesan.toString());
    final TextEditingController jumlahLulusanWaktuTigaBulanController = TextEditingController(text: currentData.jumlahLulusanWaktuTigaBulan.toString());
    final TextEditingController jumlahLulusanWaktuEnamBulanController = TextEditingController(text: currentData.jumlahLulusanWaktuEnamBulan.toString());
    final TextEditingController jumlahLulusanWaktuSembilanBulanController = TextEditingController(text: currentData.jumlahLulusanWaktuSembilanBulan.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Waktu Tunggu Lulusan'),
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
                  controller: masaStudiController,
                  decoration: const InputDecoration(labelText: 'Masa Studi (contoh: <= 6 Bulan)'),
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
                  controller: jumlahLulusanTerlacakDipesanController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan Terlacak Dipesan'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanWaktuTigaBulanController,
                  decoration: const InputDecoration(labelText: 'Jml Lulusan Waktu 3 Bulan'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanWaktuEnamBulanController,
                  decoration: const InputDecoration(labelText: 'Jml Lulusan Waktu 6 Bulan'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanWaktuSembilanBulanController,
                  decoration: const InputDecoration(labelText: 'Jml Lulusan Waktu 9 Bulan'),
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
                if (tahunController.text.isEmpty ||
                    masaStudiController.text.isEmpty ||
                    jumlahLulusanController.text.isEmpty ||
                    jumlahLulusanTerlacakController.text.isEmpty ||
                    jumlahLulusanTerlacakDipesanController.text.isEmpty ||
                    jumlahLulusanWaktuTigaBulanController.text.isEmpty ||
                    jumlahLulusanWaktuEnamBulanController.text.isEmpty ||
                    jumlahLulusanWaktuSembilanBulanController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua bidang harus diisi')),
                  );
                  return;
                }

                _editData(id, {
                  'id': id, // Pastikan ID dikirim kembali untuk update
                  'user_id': userId,
                  'tahun': tahunController.text,
                  'masa_studi': masaStudiController.text,
                  'jumlah_lulusan': int.tryParse(jumlahLulusanController.text) ?? 0,
                  'jumlah_lulusan_terlacak': int.tryParse(jumlahLulusanTerlacakController.text) ?? 0,
                  'jumlah_lulusan_terlacak_dipesan': int.tryParse(jumlahLulusanTerlacakDipesanController.text) ?? 0,
                  'jumlah_lulusan_waktu_tiga_bulan': int.tryParse(jumlahLulusanWaktuTigaBulanController.text) ?? 0,
                  'jumlah_lulusan_waktu_enam_bulan': int.tryParse(jumlahLulusanWaktuEnamBulanController.text) ?? 0,
                  'jumlah_lulusan_waktu_sembilan_bulan': int.tryParse(jumlahLulusanWaktuSembilanBulanController.text) ?? 0,
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