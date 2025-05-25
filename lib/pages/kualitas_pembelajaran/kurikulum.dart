import 'package:flutter/material.dart';
// Import model yang sudah diperbarui
import 'package:gkm_mobile/models/kualitas_kurikulum.dart'; // Pastikan nama file ini sesuai
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Ubah nama kelas widget
class kurikulum extends StatefulWidget { // Nama kelas widget diubah
  final TahunAjaran tahunAjaran;
  const kurikulum({Key? key, required this.tahunAjaran}) // Nama constructor diubah
      : super(key: key);
  @override
  // Ubah nama state class
  KinerjaMataKuliahState createState() => KinerjaMataKuliahState(); // Nama state diubah
}

// Ubah nama state class
class KinerjaMataKuliahState extends State<kurikulum> { // Nama state diubah

  // Tipe list menggunakan model Kinerja_Mata_Kuliah
  List<KualitasKurikulum> dataList = [];
  ApiService apiService = ApiService();
  // Sesuaikan nama menu dan sub-menu
  String menuName = "Kurikulum"; // Contoh
  String subMenuName = "Mata Kuliah"; // Sesuai nama kelas dan konteks
  String endPoint = "kurikulum-pembelajaran"; // Endpoint sesuai nama kelas
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
      // Menggunakan model Kinerja_Mata_Kuliah
      final data = await apiService.getData(
          KualitasKurikulum.fromJson, endPoint); // Menggunakan Kinerja_Mata_Kuliah.fromJson
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
      // Menggunakan model Kinerja_Mata_Kuliah
      await apiService.postData(
         KualitasKurikulum.fromJson, newData, endPoint); // Menggunakan Kinerja_Mata_Kuliah.fromJson
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
      // Menggunakan model Kinerja_Mata_Kuliah
      await apiService.updateData(
          KualitasKurikulum.fromJson, id, updatedData, endPoint); // Menggunakan Kinerja_Mata_Kuliah.fromJson
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
                          // Header Tabel - Sesuaikan dengan field di Kinerja_Mata_Kuliah
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _headerCell("No", 50),
                                _headerCell("Nama Mata Kuliah", 150),
                                _headerCell("Kode Mata Kuliah", 100),
                                _headerCell("Kompetensi", 150),
                                _headerCell("SKS Kuliah", 80),
                                _headerCell("SKS Seminar", 80),
                                _headerCell("SKS Praktikum", 80),
                                _headerCell("Konversi SKS", 100),
                                _headerCell("Semester", 80),
                                _headerCell("Metode Pembelajaran", 150),
                                _headerCell("Dokumen", 100),
                                _headerCell("Unit Penyelenggara", 150),
                                // Capaian Kuliah bisa disingkat atau ditampilkan di detail
                                _headerCell("Capaian Sikap", 120),
                                _headerCell("Capaian Pengetahuan", 120),
                                _headerCell("Capaian K. Umum", 120),
                                _headerCell("Capaian K. Khusus", 120),
                                _headerCell("Tahun", 80),
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),

                          // Isi Data - Sesuaikan dengan field di Kinerja_Mata_Kuliah
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50), // No
                              1: FixedColumnWidth(150), // Nama Mata Kuliah
                              2: FixedColumnWidth(100), // Kode Mata Kuliah
                              3: FixedColumnWidth(150), // Kompetensi
                              4: FixedColumnWidth(80), // SKS Kuliah
                              5: FixedColumnWidth(80), // SKS Seminar
                              6: FixedColumnWidth(80), // SKS Praktikum
                              7: FixedColumnWidth(100), // Konversi SKS
                              8: FixedColumnWidth(80), // Semester
                              9: FixedColumnWidth(150), // Metode Pembelajaran
                              10: FixedColumnWidth(100), // Dokumen
                              11: FixedColumnWidth(150), // Unit Penyelenggara
                              12: FixedColumnWidth(120), // Capaian Sikap
                              13: FixedColumnWidth(120), // Capaian Pengetahuan
                              14: FixedColumnWidth(120), // Capaian K. Umum
                              15: FixedColumnWidth(120), // Capaian K. Khusus
                              16: FixedColumnWidth(80), // Tahun
                              17: FixedColumnWidth(50), // Aksi
                            },
                            children: dataList.asMap().entries.map((entry) {
                              int index = entry.key;
                              KualitasKurikulum data = entry.value; // Menggunakan model
                              return TableRow(
                                children: [
                                  // Nomor
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text((index + 1).toString())),
                                    ),
                                  ),
                                  // Nama Mata Kuliah
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.namaMataKuliah)),
                                    ),
                                  ),
                                  // Kode Mata Kuliah
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.kodeMataKuliah)),
                                    ),
                                  ),
                                   // Kompetensi
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.mataKuliahKompetensi == true ? "ya":"tidak")),
                                    ),
                                  ),
                                   // SKS Kuliah
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.sksKuliah.toString())),
                                    ),
                                  ),
                                   // SKS Seminar
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.sksSeminar.toString())),
                                    ),
                                  ),
                                   // SKS Praktikum
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.sksPraktikum.toString())),
                                    ),
                                  ),
                                   // Konversi SKS
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.konversiSks.toString())),
                                    ),
                                  ),
                                   // Semester
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.semester == true ? "ya":"tidak")),
                                    ),
                                  ),
                                   // Metode Pembelajaran
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.metodePembelajaran == true ? "ya":"tidak")),
                                    ),
                                  ),
                                   // Dokumen
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.dokumen??'')),
                                    ),
                                  ),
                                   // Unit Penyelenggara
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.unitPenyelenggara == true ? "ya":"tidak")),
                                    ),
                                  ),
                                   // Capaian Kuliah Sikap
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.capaianKuliahSikap == true ? "ya":"tidak")),
                                    ),
                                  ),
                                   // Capaian Kuliah Pengetahuan
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.capaianKuliahPengetahuan == true ? "ya":"tidak")),
                                    ),
                                  ),
                                   // Capaian Kuliah Keterampilan Umum
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.capaianKuliahKeterampilanUmum == true ? "ya":"tidak")),
                                    ),
                                  ),
                                   // Capaian Kuliah Keterampilan Khusus
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.capaianKuliahKeterampilanKhusus == true ? "ya":"tidak")),
                                    ),
                                  ),
                                  // Tahun
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
                                        icon: const Icon(Icons.more_vert,
                                            color: Colors.black87),
                                        onSelected: (String choice) {
                                          if (choice == "Edit") {
                                            // Pastikan ID data ada sebelum mengedit
                                            if (data.id != null) {
                                               _showEditDialog(data.id!, {
                                                'nama_mata_kuliah': data.namaMataKuliah,
                                                'kode_mata_kuliah': data.kodeMataKuliah,
                                                'mata_kuliah_kompetensi': data.mataKuliahKompetensi,
                                                'sks_kuliah': data.sksKuliah,
                                                'sks_seminar': data.sksSeminar,
                                                'sks_praktikum': data.sksPraktikum,
                                                'konversi_sks': data.konversiSks,
                                                'semester': data.semester,
                                                'metode_pembelajaran': data.metodePembelajaran,
                                                'dokumen': data.dokumen,
                                                'unit_penyelenggara': data.unitPenyelenggara,
                                                'capaian_kuliah_sikap': data.capaianKuliahSikap,
                                                'capaian_kuliah_pengetahuan': data.capaianKuliahPengetahuan,
                                                'capaian_kuliah_keterampilan_umum': data.capaianKuliahKeterampilanUmum,
                                                'capaian_kuliah_keterampilan_khusus': data.capaianKuliahKeterampilanKhusus,
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
    final TextEditingController namaMataKuliahController = TextEditingController();
    final TextEditingController kodeMataKuliahController = TextEditingController();
    final TextEditingController mataKuliahKompetensiController = TextEditingController();
    final TextEditingController sksKuliahController = TextEditingController();
    final TextEditingController sksSeminarController = TextEditingController();
    final TextEditingController sksPraktikumController = TextEditingController();
    final TextEditingController konversiSksController = TextEditingController();
    final TextEditingController semesterController = TextEditingController();
    final TextEditingController metodePembelajaranController = TextEditingController();
    final TextEditingController dokumenController = TextEditingController();
    final TextEditingController unitPenyelenggaraController = TextEditingController();
    final TextEditingController capaianKuliahSikapController = TextEditingController();
    final TextEditingController capaianKuliahPengetahuanController = TextEditingController();
    final TextEditingController capaianKuliahKeterampilanUmumController = TextEditingController();
    final TextEditingController capaianKuliahKeterampilanKhususController = TextEditingController();
    final TextEditingController tahunController = TextEditingController();


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data Mata Kuliah'), // Judul disesuaikan
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Agar dialog menyesuaikan konten
              children: [
                TextField(
                    controller: namaMataKuliahController,
                    decoration: const InputDecoration(labelText: 'Nama Mata Kuliah')),
                TextField(
                    controller: kodeMataKuliahController,
                    decoration: const InputDecoration(labelText: 'Kode Mata Kuliah')),
                 TextField(
                    controller: mataKuliahKompetensiController,
                    decoration: const InputDecoration(labelText: 'Kompetensi Mata Kuliah')),
                 TextField(
                    controller: sksKuliahController,
                     keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'SKS Kuliah')),
                 TextField(
                    controller: sksSeminarController,
                     keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'SKS Seminar')),
                 TextField(
                    controller: sksPraktikumController,
                     keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'SKS Praktikum')),
                 TextField(
                    controller: konversiSksController,
                     keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Konversi SKS')),
                 TextField(
                    controller: semesterController,
                    decoration: const InputDecoration(labelText: 'Semester')),
                 TextField(
                    controller: metodePembelajaranController,
                    decoration: const InputDecoration(labelText: 'Metode Pembelajaran')),
                 TextField(
                    controller: dokumenController,
                    decoration: const InputDecoration(labelText: 'Dokumen (Link/Deskripsi)')),
                 TextField(
                    controller: unitPenyelenggaraController,
                    decoration: const InputDecoration(labelText: 'Unit Penyelenggara')),
                 TextField(
                    controller: capaianKuliahSikapController,
                    decoration: const InputDecoration(labelText: 'Capaian Kuliah Sikap')),
                 TextField(
                    controller: capaianKuliahPengetahuanController,
                    decoration: const InputDecoration(labelText: 'Capaian Kuliah Pengetahuan')),
                 TextField(
                    controller: capaianKuliahKeterampilanUmumController,
                    decoration: const InputDecoration(labelText: 'Capaian Kuliah Keterampilan Umum')),
                 TextField(
                    controller: capaianKuliahKeterampilanKhususController,
                    decoration: const InputDecoration(labelText: 'Capaian Kuliah Keterampilan Khusus')),
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
                if (namaMataKuliahController.text.isEmpty || kodeMataKuliahController.text.isEmpty || mataKuliahKompetensiController.text.isEmpty || sksKuliahController.text.isEmpty || sksSeminarController.text.isEmpty || sksPraktikumController.text.isEmpty || konversiSksController.text.isEmpty || semesterController.text.isEmpty || metodePembelajaranController.text.isEmpty || dokumenController.text.isEmpty || unitPenyelenggaraController.text.isEmpty || capaianKuliahSikapController.text.isEmpty || capaianKuliahPengetahuanController.text.isEmpty || capaianKuliahKeterampilanUmumController.text.isEmpty || capaianKuliahKeterampilanKhususController.text.isEmpty || tahunController.text.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Semua field harus diisi.')),
                   );
                   return; // Jangan lanjutkan jika ada field yang kosong
                }

                 // Coba parse SKS dan Konversi SKS menjadi integer
                 int? sksKuliah = int.tryParse(sksKuliahController.text);
                 int? sksSeminar = int.tryParse(sksSeminarController.text);
                 int? sksPraktikum = int.tryParse(sksPraktikumController.text);
                 int? konversiSks = int.tryParse(konversiSksController.text);
                 String tahun = tahunController.text;


                 if (sksKuliah == null || sksSeminar == null || sksPraktikum == null || konversiSks == null) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('Field SKS dan Konversi SKS harus berupa angka.')),
                     );
                     return;
                 }

                _addData({
                  'user_id': userId,
                  // 'tahun_ajaran_id': widget.tahunAjaran.id, // Cek apakah backend butuh tahun_ajaran_id di endpoint ini
                  'nama_mata_kuliah': namaMataKuliahController.text,
                  'kode_mata_kuliah': kodeMataKuliahController.text,
                  'mata_kuliah_kompetensi': mataKuliahKompetensiController.text,
                  'sks_kuliah': sksKuliah, // Kirim sebagai integer
                  'sks_seminar': sksSeminar, // Kirim sebagai integer
                  'sks_praktikum': sksPraktikum, // Kirim sebagai integer
                  'konversi_sks': konversiSks, // Kirim sebagai integer
                  'semester': semesterController.text,
                  'metode_pembelajaran': metodePembelajaranController.text,
                  'dokumen': dokumenController.text,
                  'unit_penyelenggara': unitPenyelenggaraController.text,
                  'capaian_kuliah_sikap': capaianKuliahSikapController.text,
                  'capaian_kuliah_pengetahuan': capaianKuliahPengetahuanController.text,
                  'capaian_kuliah_keterampilan_umum': capaianKuliahKeterampilanUmumController.text,
                  'capaian_kuliah_keterampilan_khusus': capaianKuliahKeterampilanKhususController.text,
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
    final TextEditingController namaMataKuliahController =
        TextEditingController(text: currentData['nama_mata_kuliah']?.toString() ?? '');
    final TextEditingController kodeMataKuliahController =
        TextEditingController(text: currentData['kode_mata_kuliah']?.toString() ?? '');
    final TextEditingController mataKuliahKompetensiController =
        TextEditingController(text: currentData['mata_kuliah_kompetensi']?.toString() ?? '');
    final TextEditingController sksKuliahController =
        TextEditingController(text: currentData['sks_kuliah']?.toString() ?? '');
    final TextEditingController sksSeminarController =
        TextEditingController(text: currentData['sks_seminar']?.toString() ?? '');
    final TextEditingController sksPraktikumController =
        TextEditingController(text: currentData['sks_praktikum']?.toString() ?? '');
    final TextEditingController konversiSksController =
        TextEditingController(text: currentData['konversi_sks']?.toString() ?? '');
    final TextEditingController semesterController =
        TextEditingController(text: currentData['semester']?.toString() ?? '');
    final TextEditingController metodePembelajaranController =
        TextEditingController(text: currentData['metode_pembelajaran']?.toString() ?? '');
    final TextEditingController dokumenController =
        TextEditingController(text: currentData['dokumen']?.toString() ?? '');
    final TextEditingController unitPenyelenggaraController =
        TextEditingController(text: currentData['unit_penyelenggara']?.toString() ?? '');
    final TextEditingController capaianKuliahSikapController =
        TextEditingController(text: currentData['capaian_kuliah_sikap']?.toString() ?? '');
    final TextEditingController capaianKuliahPengetahuanController =
        TextEditingController(text: currentData['capaian_kuliah_pengetahuan']?.toString() ?? '');
    final TextEditingController capaianKuliahKeterampilanUmumController =
        TextEditingController(text: currentData['capaian_kuliah_keterampilan_umum']?.toString() ?? '');
    final TextEditingController capaianKuliahKeterampilanKhususController =
        TextEditingController(text: currentData['capaian_kuliah_keterampilan_khusus']?.toString() ?? '');
    final TextEditingController tahunController =
        TextEditingController(text: currentData['tahun']?.toString() ?? '');


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Mata Kuliah'), // Judul disesuaikan
          content: SingleChildScrollView(
            child: Column(
               mainAxisSize: MainAxisSize.min, // Agar dialog menyesuaikan konten
              children: [
                 TextField(
                    controller: namaMataKuliahController,
                    decoration: const InputDecoration(labelText: 'Nama Mata Kuliah')),
                TextField(
                    controller: kodeMataKuliahController,
                    decoration: const InputDecoration(labelText: 'Kode Mata Kuliah')),
                 TextField(
                    controller: mataKuliahKompetensiController,
                    decoration: const InputDecoration(labelText: 'Kompetensi Mata Kuliah')),
                 TextField(
                    controller: sksKuliahController,
                     keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'SKS Kuliah')),
                 TextField(
                    controller: sksSeminarController,
                     keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'SKS Seminar')),
                 TextField(
                    controller: sksPraktikumController,
                     keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'SKS Praktikum')),
                 TextField(
                    controller: konversiSksController,
                     keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Konversi SKS')),
                 TextField(
                    controller: semesterController,
                    decoration: const InputDecoration(labelText: 'Semester')),
                 TextField(
                    controller: metodePembelajaranController,
                    decoration: const InputDecoration(labelText: 'Metode Pembelajaran')),
                 TextField(
                    controller: dokumenController,
                    decoration: const InputDecoration(labelText: 'Dokumen (Link/Deskripsi)')),
                 TextField(
                    controller: unitPenyelenggaraController,
                    decoration: const InputDecoration(labelText: 'Unit Penyelenggara')),
                 TextField(
                    controller: capaianKuliahSikapController,
                    decoration: const InputDecoration(labelText: 'Capaian Kuliah Sikap')),
                 TextField(
                    controller: capaianKuliahPengetahuanController,
                    decoration: const InputDecoration(labelText: 'Capaian Kuliah Pengetahuan')),
                 TextField(
                    controller: capaianKuliahKeterampilanUmumController,
                    decoration: const InputDecoration(labelText: 'Capaian Kuliah Keterampilan Umum')),
                 TextField(
                    controller: capaianKuliahKeterampilanKhususController,
                    decoration: const InputDecoration(labelText: 'Capaian Kuliah Keterampilan Khusus')),
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
                 if (namaMataKuliahController.text.isEmpty || kodeMataKuliahController.text.isEmpty || mataKuliahKompetensiController.text.isEmpty || sksKuliahController.text.isEmpty || sksSeminarController.text.isEmpty || sksPraktikumController.text.isEmpty || konversiSksController.text.isEmpty || semesterController.text.isEmpty || metodePembelajaranController.text.isEmpty || dokumenController.text.isEmpty || unitPenyelenggaraController.text.isEmpty || capaianKuliahSikapController.text.isEmpty || capaianKuliahPengetahuanController.text.isEmpty || capaianKuliahKeterampilanUmumController.text.isEmpty || capaianKuliahKeterampilanKhususController.text.isEmpty || tahunController.text.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Semua field harus diisi.')),
                   );
                   return; // Jangan lanjutkan jika ada field yang kosong
                }

                 // Coba parse SKS dan Konversi SKS menjadi integer
                 int? sksKuliah = int.tryParse(sksKuliahController.text);
                 int? sksSeminar = int.tryParse(sksSeminarController.text);
                 int? sksPraktikum = int.tryParse(sksPraktikumController.text);
                 int? konversiSks = int.tryParse(konversiSksController.text);
                 String tahun = tahunController.text;


                 if (sksKuliah == null || sksSeminar == null || sksPraktikum == null || konversiSks == null) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('Field SKS dan Konversi SKS harus berupa angka.')),
                     );
                     return;
                 }


                _editData(id, {
                  'nama_mata_kuliah': namaMataKuliahController.text,
                  'kode_mata_kuliah': kodeMataKuliahController.text,
                  'mata_kuliah_kompetensi': mataKuliahKompetensiController.text,
                  'sks_kuliah': sksKuliah, // Kirim sebagai integer
                  'sks_seminar': sksSeminar, // Kirim sebagai integer
                  'sks_praktikum': sksPraktikum, // Kirim sebagai integer
                  'konversi_sks': konversiSks, // Kirim sebagai integer
                  'semester': semesterController.text,
                  'metode_pembelajaran': metodePembelajaranController.text,
                  'dokumen': dokumenController.text,
                  'unit_penyelenggara': unitPenyelenggaraController.text,
                  'capaian_kuliah_sikap': capaianKuliahSikapController.text,
                  'capaian_kuliah_pengetahuan': capaianKuliahPengetahuanController.text,
                  'capaian_kuliah_keterampilan_umum': capaianKuliahKeterampilanUmumController.text,
                  'capaian_kuliah_keterampilan_khusus': capaianKuliahKeterampilanKhususController.text,
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