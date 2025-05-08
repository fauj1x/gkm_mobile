import 'package:flutter/material.dart';
// Import model baru
import 'package:gkm_mobile/models/kinerja_pagelaran.dart'; // PASTIKAN NAMA FILE INI SESUAI
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Ubah nama kelas widget
class KinerjaPagelaranPage extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const KinerjaPagelaranPage({Key? key, required this.tahunAjaran})
      : super(key: key);
  @override
  // Ubah nama state class
  KinerjaPagelaranPageState createState() => KinerjaPagelaranPageState();
}

// Ubah nama state class
class KinerjaPagelaranPageState extends State<KinerjaPagelaranPage> {
  // Hapus properti yang tidak relevan dengan model baru
  // final List<String> tingkatOptions = ['lokal', 'nasional', 'internasional'];

  // Ganti tipe list menjadi List<Kinerja_Pagelaran>
  List<Kinerja_Pagelaran> dataList = [];
  ApiService apiService = ApiService();

  // Sesuaikan nama menu dan sub-menu jika perlu, berdasarkan data yang ditampilkan
  String menuName = "Pagelaran"; // Contoh: Jika ini bagian dari Kinerja DTPS
  String subMenuName = "Pagelaran"; // Nama sub-menu sesuai kelas
  String endPoint = "kinerja-publikasi"; // Endpoint untuk Kinerja Pagelaran
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
      // Ganti model yang digunakan untuk parsing data
      final data = await apiService.getData(
          Kinerja_Pagelaran.fromJson, endPoint); // Menggunakan Kinerja_Pagelaran
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
      // Ganti model yang digunakan
      await apiService.postData(
         Kinerja_Pagelaran.fromJson, newData, endPoint); // Menggunakan Kinerja_Pagelaran
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
      // Ganti model yang digunakan
      await apiService.updateData(
          Kinerja_Pagelaran.fromJson, id, updatedData, endPoint); // Menggunakan Kinerja_Pagelaran
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
                          // Header Tabel - Sesuaikan dengan field di Kinerja_Pagelaran
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _headerCell("No", 50),
                                _headerCell("Nama Dosen", 150), // Dari model baru
                                _headerCell("Judul Artikel", 200), // Dari model baru
                                _headerCell("Jenis Artikel", 150), // Dari model baru
                                _headerCell("Tahun", 100), // Dari model baru
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),

                          // Isi Data - Sesuaikan dengan field di Kinerja_Pagelaran
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50), // No
                              1: FixedColumnWidth(150), // Nama Dosen
                              2: FixedColumnWidth(200), // Judul Artikel
                              3: FixedColumnWidth(150), // Jenis Artikel
                              4: FixedColumnWidth(100), // Tahun
                              5: FixedColumnWidth(50), // Aksi
                            },
                            children: dataList.asMap().entries.map((entry) {
                              int index = entry.key;
                              Kinerja_Pagelaran data = entry.value; // Menggunakan model Kinerja_Pagelaran
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
                                      child: Center(child: Text(data.namaDosen)), // Ambil dari model baru
                                    ),
                                  ),
                                  // Judul Artikel
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.judulArtikel)), // Ambil dari model baru
                                    ),
                                  ),
                                  // Jenis Artikel
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jenisArtikel)), // Ambil dari model baru
                                    ),
                                  ),
                                   // Tahun
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.tahun)), // Ambil dari model baru
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
                                                'nama_dosen': data.namaDosen,
                                                'judul_artikel': data.judulArtikel,
                                                'jenis_artikel': data.jenisArtikel,
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

  // Hapus _emptyCell jika tidak digunakan
  // Widget _emptyCell(double width) {
  //   return Container(width: width, height: 40);
  // }

  void _showAddDialog() {
    // Controllers untuk field dari Kinerja_Pagelaran
    final TextEditingController namaDosenController = TextEditingController();
    final TextEditingController judulArtikelController = TextEditingController();
    final TextEditingController jenisArtikelController = TextEditingController();
    final TextEditingController tahunController = TextEditingController();


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Data Pagelaran'), // Judul lebih spesifik
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
                    controller: jenisArtikelController,
                    decoration: InputDecoration(labelText: 'Jenis Artikel')),
                TextField(
                    controller: tahunController,
                     keyboardType: TextInputType.number, // Input angka
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
                if (namaDosenController.text.isEmpty || judulArtikelController.text.isEmpty || jenisArtikelController.text.isEmpty || tahunController.text.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Semua field harus diisi.')),
                   );
                   return; // Jangan lanjutkan jika ada field yang kosong
                }

                 // Coba parse tahun menjadi integer (jika backend butuh)
                 // Kita kirim sebagai string sesuai model, tapi validasi format angka
                 int? tahunInt = int.tryParse(tahunController.text);

                 if (tahunInt == null) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Tahun harus berupa angka.')),
                     );
                     return;
                 }


                _addData({
                  'user_id': userId,
                  // 'tahun_ajaran_id': widget.tahunAjaran.id, // Cek apakah backend butuh tahun_ajaran_id di endpoint ini
                  'nama_dosen': namaDosenController.text,
                  'judul_artikel': judulArtikelController.text,
                  'jenis_artikel': jenisArtikelController.text,
                  'tahun': tahunController.text, // Kirim sebagai string
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
     // Controllers untuk field dari Kinerja_Pagelaran
    final TextEditingController namaDosenController =
        TextEditingController(text: currentData['nama_dosen']?.toString() ?? '');
    final TextEditingController judulArtikelController =
        TextEditingController(text: currentData['judul_artikel']?.toString() ?? '');
    final TextEditingController jenisArtikelController =
        TextEditingController(text: currentData['jenis_artikel']?.toString() ?? '');
    final TextEditingController tahunController =
        TextEditingController(text: currentData['tahun']?.toString() ?? ''); // Ambil dari kunci 'tahun'


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Data Pagelaran'), // Judul lebih spesifik
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
                    controller: jenisArtikelController,
                    decoration: InputDecoration(labelText: 'Jenis Artikel')),
                TextField(
                    controller: tahunController,
                     keyboardType: TextInputType.number, // Input angka
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
                 if (namaDosenController.text.isEmpty || judulArtikelController.text.isEmpty || jenisArtikelController.text.isEmpty || tahunController.text.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Semua field harus diisi.')),
                   );
                   return; // Jangan lanjutkan jika ada field yang kosong
                }

                 // Coba parse tahun menjadi integer (jika backend butuh)
                 int? tahunInt = int.tryParse(tahunController.text);
                 if (tahunInt == null) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Tahun harus berupa angka.')),
                     );
                     return;
                 }

                _editData(id, {
                  'nama_dosen': namaDosenController.text,
                  'judul_artikel': judulArtikelController.text,
                  'jenis_artikel': jenisArtikelController.text,
                  'tahun': tahunController.text, // Kirim sebagai string
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