// lib/widgets/produk_mahasiswa_screen.dart
import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/luaranmhs_produkmhs.dart'; // Sesuaikan path ini
import 'package:gkm_mobile/models/tahun_ajaran.dart'; // Jika masih relevan, pertahankan
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProdukMahasiswaScreen extends StatefulWidget {
  final TahunAjaran? tahunAjaran; // Dapat dihapus jika tidak digunakan
  const ProdukMahasiswaScreen({Key? key, this.tahunAjaran}) : super(key: key);

  @override
  ProdukMahasiswaScreenState createState() => ProdukMahasiswaScreenState();
}

class ProdukMahasiswaScreenState extends State<ProdukMahasiswaScreen> {
  List<ProdukMahasiswa> dataList = [];
  ApiService apiService = ApiService();
  String menuName = "Data Produk Mahasiswa";
  String subMenuName = ""; // Biarkan kosong jika tidak ada sub-menu
  String endPoint = "luaran-produk-mahasiswa"; // Endpoint API
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
      final data = await apiService.getData(ProdukMahasiswa.fromJson, endPoint);
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
      await apiService.postData(ProdukMahasiswa.fromJson, newData, endPoint);
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
      await apiService.updateData(ProdukMahasiswa.fromJson, id, updatedData, endPoint);
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
                                _headerCell("Nama Mahasiswa", 150),
                                _headerCell("Nama Produk", 150),
                                _headerCell("Deskripsi Produk", 250),
                                _headerCell("Bukti", 100),
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
                              2: FixedColumnWidth(150),
                              3: FixedColumnWidth(250),
                              4: FixedColumnWidth(100),
                              5: FixedColumnWidth(80),
                              6: FixedColumnWidth(80),
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
                                      child: Text(data.namaMahasiswa),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(data.namaProduk),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(data.deskripsiProduk),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(data.bukti), // Menampilkan teks bukti
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
    final TextEditingController namaMahasiswaController = TextEditingController();
    final TextEditingController namaProdukController = TextEditingController();
    final TextEditingController deskripsiProdukController = TextEditingController();
    final TextEditingController buktiController = TextEditingController();
    final TextEditingController tahunController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data Produk Mahasiswa'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaMahasiswaController,
                  decoration: const InputDecoration(labelText: 'Nama Mahasiswa'),
                ),
                TextField(
                  controller: namaProdukController,
                  decoration: const InputDecoration(labelText: 'Nama Produk'),
                ),
                TextField(
                  controller: deskripsiProdukController,
                  decoration: const InputDecoration(labelText: 'Deskripsi Produk'),
                  maxLines: 3,
                ),
                TextField(
                  controller: buktiController,
                  decoration: const InputDecoration(labelText: 'Bukti (URL/Path)'),
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
                if (namaMahasiswaController.text.isEmpty ||
                    namaProdukController.text.isEmpty ||
                    deskripsiProdukController.text.isEmpty ||
                    buktiController.text.isEmpty ||
                    tahunController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua bidang harus diisi')),
                  );
                  return;
                }

                _addData({
                  'user_id': userId,
                  'nama_mahasiswa': namaMahasiswaController.text,
                  'nama_produk': namaProdukController.text,
                  'deskripsi_produk': deskripsiProdukController.text,
                  'bukti': buktiController.text,
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

  void _showEditDialog(int id, ProdukMahasiswa currentData) {
    final TextEditingController namaMahasiswaController = TextEditingController(text: currentData.namaMahasiswa);
    final TextEditingController namaProdukController = TextEditingController(text: currentData.namaProduk);
    final TextEditingController deskripsiProdukController = TextEditingController(text: currentData.deskripsiProduk);
    final TextEditingController buktiController = TextEditingController(text: currentData.bukti);
    final TextEditingController tahunController = TextEditingController(text: currentData.tahun);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Produk Mahasiswa'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaMahasiswaController,
                  decoration: const InputDecoration(labelText: 'Nama Mahasiswa'),
                ),
                TextField(
                  controller: namaProdukController,
                  decoration: const InputDecoration(labelText: 'Nama Produk'),
                ),
                TextField(
                  controller: deskripsiProdukController,
                  decoration: const InputDecoration(labelText: 'Deskripsi Produk'),
                  maxLines: 3,
                ),
                TextField(
                  controller: buktiController,
                  decoration: const InputDecoration(labelText: 'Bukti (URL/Path)'),
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
                if (namaMahasiswaController.text.isEmpty ||
                    namaProdukController.text.isEmpty ||
                    deskripsiProdukController.text.isEmpty ||
                    buktiController.text.isEmpty ||
                    tahunController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua bidang harus diisi')),
                  );
                  return;
                }

                _editData(id, {
                  'id': id, // Pastikan ID dikirim kembali untuk update
                  'user_id': userId,
                  'nama_mahasiswa': namaMahasiswaController.text,
                  'nama_produk': namaProdukController.text,
                  'deskripsi_produk': deskripsiProdukController.text,
                  'bukti': buktiController.text,
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