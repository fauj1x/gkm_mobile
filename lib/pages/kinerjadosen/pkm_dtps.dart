import 'package:flutter/material.dart';
// Import model baru
import 'package:gkm_mobile/models/kinerja_pkmdtps.dart'; // Sesuaikan nama file jika berbeda
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PkmDTPS extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const PkmDTPS({Key? key, required this.tahunAjaran})
      : super(key: key);
  @override
  PengabdianMasyarakatState createState() => PengabdianMasyarakatState();
}

class PengabdianMasyarakatState extends State<PkmDTPS> {
  // Tingkat options mungkin tidak relevan lagi dengan model baru
  // final List<String> tingkatOptions = ['lokal', 'nasional', 'internasional'];

  // Ganti tipe list dari KerjasamaTridharmaAioModel menjadi PenelitianDTPSSimpleModel
  List<Pkm_DTPS> dataList = [];
  ApiService apiService = ApiService();
  // Sesuaikan nama menu dan sub-menu jika perlu, berdasarkan data yang ditampilkan
  String menuName = "PKM DTPS"; // Contoh: Jika ini bagian dari Kinerja DTPS
  String subMenuName = "Pengabdian Masyarakat"; // Nama sub-menu sesuai kelas
  String endPoint = "kinerja-pkmdtps"; // Endpoint untuk Pengabdian Masyarakat (sesuai kode awal)
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
          Pkm_DTPS.fromJson, endPoint);
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
         Pkm_DTPS.fromJson, newData, endPoint);
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
          Pkm_DTPS.fromJson, id, updatedData, endPoint);
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
                          // Header Tabel - Sesuaikan dengan field di PenelitianDTPSSimpleModel
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _headerCell("No", 50),
                                _headerCell("Jumlah Judul", 150), // Dari model baru
                                _headerCell("Sumber Dana", 200), // Dari model baru
                                _headerCell("Tahun", 100), // Dari model baru
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),

                          // Isi Data - Sesuaikan dengan field di PenelitianDTPSSimpleModel
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50), // No
                              1: FixedColumnWidth(150), // Jumlah Judul
                              2: FixedColumnWidth(200), // Sumber Dana
                              3: FixedColumnWidth(100), // Tahun
                              4: FixedColumnWidth(50), // Aksi
                            },
                            children: dataList.asMap().entries.map((entry) {
                              int index = entry.key;
                              Pkm_DTPS data = entry.value; // Menggunakan model baru
                              return TableRow(
                                children: [
                                  // Nomor
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text((index + 1).toString())),
                                    ),
                                  ),
                                  // Jumlah Judul
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahJudul.toString())), // Ambil dari model baru
                                    ),
                                  ),
                                  // Sumber Dana
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.sumberDana)), // Ambil dari model baru
                                    ),
                                  ),
                                  // Tahun
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.tahun_penelitian)), // Ambil dari model baru
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
                                                'jumlah_judul': data.jumlahJudul,
                                                'sumber_dana': data.sumberDana,
                                                'tahun_penelitian': data.tahun_penelitian,
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

  Widget _emptyCell(double width) {
    return Container(width: width, height: 40);
  }

  void _showAddDialog() {
    // Controllers untuk field dari PenelitianDTPSSimpleModel
    final TextEditingController jumlahJudulController = TextEditingController();
    final TextEditingController sumberDanaController = TextEditingController();
    final TextEditingController tahunController = TextEditingController();


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pkm DTPS'), // Judul lebih spesifik
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Agar dialog menyesuaikan konten
              children: [
                TextField(
                    controller: jumlahJudulController,
                    keyboardType: TextInputType.number, // Input angka
                    decoration: InputDecoration(labelText: 'Jumlah Judul')),
                TextField(
                    controller: sumberDanaController,
                    decoration: InputDecoration(labelText: 'Sumber Dana')),
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
                if (jumlahJudulController.text.isEmpty || sumberDanaController.text.isEmpty || tahunController.text.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Semua field harus diisi.')),
                   );
                   return; // Jangan lanjutkan jika ada field yang kosong
                }

                 // Coba parse jumlahJudul dan tahun menjadi integer
                 int? jumlahJudul = int.tryParse(jumlahJudulController.text);
                 // Tahun bisa berupa string atau integer tergantung kebutuhan backend
                 // Kita kirim sebagai string sesuai model simple
                 String tahun = tahunController.text;


                 if (jumlahJudul == null) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Jumlah Judul harus berupa angka.')),
                     );
                     return;
                 }


                _addData({
                  'user_id': userId,
                  // 'tahun_ajaran_id': widget.tahunAjaran.id, // Cek apakah backend butuh tahun_ajaran_id di endpoint ini
                  'jumlah_judul': jumlahJudul, // Kirim sebagai integer
                  'sumber_dana': sumberDanaController.text,
                  'tahun_penelitian': tahun, // Kirim sebagai string
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
     // Controllers untuk field dari PenelitianDTPSSimpleModel
    final TextEditingController jumlahJudulController =
        TextEditingController(text: currentData['jumlah_judul']?.toString() ?? ''); // Pastikan diubah ke string
    final TextEditingController sumberDanaController =
        TextEditingController(text: currentData['sumber_dana']?.toString() ?? '');
    final TextEditingController tahunController =
        TextEditingController(text: currentData['tahun_penelitian']?.toString() ?? ''); // Pastikan diubah ke string


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Data Pengabdian Masyarakat'), // Judul lebih spesifik
          content: SingleChildScrollView(
            child: Column(
               mainAxisSize: MainAxisSize.min, // Agar dialog menyesuaikan konten
              children: [
                 TextField(
                    controller: jumlahJudulController,
                    keyboardType: TextInputType.number, // Input angka
                    decoration: InputDecoration(labelText: 'Jumlah Judul')),
                TextField(
                    controller: sumberDanaController,
                    decoration: InputDecoration(labelText: 'Sumber Dana')),
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
                 if (jumlahJudulController.text.isEmpty || sumberDanaController.text.isEmpty || tahunController.text.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Semua field harus diisi.')),
                   );
                   return; // Jangan lanjutkan jika ada field yang kosong
                }

                 // Coba parse jumlahJudul dan tahun menjadi integer
                 int? jumlahJudul = int.tryParse(jumlahJudulController.text);
                 String tahun = tahunController.text; // Kirim sebagai string

                 if (jumlahJudul == null) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Jumlah Judul harus berupa angka.')),
                     );
                     return;
                 }

                _editData(id, {
                  'jumlah_judul': jumlahJudul, // Kirim sebagai integer
                  'sumber_dana': sumberDanaController.text,
                  'tahun_penelitian': tahun, // Kirim sebagai string
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