import 'package:flutter/material.dart';
// Import model yang sudah diperbarui
import 'package:gkm_mobile/models/kualitas_kepuasan.dart'; // Pastikan nama file ini sesuai
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Ubah nama kelas widget
class KinerjaKepuasanScreen extends StatefulWidget { // Nama kelas widget diubah
  final TahunAjaran tahunAjaran;
  const KinerjaKepuasanScreen({Key? key, required this.tahunAjaran}) // Nama constructor diubah
      : super(key: key);
  @override
  // Ubah nama state class
  KinerjaKepuasanState createState() => KinerjaKepuasanState(); // Nama state diubah
}

// Ubah nama state class
class KinerjaKepuasanState extends State<KinerjaKepuasanScreen> { // Nama state diubah

  // Tipe list menggunakan model Kinerja_Kepuasan
  List<kualitas_kepuasan> dataList = [];
  ApiService apiService = ApiService();
  // Sesuaikan nama menu dan sub-menu
  String menuName = "Kepuasan Mahasiswa"; // Contoh
  String subMenuName = "Kepuasan"; // Sesuai nama kelas dan konteks
  String endPoint = "kepuasan-mahasiswa"; // Endpoint sesuai nama kelas
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
      // Menggunakan model Kinerja_Kepuasan
      final data = await apiService.getData(
          kualitas_kepuasan.fromJson, endPoint); // Menggunakan Kinerja_Kepuasan.fromJson
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
      // Menggunakan model Kinerja_Kepuasan
      await apiService.postData(
        kualitas_kepuasan.fromJson, newData, endPoint); // Menggunakan Kinerja_Kepuasan.fromJson
      _fetchData(); // Refresh data setelah berhasil menambah
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil ditambahkan!')),
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
        const SnackBar(content: Text('Data berhasil dihapus!')),
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
      // Menggunakan model Kinerja_Kepuasan
      await apiService.updateData(
          kualitas_kepuasan.fromJson, id, updatedData, endPoint); // Menggunakan Kinerja_Kepuasan.fromJson
      _fetchData(); // Refresh data setelah berhasil mengedit
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diupdate!')),
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
                  const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                // Input Search (Optional, implement search logic if needed)
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
                          // Implement search logic here
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
                          // Header Tabel - Sesuaikan dengan field di Kinerja_Kepuasan
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _headerCell("No", 50),
                                _headerCell("Aspek Penilaian", 150),
                                _headerCell("Sangat Baik", 100),
                                _headerCell("Baik", 100),
                                _headerCell("Cukup", 100),
                                _headerCell("Kurang", 100),
                                _headerCell("Rencana Tindakan", 200),
                                _headerCell("Tahun", 80),
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),

                          // Isi Data - Sesuaikan dengan field di Kinerja_Kepuasan
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50), // No
                              1: FixedColumnWidth(150), // Aspek Penilaian
                              2: FixedColumnWidth(100), // Sangat Baik
                              3: FixedColumnWidth(100), // Baik
                              4: FixedColumnWidth(100), // Cukup
                              5: FixedColumnWidth(100), // Kurang
                              6: FixedColumnWidth(200), // Rencana Tindakan
                              7: FixedColumnWidth(80), // Tahun
                              8: FixedColumnWidth(50), // Aksi
                            },
                            children: dataList.asMap().entries.map((entry) {
                              int index = entry.key;
                             kualitas_kepuasan data = entry.value; // Menggunakan model
                              return TableRow(
                                children: [
                                  // Nomor
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text((index + 1).toString())),
                                    ),
                                  ),
                                  // Aspek Penilaian
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.aspek_penilaian)),
                                    ),
                                  ),
                                  // Tingkat Kepuasan Sangat Baik
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.tingkat_kepuasan_sangat_baik)),
                                    ),
                                  ),
                                   // Tingkat Kepuasan Baik
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.tingkat_kepuasan_baik)),
                                    ),
                                  ),
                                   // Tingkat Kepuasan Cukup
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.tingkat_kepuasan_cukup)),
                                    ),
                                  ),
                                   // Tingkat Kepuasan Kurang
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.tingkat_kepuasan_kurang)),
                                    ),
                                  ),
                                   // Rencana Tindakan
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.rencana_tindakan)),
                                    ),
                                  ),
                                  // Tahun
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
                                        icon: const Icon(Icons.more_vert,
                                            color: Colors.black87),
                                        onSelected: (String choice) {
                                          if (choice == "Edit") {
                                            // Pastikan ID data ada sebelum mengedit
                                            if (data.id != null) {
                                               _showEditDialog(data.id!, {
                                                'aspek_penilaian': data.aspek_penilaian,
                                                'tingkat_kepuasan_sangat_baik': data.tingkat_kepuasan_sangat_baik,
                                                'tingkat_kepuasan_baik': data.tingkat_kepuasan_baik,
                                                'tingkat_kepuasan_cukup': data.tingkat_kepuasan_cukup,
                                                'tingkat_kepuasan_kurang': data.tingkat_kepuasan_kurang,
                                                'rencana_tindakan': data.rencana_tindakan,
                                                'tahun': data.tahun,
                                              });
                                            } else {
                                               ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('ID data tidak ditemukan untuk diedit.')),
                                              );
                                            }
                                          } else if (choice == "Hapus") {
                                             // Pastikan ID data ada sebelum menghapus
                                             if (data.id != null) {
                                                _deleteData(data.id!);
                                             } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('ID data tidak ditemukan untuk dihapus.')),
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
    final TextEditingController aspekPenilaianController = TextEditingController();
    final TextEditingController tingkatKepuasanSangatBaikController = TextEditingController();
    final TextEditingController tingkatKepuasanBaikController = TextEditingController();
    final TextEditingController tingkatKepuasanCukupController = TextEditingController();
    final TextEditingController tingkatKepuasanKurangController = TextEditingController();
    final TextEditingController rencanaTindakanController = TextEditingController();
    final TextEditingController tahunController = TextEditingController();


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data Kepuasan'), // Judul disesuaikan
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Agar dialog menyesuaikan konten
              children: [
                TextField(
                    controller: aspekPenilaianController,
                    decoration: const InputDecoration(labelText: 'Aspek Penilaian')),
                 TextField(
                    controller: tingkatKepuasanSangatBaikController,
                     keyboardType: TextInputType.number, // Asumsi input angka/persentase
                    decoration: const InputDecoration(labelText: 'Tingkat Kepuasan Sangat Baik (%)')),
                 TextField(
                    controller: tingkatKepuasanBaikController,
                     keyboardType: TextInputType.number, // Asumsi input angka/persentase
                    decoration: const InputDecoration(labelText: 'Tingkat Kepuasan Baik (%)')),
                 TextField(
                    controller: tingkatKepuasanCukupController,
                     keyboardType: TextInputType.number, // Asumsi input angka/persentase
                    decoration: const InputDecoration(labelText: 'Tingkat Kepuasan Cukup (%)')),
                 TextField(
                    controller: tingkatKepuasanKurangController,
                     keyboardType: TextInputType.number, // Asumsi input angka/persentase
                    decoration: const InputDecoration(labelText: 'Tingkat Kepuasan Kurang (%)')),
                 TextField(
                    controller: rencanaTindakanController,
                    decoration: const InputDecoration(labelText: 'Rencana Tindakan')),
                 TextField(
                    controller: tahunController,
                     keyboardType: TextInputType.number, // Input angka untuk tahun
                    decoration: const InputDecoration(labelText: 'Tahun')),
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
                // Validasi sederhana sebelum mengirim
                if (aspekPenilaianController.text.isEmpty || tingkatKepuasanSangatBaikController.text.isEmpty || tingkatKepuasanBaikController.text.isEmpty || tingkatKepuasanCukupController.text.isEmpty || tingkatKepuasanKurangController.text.isEmpty || rencanaTindakanController.text.isEmpty || tahunController.text.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Semua field harus diisi.')),
                   );
                   return; // Jangan lanjutkan jika ada field yang kosong
                }

                 // Coba parse nilai kepuasan menjadi string (sesuai model)
                 String sangatBaik = tingkatKepuasanSangatBaikController.text;
                 String baik = tingkatKepuasanBaikController.text;
                 String cukup = tingkatKepuasanCukupController.text;
                 String kurang = tingkatKepuasanKurangController.text;
                 String tahun = tahunController.text;


                _addData({
                  'user_id': userId,
                  // 'tahun_ajaran_id': widget.tahunAjaran.id, // Cek apakah backend butuh tahun_ajaran_id di endpoint ini
                  'aspek_penilaian': aspekPenilaianController.text,
                  'tingkat_kepuasan_sangat_baik': sangatBaik, // Kirim sebagai string
                  'tingkat_kepuasan_baik': baik, // Kirim sebagai string
                  'tingkat_kepuasan_cukup': cukup, // Kirim sebagai string
                  'tingkat_kepuasan_kurang': kurang, // Kirim sebagai string
                  'rencana_tindakan': rencanaTindakanController.text,
                  'tahun': tahun, // Kirim sebagai string
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

  void _showEditDialog(int id, Map<String, dynamic> currentData) {
     // Controllers untuk field dari struktur data baru
    final TextEditingController aspekPenilaianController =
        TextEditingController(text: currentData['aspek_penilaian']?.toString() ?? '');
    final TextEditingController tingkatKepuasanSangatBaikController =
        TextEditingController(text: currentData['tingkat_kepuasan_sangat_baik']?.toString() ?? '');
    final TextEditingController tingkatKepuasanBaikController =
        TextEditingController(text: currentData['tingkat_kepuasan_baik']?.toString() ?? '');
    final TextEditingController tingkatKepuasanCukupController =
        TextEditingController(text: currentData['tingkat_kepuasan_cukup']?.toString() ?? '');
    final TextEditingController tingkatKepuasanKurangController =
        TextEditingController(text: currentData['tingkat_kepuasan_kurang']?.toString() ?? '');
    final TextEditingController rencanaTindakanController =
        TextEditingController(text: currentData['rencana_tindakan']?.toString() ?? '');
    final TextEditingController tahunController =
        TextEditingController(text: currentData['tahun']?.toString() ?? '');


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Kepuasan'), // Judul disesuaikan
          content: SingleChildScrollView(
            child: Column(
               mainAxisSize: MainAxisSize.min, // Agar dialog menyesuaikan konten
              children: [
                 TextField(
                    controller: aspekPenilaianController,
                    decoration: const InputDecoration(labelText: 'Aspek Penilaian')),
                 TextField(
                    controller: tingkatKepuasanSangatBaikController,
                     keyboardType: TextInputType.number, // Asumsi input angka/persentase
                    decoration: const InputDecoration(labelText: 'Tingkat Kepuasan Sangat Baik (%)')),
                 TextField(
                    controller: tingkatKepuasanBaikController,
                     keyboardType: TextInputType.number, // Asumsi input angka/persentase
                    decoration: const InputDecoration(labelText: 'Tingkat Kepuasan Baik (%)')),
                 TextField(
                    controller: tingkatKepuasanCukupController,
                     keyboardType: TextInputType.number, // Asumsi input angka/persentase
                    decoration: const InputDecoration(labelText: 'Tingkat Kepuasan Cukup (%)')),
                 TextField(
                    controller: tingkatKepuasanKurangController,
                     keyboardType: TextInputType.number, // Asumsi input angka/persentase
                    decoration: const InputDecoration(labelText: 'Tingkat Kepuasan Kurang (%)')),
                 TextField(
                    controller: rencanaTindakanController,
                    decoration: const InputDecoration(labelText: 'Rencana Tindakan')),
                 TextField(
                    controller: tahunController,
                     keyboardType: TextInputType.number, // Input angka untuk tahun
                    decoration: const InputDecoration(labelText: 'Tahun')),
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
                 // Validasi sederhana sebelum mengirim
                 if (aspekPenilaianController.text.isEmpty || tingkatKepuasanSangatBaikController.text.isEmpty || tingkatKepuasanBaikController.text.isEmpty || tingkatKepuasanCukupController.text.isEmpty || tingkatKepuasanKurangController.text.isEmpty || rencanaTindakanController.text.isEmpty || tahunController.text.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Semua field harus diisi.')),
                   );
                   return; // Jangan lanjutkan jika ada field yang kosong
                }

                 // Coba parse nilai kepuasan menjadi string (sesuai model)
                 String sangatBaik = tingkatKepuasanSangatBaikController.text;
                 String baik = tingkatKepuasanBaikController.text;
                 String cukup = tingkatKepuasanCukupController.text;
                 String kurang = tingkatKepuasanKurangController.text;
                 String tahun = tahunController.text;

                _editData(id, {
                  'aspek_penilaian': aspekPenilaianController.text,
                  'tingkat_kepuasan_sangat_baik': sangatBaik, // Kirim sebagai string
                  'tingkat_kepuasan_baik': baik, // Kirim sebagai string
                  'tingkat_kepuasan_cukup': cukup, // Kirim sebagai string
                  'tingkat_kepuasan_kurang': kurang, // Kirim sebagai string
                  'rencana_tindakan': rencanaTindakanController.text,
                  'tahun': tahun, // Kirim sebagai string
                  // 'tahun_ajaran_id': widget.tahunAjaran.id, // Cek apakah backend butuh tahun_ajaran_id di endpoint ini saat update
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