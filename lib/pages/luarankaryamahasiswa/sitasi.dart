// lib/widgets/sitasi_mahasiswa_screen.dart
import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/luaranmhs_sitasi.dart'; // Sesuaikan path ini
import 'package:gkm_mobile/models/tahun_ajaran.dart'; // Jika masih relevan, pertahankan
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SitasiMahasiswaScreen extends StatefulWidget {
  final TahunAjaran? tahunAjaran; // Dapat dihapus jika tidak digunakan
  const SitasiMahasiswaScreen({Key? key, this.tahunAjaran}) : super(key: key);

  @override
  SitasiMahasiswaScreenState createState() => SitasiMahasiswaScreenState();
}

class SitasiMahasiswaScreenState extends State<SitasiMahasiswaScreen> {
  List<SitasiMahasiswa> dataList = [];
  ApiService apiService = ApiService();
  String menuName = "Data Sitasi Mahasiswa";
  String subMenuName = ""; // Biarkan kosong jika tidak ada sub-menu
  String endPoint = "luaran-sitasi-mahasiswa"; // Endpoint API
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
      final data = await apiService.getData(SitasiMahasiswa.fromJson, endPoint);
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
      await apiService.postData(SitasiMahasiswa.fromJson, newData, endPoint);
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
      await apiService.updateData(SitasiMahasiswa.fromJson, id, updatedData, endPoint);
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
                                _headerCell("Judul Artikel", 250),
                                _headerCell("Jumlah Sitasi", 120),
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
                              2: FixedColumnWidth(250),
                              3: FixedColumnWidth(120),
                              4: FixedColumnWidth(80),
                              5: FixedColumnWidth(80),
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
                                      child: Text(data.judulArtikel),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahSitasi.toString())),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.tahun??'')),
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
    final TextEditingController judulArtikelController = TextEditingController();
    final TextEditingController jumlahSitasiController = TextEditingController();
    final TextEditingController tahunController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data Sitasi Mahasiswa'),
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
                  maxLines: null, // Allow multiple lines
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
              onPressed: () {
                Navigator.pop(context);
              },
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
                    const SnackBar(content: Text('Semua bidang harus diisi')),
                  );
                  return;
                }

                final int? parsedJumlahSitasi = int.tryParse(jumlahSitasiController.text);
                if (parsedJumlahSitasi == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Jumlah Sitasi harus berupa angka')),
                  );
                  return;
                }

                _addData({
                  'user_id': userId,
                  'nama_mahasiswa': namaMahasiswaController.text,
                  'judul_artikel': judulArtikelController.text,
                  'jumlah_sitasi': parsedJumlahSitasi.toString(),
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

  void _showEditDialog(int id, SitasiMahasiswa currentData) {
    final TextEditingController namaMahasiswaController = TextEditingController(text: currentData.namaMahasiswa);
    final TextEditingController judulArtikelController = TextEditingController(text: currentData.judulArtikel);
    final jumlahSitasiController = TextEditingController(text: currentData.jumlahSitasi.toString());
    final TextEditingController tahunController = TextEditingController(text: currentData.tahun);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Sitasi Mahasiswa'),
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
                  maxLines: null, // Allow multiple lines
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Validasi input
                if (namaMahasiswaController.text.isEmpty ||
                    judulArtikelController.text.isEmpty ||
                    jumlahSitasiController.text.isEmpty||
                    tahunController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua bidang harus diisi')),
                  );
                  return;
                }

                

                final int? parsedJumlahSitasi = int.tryParse(jumlahSitasiController.text);
if (parsedJumlahSitasi == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Jumlah Sitasi harus berupa angka')),
  );
  return;
}

_editData(id, {
  'id': id,
  'user_id': userId,
  'nama_mahasiswa': namaMahasiswaController.text,
  'judul_artikel': judulArtikelController.text,
  'jumlah_sitasi': parsedJumlahSitasi,  // Kirim sebagai int
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