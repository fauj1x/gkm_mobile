import 'package:flutter/material.dart';
// Import model yang sudah diperbarui
import 'package:gkm_mobile/models/kinerja_produk.dart'; // Pastikan nama file ini sesuai dengan model Kinerja_Produk
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Ubah nama kelas widget
class KinerjaProdukScreen extends StatefulWidget { // Nama kelas widget diubah
  final TahunAjaran tahunAjaran;
  const KinerjaProdukScreen({Key? key, required this.tahunAjaran}) // Nama constructor diubah
      : super(key: key);
  @override
  // Ubah nama state class
  KinerjaProdukState createState() => KinerjaProdukState(); // Nama state diubah
}

// Ubah nama state class
class KinerjaProdukState extends State<KinerjaProdukScreen> { // Nama state diubah
  // Tingkat options tidak relevan lagi
  // final List<String> tingkatOptions = ['lokal', 'nasional', 'internasional'];

  // Tipe list menggunakan model Kinerja_Produk
  List<Kinerja_Produk> dataList = [];
  ApiService apiService = ApiService();
  // Sesuaikan nama menu dan sub-menu
  String menuName = "Kinerja DTPS"; // Contoh
  String subMenuName = "Produk"; // Sesuai nama kelas dan konteks
  String endPoint = "kinerja-produk"; // Endpoint sesuai nama kelas
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserId(); // Ambil userId sebelum fetch data
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
      // Menggunakan model Kinerja_Produk
      final data = await apiService.getData(
          Kinerja_Produk.fromJson, endPoint); // Menggunakan Kinerja_Produk.fromJson
      setState(() {
        dataList = data;
      });
    } catch (e) {
      print("Error fetching data: $e");
      // Tampilkan pesan error ke pengguna jika perlu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data: ${e.toString()}')),
      );
    }
  }

  Future<void> _addData(Map<String, dynamic> newData) async {
    try {
      // Menggunakan model Kinerja_Produk
      await apiService.postData(
         Kinerja_Produk.fromJson, newData, endPoint); // Menggunakan Kinerja_Produk.fromJson
      _fetchData(); // Refresh data setelah berhasil menambah
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

  Future<void> _deleteData(int id) async { // Menggunakan ID, bukan index
    try {
      await apiService.deleteData(id, endPoint);
      _fetchData(); // Refresh data setelah berhasil menghapus
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

  Future<void> _editData(int id, Map<String, dynamic> updatedData) async { // Menggunakan ID, bukan index
    try {
      // Menggunakan model Kinerja_Produk
      await apiService.updateData(
          Kinerja_Produk.fromJson, id, updatedData, endPoint); // Menggunakan Kinerja_Produk.fromJson
      _fetchData(); // Refresh data setelah berhasil mengedit
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              menuName,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 2),
            Text(
              subMenuName,
              style: TextStyle(fontSize: 14, color: Colors.grey),
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
                // Input Search (Optional, implement search logic if needed)
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
                          // Implement search logic here
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          // Header Tabel - Sesuaikan dengan field di Kinerja_Produk
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _headerCell("No", 50),
                                _headerCell("Nama Dosen", 150), // Dari struktur data baru
                                _headerCell("Nama Produk", 150), // Dari struktur data baru
                                _headerCell("Deskripsi Produk", 200), // Dari struktur data baru
                                _headerCell("Bukti", 100), // Dari struktur data baru
                                _headerCell("Tahun", 80), // Dari struktur data baru
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),

                          // Isi Data - Sesuaikan dengan field di Kinerja_Produk
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50), // No
                              1: FixedColumnWidth(150), // Nama Dosen
                              2: FixedColumnWidth(150), // Nama Produk
                              3: FixedColumnWidth(200), // Deskripsi Produk
                              4: FixedColumnWidth(100), // Bukti
                              5: FixedColumnWidth(80), // Tahun
                              6: FixedColumnWidth(50), // Aksi
                            },
                            children: dataList.asMap().entries.map((entry) {
                              int index = entry.key;
                              Kinerja_Produk data = entry.value; // Menggunakan model Kinerja_Produk
                              return TableRow(
                                children: [
                                  // Nomor
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text((index + 1).toString())),
                                    ),
                                  ),
                                  // Nama Dosen
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.nama_dosen)), // Ambil dari model
                                    ),
                                  ),
                                  // Nama Produk
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.nama_produk)), // Ambil dari model
                                    ),
                                  ),
                                   // Deskripsi Produk
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.deskripsi_produk)), // Ambil dari model
                                    ),
                                  ),
                                   // Bukti
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.bukti)), // Ambil dari model
                                    ),
                                  ),
                                  // Tahun
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.tahun)), // Ambil dari model
                                    ),
                                  ),

                                  // Aksi Button
                                  TableCell(
                                    child: Center(
                                      child: PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert,
                                            color: Colors.black87),
                                        onSelected: (String choice) {
                                          if (choice == "Edit") {
                                            // Pastikan ID data ada sebelum mengedit
                                            if (data.id != null) {
                                               _showEditDialog(data.id!, {
                                                'nama_dosen': data.nama_dosen,
                                                'nama_produk': data.nama_produk,
                                                'deskripsi_produk': data.deskripsi_produk,
                                                'bukti': data.bukti,
                                                'tahun': data.tahun,
                                              });
                                            } else {
                                               ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('ID data tidak ditemukan untuk diedit.')),
                                              );
                                            }
                                          } else if (choice == "Hapus") {
                                             // Pastikan ID data ada sebelum menghapus
                                             if (data.id != null) {
                                                _deleteData(data.id!);
                                             } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('ID data tidak ditemukan untuk dihapus.')),
                                              );
                                             }
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<String>>[
                                          const PopupMenuItem<String>(
                                            value: "Edit",
                                            child: ListTile(
                                              leading: Icon(Icons.edit,
                                                  color: Colors.blue),
                                              title: Text("Edit"),
                                            ),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: "Hapus",
                                            child: ListTile(
                                              leading: Icon(Icons.delete,
                                                  color: Colors.red),
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
            bottom: 24, // Sedikit naikkan posisinya
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
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }


  void _showAddDialog() {
    // Controllers untuk field dari struktur data baru
    final TextEditingController namaDosenController = TextEditingController();
    final TextEditingController namaProdukController = TextEditingController();
    final TextEditingController deskripsiProdukController = TextEditingController();
    final TextEditingController buktiController = TextEditingController();
    final TextEditingController tahunController = TextEditingController();


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Data Produk'), // Judul disesuaikan
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Agar dialog menyesuaikan konten
              children: [
                TextField(
                    controller: namaDosenController,
                    decoration: InputDecoration(labelText: 'Nama Dosen')),
                TextField(
                    controller: namaProdukController,
                    decoration: InputDecoration(labelText: 'Nama Produk')),
                 TextField(
                    controller: deskripsiProdukController,
                    decoration: InputDecoration(labelText: 'Deskripsi Produk')),
                 TextField(
                    controller: buktiController,
                    decoration: InputDecoration(labelText: 'Bukti (Link/Deskripsi)')),
                 TextField(
                    controller: tahunController,
                     keyboardType: TextInputType.number, // Input angka untuk tahun
                    decoration: InputDecoration(labelText: 'Tahun')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Validasi sederhana sebelum mengirim
                if (namaDosenController.text.isEmpty || namaProdukController.text.isEmpty || deskripsiProdukController.text.isEmpty || buktiController.text.isEmpty || tahunController.text.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Semua field harus diisi.')),
                   );
                   return; // Jangan lanjutkan jika ada field yang kosong
                }

                 // Coba parse tahun menjadi integer (jika backend mengharapkan integer)
                 // Atau kirim sebagai string jika backend menerima string
                 // Untuk saat ini, kita kirim sebagai string
                 String tahun = tahunController.text;


                _addData({
                  'user_id': userId,
                  // 'tahun_ajaran_id': widget.tahunAjaran.id, // Cek apakah backend butuh tahun_ajaran_id di endpoint ini
                  'nama_dosen': namaDosenController.text,
                  'nama_produk': namaProdukController.text,
                  'deskripsi_produk': deskripsiProdukController.text,
                  'bukti': buktiController.text,
                  'tahun': tahun, // Kirim sebagai string
                });
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(int id, Map<String, dynamic> currentData) {
     // Controllers untuk field dari struktur data baru
    final TextEditingController namaDosenController =
        TextEditingController(text: currentData['nama_dosen']?.toString() ?? '');
    final TextEditingController namaProdukController =
        TextEditingController(text: currentData['nama_produk']?.toString() ?? '');
    final TextEditingController deskripsiProdukController =
        TextEditingController(text: currentData['deskripsi_produk']?.toString() ?? '');
    final TextEditingController buktiController =
        TextEditingController(text: currentData['bukti']?.toString() ?? '');
    final TextEditingController tahunController =
        TextEditingController(text: currentData['tahun']?.toString() ?? '');


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Data Produk'), // Judul disesuaikan
          content: SingleChildScrollView(
            child: Column(
               mainAxisSize: MainAxisSize.min, // Agar dialog menyesuaikan konten
              children: [
                 TextField(
                    controller: namaDosenController,
                    decoration: InputDecoration(labelText: 'Nama Dosen')),
                TextField(
                    controller: namaProdukController,
                    decoration: InputDecoration(labelText: 'Nama Produk')),
                 TextField(
                    controller: deskripsiProdukController,
                    decoration: InputDecoration(labelText: 'Deskripsi Produk')),
                 TextField(
                    controller: buktiController,
                    decoration: InputDecoration(labelText: 'Bukti (Link/Deskripsi)')),
                 TextField(
                    controller: tahunController,
                     keyboardType: TextInputType.number, // Input angka untuk tahun
                    decoration: InputDecoration(labelText: 'Tahun')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                 // Validasi sederhana sebelum mengirim
                 if (namaDosenController.text.isEmpty || namaProdukController.text.isEmpty || deskripsiProdukController.text.isEmpty || buktiController.text.isEmpty || tahunController.text.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Semua field harus diisi.')),
                   );
                   return; // Jangan lanjutkan jika ada field yang kosong
                }

                 // Tahun bisa string atau int tergantung kebutuhan backend
                  String tahun = tahunController.text;


                _editData(id, {
                  'nama_dosen': namaDosenController.text,
                  'nama_produk': namaProdukController.text,
                  'deskripsi_produk': deskripsiProdukController.text,
                  'bukti': buktiController.text,
                  'tahun': tahun, // Kirim sebagai string
                  // 'tahun_ajaran_id': widget.tahunAjaran.id, // Cek apakah backend butuh tahun_ajaran_id di endpoint ini saat update
                });
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}