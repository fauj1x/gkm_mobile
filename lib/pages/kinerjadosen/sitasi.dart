import 'package:flutter/material.dart';
// Import model yang sudah diperbarui
import 'package:gkm_mobile/models/kinerja_sitasi.dart'; // Pastikan nama file ini sesuai dengan model Kinerja_Sitasi
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Ubah nama kelas widget
class KinerjaSitasiScreen extends StatefulWidget { // Nama kelas widget diubah
  final TahunAjaran tahunAjaran;
  const KinerjaSitasiScreen({Key? key, required this.tahunAjaran}) // Nama constructor diubah
      : super(key: key);
  @override
  // Ubah nama state class
  KinerjaSitasiState createState() => KinerjaSitasiState(); // Nama state diubah
}

// Ubah nama state class
class KinerjaSitasiState extends State<KinerjaSitasiScreen> { // Nama state diubah
  // Tingkat options tidak relevan lagi
  // final List<String> tingkatOptions = ['lokal', 'nasional', 'internasional'];

  // Tipe list menggunakan model Kinerja_Sitasi
  List<Kinerja_Sitasi> dataList = [];
  ApiService apiService = ApiService();
  // Sesuaikan nama menu dan sub-menu
  String menuName = "Sitasi"; // Contoh
  String subMenuName = "Sitasi"; // Sesuai nama kelas dan konteks
  String endPoint = "kinerja-sitasi"; // Endpoint sesuai nama kelas
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
      // Menggunakan model Kinerja_Sitasi
      final data = await apiService.getData(
          Kinerja_Sitasi.fromJson, endPoint); // Menggunakan Kinerja_Sitasi.fromJson
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
      // Menggunakan model Kinerja_Sitasi
      await apiService.postData(
         Kinerja_Sitasi.fromJson, newData, endPoint); // Menggunakan Kinerja_Sitasi.fromJson
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
      // Menggunakan model Kinerja_Sitasi
      await apiService.updateData(
          Kinerja_Sitasi.fromJson, id, updatedData, endPoint); // Menggunakan Kinerja_Sitasi.fromJson
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
                          // Header Tabel - Sesuaikan dengan field di Kinerja_Sitasi (nama_dosen, judul_artikel, jumlah_sitasi, tahun)
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _headerCell("No", 50),
                                _headerCell("Nama Dosen", 150), // Dari struktur data asli
                                _headerCell("Judul Artikel", 200), // Dari struktur data asli
                                _headerCell("Jumlah Sitasi", 100), // Dari struktur data asli
                                _headerCell("Tahun", 80), // Dari struktur data asli
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),

                          // Isi Data - Sesuaikan dengan field di Kinerja_Sitasi
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50), // No
                              1: FixedColumnWidth(150), // Nama Dosen
                              2: FixedColumnWidth(200), // Judul Artikel
                              3: FixedColumnWidth(100), // Jumlah Sitasi
                              4: FixedColumnWidth(80), // Tahun
                              5: FixedColumnWidth(50), // Aksi
                            },
                            children: dataList.asMap().entries.map((entry) {
                              int index = entry.key;
                              Kinerja_Sitasi data = entry.value; // Menggunakan model Kinerja_Sitasi
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
                                  // Judul Artikel
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.judul_artikel)), // Ambil dari model
                                    ),
                                  ),
                                   // Jumlah Sitasi
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlah_sitasi.toString())), // Ambil dari model
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
                                                'judul_artikel': data.judul_artikel,
                                                'jumlah_sitasi': data.jumlah_sitasi,
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
    // Controllers untuk field dari struktur data asli
    final TextEditingController namaDosenController = TextEditingController();
    final TextEditingController judulArtikelController = TextEditingController();
    final TextEditingController jumlahSitasiController = TextEditingController();
    final TextEditingController tahunController = TextEditingController();


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Data Sitasi'), // Judul disesuaikan
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Agar dialog menyesuaikan konten
              children: [
                TextField(
                    controller: namaDosenController,
                    decoration: InputDecoration(labelText: 'Nama Dosen')),
                TextField(
                    controller: judulArtikelController,
                    decoration: InputDecoration(labelText: 'Judul Artikel')),
                 TextField(
                    controller: jumlahSitasiController,
                     keyboardType: TextInputType.number, // Input angka
                    decoration: InputDecoration(labelText: 'Jumlah Sitasi')),
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
                if (namaDosenController.text.isEmpty || judulArtikelController.text.isEmpty || jumlahSitasiController.text.isEmpty || tahunController.text.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Semua field harus diisi.')),
                   );
                   return; // Jangan lanjutkan jika ada field yang kosong
                }

                 // Coba parse jumlahSitasi dan tahun menjadi integer
                 int? jumlahSitasi = int.tryParse(jumlahSitasiController.text);
                 // Tahun bisa string atau int tergantung kebutuhan backend
                 // Untuk saat ini, kita kirim sebagai string
                 String tahun = tahunController.text;


                 if (jumlahSitasi == null) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Jumlah Sitasi harus berupa angka.')),
                     );
                     return;
                 }


                _addData({
                  'user_id': userId,
                  // 'tahun_ajaran_id': widget.tahunAjaran.id, // Cek apakah backend butuh tahun_ajaran_id di endpoint ini
                  'nama_dosen': namaDosenController.text,
                  'judul_artikel': judulArtikelController.text,
                  'jumlah_sitasi': jumlahSitasi, // Kirim sebagai integer
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
     // Controllers untuk field dari struktur data asli
    final TextEditingController namaDosenController =
        TextEditingController(text: currentData['nama_dosen']?.toString() ?? '');
    final TextEditingController judulArtikelController =
        TextEditingController(text: currentData['judul_artikel']?.toString() ?? '');
    final TextEditingController jumlahSitasiController =
        TextEditingController(text: currentData['jumlah_sitasi']?.toString() ?? '');
    final TextEditingController tahunController =
        TextEditingController(text: currentData['tahun']?.toString() ?? '');


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Data Sitasi'), // Judul disesuaikan
          content: SingleChildScrollView(
            child: Column(
               mainAxisSize: MainAxisSize.min, // Agar dialog menyesuaikan konten
              children: [
                 TextField(
                    controller: namaDosenController,
                    decoration: InputDecoration(labelText: 'Nama Dosen')),
                TextField(
                    controller: judulArtikelController,
                    decoration: InputDecoration(labelText: 'Judul Artikel')),
                 TextField(
                    controller: jumlahSitasiController,
                     keyboardType: TextInputType.number, // Input angka
                    decoration: InputDecoration(labelText: 'Jumlah Sitasi')),
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
                 if (namaDosenController.text.isEmpty || judulArtikelController.text.isEmpty || jumlahSitasiController.text.isEmpty || tahunController.text.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Semua field harus diisi.')),
                   );
                   return; // Jangan lanjutkan jika ada field yang kosong
                }

                 // Coba parse jumlahSitasi menjadi integer
                 int? jumlahSitasi = int.tryParse(jumlahSitasiController.text);
                 // Tahun bisa string atau int tergantung kebutuhan backend
                  String tahun = tahunController.text;


                 if (jumlahSitasi == null) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Jumlah Sitasi harus berupa angka.')),
                     );
                     return;
                 }


                _editData(id, {
                  'nama_dosen': namaDosenController.text,
                  'judul_artikel': judulArtikelController.text,
                  'jumlah_sitasi': jumlahSitasi, // Kirim sebagai integer
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