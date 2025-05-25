import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/kualitas_kurikulum.dart'; // Pastikan path ini benar
import 'package:gkm_mobile/models/tahun_ajaran.dart'; // Pastikan path ini benar
import 'package:gkm_mobile/services/api_services.dart'; // Pastikan path ini benar
import 'package:shared_preferences/shared_preferences.dart';

// Kelas widget untuk tampilan Mata Kuliah
class MataKuliahScreen extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const MataKuliahScreen({Key? key, required this.tahunAjaran})
      : super(key: key);

  @override
  MataKuliahState createState() => MataKuliahState();
}

// State untuk MataKuliahScreen
class MataKuliahState extends State<MataKuliahScreen> {
  // List untuk menyimpan data MataKuliah
  List<MataKuliah> dataList = [];
  ApiService apiService = ApiService();

  // Informasi menu dan endpoint API
  String menuName = "Kurikulum";
  String subMenuName = "";
  String endPoint = "kurikulum-pembelajaran";
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserId(); // Ambil userId saat inisialisasi
    _fetchData(); // Ambil data dari API
  }

  // Mengambil userId dari SharedPreferences
  Future<void> _fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = int.parse(prefs.getString('id') ?? '0');
    });
  }

  // Mengambil data Mata Kuliah dari API
  Future<void> _fetchData() async {
    try {
      final data = await apiService.getData(MataKuliah.fromJson, endPoint);
      setState(() {
        dataList = data;
      });
    } catch (e) {
      print("Error fetching data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data: ${e.toString()}')),
      );
    }
  }

  // Menambah data Mata Kuliah baru ke API
  Future<void> _addData(Map<String, dynamic> newData) async {
    try {
      await apiService.postData(MataKuliah.fromJson, newData, endPoint);
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

  // Menghapus data Mata Kuliah dari API berdasarkan ID
  Future<void> _deleteData(int id) async {
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

  // Mengedit data Mata Kuliah di API berdasarkan ID
  Future<void> _editData(int id, Map<String, dynamic> updatedData) async {
    try {
      await apiService.updateData(MataKuliah.fromJson, id, updatedData, endPoint);
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
                // Input Search (Opsional, implementasikan logika pencarian jika diperlukan)
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
                          // Implementasikan logika pencarian di sini
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
                          // Header Tabel - Sesuaikan dengan field di MataKuliah
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _headerCell("No", 50),
                                _headerCell("Nama Mata Kuliah", 180),
                                _headerCell("Kode", 100),
                                _headerCell("Kompetensi", 100),
                                _headerCell("SKS Kuliah", 80),
                                _headerCell("SKS Seminar", 80),
                                _headerCell("SKS Praktikum", 80),
                                _headerCell("Konversi SKS", 80),
                                _headerCell("Total SKS", 80), // Menampilkan field 'sks'
                                _headerCell("Semester", 80),
                                _headerCell("Metode Pembelajaran", 150),
                                _headerCell("Dokumen", 100),
                                _headerCell("Unit Penyelenggara", 150),
                                _headerCell("Sikap", 60),
                                _headerCell("Pengetahuan", 60),
                                _headerCell("Keterampilan Umum", 60),
                                _headerCell("Keterampilan Khusus", 60),
                                _headerCell("Tahun", 80),
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),

                          // Isi Data - Sesuaikan dengan field di MataKuliah
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50), // No
                              1: FixedColumnWidth(180), // Nama Mata Kuliah
                              2: FixedColumnWidth(100), // Kode
                              3: FixedColumnWidth(100), // Kompetensi
                              4: FixedColumnWidth(80), // SKS Kuliah
                              5: FixedColumnWidth(80), // SKS Seminar
                              6: FixedColumnWidth(80), // SKS Praktikum
                              7: FixedColumnWidth(80), // Konversi SKS
                              8: FixedColumnWidth(80), // Total SKS
                              9: FixedColumnWidth(80), // Semester
                              10: FixedColumnWidth(150), // Metode Pembelajaran
                              11: FixedColumnWidth(100), // Dokumen
                              12: FixedColumnWidth(150), // Unit Penyelenggara
                              13: FixedColumnWidth(60), // Sikap
                              14: FixedColumnWidth(60), // Pengetahuan
                              15: FixedColumnWidth(60), // Keterampilan Umum
                              16: FixedColumnWidth(60), // Keterampilan Khusus
                              17: FixedColumnWidth(80), // Tahun
                              18: FixedColumnWidth(50), // Aksi
                            },
                            children: dataList.asMap().entries.map((entry) {
                              int index = entry.key;
                              MataKuliah data = entry.value; // Menggunakan model MataKuliah
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
                                      child: Text(data.namaMataKuliah),
                                    ),
                                  ),
                                  // Kode Mata Kuliah
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(data.kodeMataKuliah),
                                    ),
                                  ),
                                  // Mata Kuliah Kompetensi
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.mataKuliahKompetensi == true ? 'Ya' : 'Tidak')),
                                    ),
                                  ),
                                  // SKS Kuliah
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.sksKuliah?.toString() ?? '-')),
                                    ),
                                  ),
                                  // SKS Seminar
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.sksSeminar?.toString() ?? '-')),
                                    ),
                                  ),
                                  // SKS Praktikum
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.sksPraktikum?.toString() ?? '-')),
                                    ),
                                  ),
                                  // Konversi SKS
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.konversiSks?.toString() ?? '-')),
                                    ),
                                  ),
                                  // Total SKS (dari field 'sks')
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.sks?.toString() ?? '-')),
                                    ),
                                  ),
                                  // Semester
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.semester?.toString() ?? '-')), // Nullable
                                    ),
                                  ),
                                  // Metode Pembelajaran
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(data.metodePembelajaran ?? '-'),
                                    ),
                                  ),
                                  // Dokumen
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(data.dokumen ?? '-'),
                                    ),
                                  ),
                                  // Unit Penyelenggara
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(data.unitPenyelenggara ?? '-'),
                                    ),
                                  ),
                                  // Capaian Kuliah Sikap
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.capaianKuliahSikap == true ? 'Ya' : 'Tidak')),
                                    ),
                                  ),
                                  // Capaian Kuliah Pengetahuan
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.capaianKuliahPengetahuan == true ? 'Ya' : 'Tidak')),
                                    ),
                                  ),
                                  // Capaian Kuliah Keterampilan Umum
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.capaianKuliahKeterampilanUmum == true ? 'Ya' : 'Tidak')),
                                    ),
                                  ),
                                  // Capaian Kuliah Keterampilan Khusus
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.capaianKuliahKeterampilanKhusus == true ? 'Ya' : 'Tidak')),
                                    ),
                                  ),
                                  // Tahun
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.tahun ?? '-')),
                                    ),
                                  ),
                                  // Tombol Aksi (Edit/Hapus)
                                  TableCell(
                                    child: Center(
                                      child: PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert,
                                            color: Colors.black87),
                                        onSelected: (String choice) {
                                          if (choice == "Edit") {
                                            if (data.id != null) {
                                              _showEditDialog(data.id, {
                                                'nama_mata_kuliah': data.namaMataKuliah,
                                                'kode_mata_kuliah': data.kodeMataKuliah,
                                                'mata_kuliah_kompetensi': data.mataKuliahKompetensi,
                                                'sks_kuliah': data.sksKuliah,
                                                'sks_seminar': data.sksSeminar,
                                                'sks_praktikum': data.sksPraktikum,
                                                'konversi_sks': data.konversiSks,
                                                'sks': data.sks,
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
                                            if (data.id != null) {
                                              _deleteData(data.id);
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

          // Tombol Aksi Mengambang (Floating Action Button) untuk menambah data
          Positioned(
            bottom: 24,
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

  // Widget helper untuk sel header tabel
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

  // Menampilkan dialog untuk menambah data Mata Kuliah baru
  void _showAddDialog() {
    final TextEditingController namaMataKuliahController = TextEditingController();
    final TextEditingController kodeMataKuliahController = TextEditingController();
    bool mataKuliahKompetensi = false;
    final TextEditingController sksKuliahController = TextEditingController();
    final TextEditingController sksSeminarController = TextEditingController();
    final TextEditingController sksPraktikumController = TextEditingController();
    final TextEditingController konversiSksController = TextEditingController();
    final TextEditingController semesterController = TextEditingController();
    final TextEditingController metodePembelajaranController = TextEditingController();
    final TextEditingController dokumenController = TextEditingController();
    final TextEditingController unitPenyelenggaraController = TextEditingController();
    bool capaianKuliahSikap = false;
    bool capaianKuliahPengetahuan = false;
    bool capaianKuliahKeterampilanUmum = false;
    bool capaianKuliahKeterampilanKhusus = false;
    final TextEditingController tahunController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data Mata Kuliah'),
          content: SingleChildScrollView(
            child: StatefulBuilder( // Menggunakan StatefulBuilder untuk memperbarui konten dialog
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: namaMataKuliahController,
                      decoration: const InputDecoration(labelText: 'Nama Mata Kuliah'),
                    ),
                    TextField(
                      controller: kodeMataKuliahController,
                      decoration: const InputDecoration(labelText: 'Kode Mata Kuliah'),
                    ),
                    Row(
                      children: [
                        const Text('Mata Kuliah Kompetensi:'),
                        Checkbox(
                          value: mataKuliahKompetensi,
                          onChanged: (bool? newValue) {
                            setState(() {
                              mataKuliahKompetensi = newValue ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    TextField(
                      controller: sksKuliahController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'SKS Kuliah'),
                    ),
                    TextField(
                      controller: sksSeminarController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'SKS Seminar'),
                    ),
                    TextField(
                      controller: sksPraktikumController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'SKS Praktikum'),
                    ),
                    TextField(
                      controller: konversiSksController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Konversi SKS (Jika Ada)'),
                    ),
                    TextField(
                      controller: semesterController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Semester'),
                    ),
                    TextField(
                      controller: metodePembelajaranController,
                      decoration: const InputDecoration(labelText: 'Metode Pembelajaran'),
                    ),
                    TextField(
                      controller: dokumenController,
                      decoration: const InputDecoration(labelText: 'Dokumen'),
                    ),
                    TextField(
                      controller: unitPenyelenggaraController,
                      decoration: const InputDecoration(labelText: 'Unit Penyelenggara'),
                    ),
                    Row(
                      children: [
                        const Text('Capaian Kuliah Sikap:'),
                        Checkbox(
                          value: capaianKuliahSikap,
                          onChanged: (bool? newValue) {
                            setState(() {
                              capaianKuliahSikap = newValue ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Capaian Kuliah Pengetahuan:'),
                        Checkbox(
                          value: capaianKuliahPengetahuan,
                          onChanged: (bool? newValue) {
                            setState(() {
                              capaianKuliahPengetahuan = newValue ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Capaian Kuliah Keterampilan Umum:'),
                        Checkbox(
                          value: capaianKuliahKeterampilanUmum,
                          onChanged: (bool? newValue) {
                            setState(() {
                              capaianKuliahKeterampilanUmum = newValue ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Capaian Kuliah Keterampilan Khusus:'),
                        Checkbox(
                          value: capaianKuliahKeterampilanKhusus,
                          onChanged: (bool? newValue) {
                            setState(() {
                              capaianKuliahKeterampilanKhusus = newValue ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    TextField(
                      controller: tahunController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Tahun'),
                    ),
                  ],
                );
              },
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
                if (namaMataKuliahController.text.isEmpty ||
                    kodeMataKuliahController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nama dan Kode Mata Kuliah harus diisi.')),
                  );
                  return;
                }

                // Buat objek MataKuliah baru untuk memanfaatkan toJson()
                final newMataKuliah = MataKuliah(
                  id: 0, // ID placeholder untuk data baru
                  userId: userId,
                  namaMataKuliah: namaMataKuliahController.text,
                  kodeMataKuliah: kodeMataKuliahController.text,
                  mataKuliahKompetensi: mataKuliahKompetensi,
                  sksKuliah: int.tryParse(sksKuliahController.text),
                  sksSeminar: int.tryParse(sksSeminarController.text),
                  sksPraktikum: int.tryParse(sksPraktikumController.text),
                  konversiSks: int.tryParse(konversiSksController.text),
                  sks: null, // Akan dihitung di dalam toJson()
                  semester: int.tryParse(semesterController.text),
                  metodePembelajaran: metodePembelajaranController.text.isEmpty ? null : metodePembelajaranController.text,
                  dokumen: dokumenController.text.isEmpty ? null : dokumenController.text,
                  unitPenyelenggara: unitPenyelenggaraController.text.isEmpty ? null : unitPenyelenggaraController.text,
                  capaianKuliahSikap: capaianKuliahSikap,
                  capaianKuliahPengetahuan: capaianKuliahPengetahuan,
                  capaianKuliahKeterampilanUmum: capaianKuliahKeterampilanUmum,
                  capaianKuliahKeterampilanKhusus: capaianKuliahKeterampilanKhusus,
                  tahun: tahunController.text.isEmpty ? null : tahunController.text,
                  createdAt: DateTime.now(), // Placeholder, backend akan mengabaikan ini
                  updatedAt: DateTime.now(), // Placeholder, backend akan mengabaikan ini
                );

                _addData(newMataKuliah.toJson()); // Kirim data yang sudah di-toJson()
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Menampilkan dialog untuk mengedit data Mata Kuliah
  void _showEditDialog(int id, Map<String, dynamic> currentData) {
    final TextEditingController namaMataKuliahController =
        TextEditingController(text: currentData['nama_mata_kuliah']?.toString() ?? '');
    final TextEditingController kodeMataKuliahController =
        TextEditingController(text: currentData['kode_mata_kuliah']?.toString() ?? '');
    bool mataKuliahKompetensi = currentData['mata_kuliah_kompetensi'] ?? false;
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
    bool capaianKuliahSikap = currentData['capaian_kuliah_sikap'] ?? false;
    bool capaianKuliahPengetahuan = currentData['capaian_kuliah_pengetahuan'] ?? false;
    bool capaianKuliahKeterampilanUmum = currentData['capaian_kuliah_keterampilan_umum'] ?? false;
    bool capaianKuliahKeterampilanKhusus = currentData['capaian_kuliah_keterampilan_khusus'] ?? false;
    final TextEditingController tahunController =
        TextEditingController(text: currentData['tahun']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Mata Kuliah'),
          content: SingleChildScrollView(
            child: StatefulBuilder( // Menggunakan StatefulBuilder untuk memperbarui konten dialog
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: namaMataKuliahController,
                      decoration: const InputDecoration(labelText: 'Nama Mata Kuliah'),
                    ),
                    TextField(
                      controller: kodeMataKuliahController,
                      decoration: const InputDecoration(labelText: 'Kode Mata Kuliah'),
                    ),
                    Row(
                      children: [
                        const Text('Mata Kuliah Kompetensi:'),
                        Checkbox(
                          value: mataKuliahKompetensi,
                          onChanged: (bool? newValue) {
                            setState(() {
                              mataKuliahKompetensi = newValue ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    TextField(
                      controller: sksKuliahController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'SKS Kuliah'),
                    ),
                    TextField(
                      controller: sksSeminarController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'SKS Seminar'),
                    ),
                    TextField(
                      controller: sksPraktikumController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'SKS Praktikum'),
                    ),
                    TextField(
                      controller: konversiSksController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Konversi SKS (Jika Ada)'),
                    ),
                    TextField(
                      controller: semesterController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Semester'),
                    ),
                    TextField(
                      controller: metodePembelajaranController,
                      decoration: const InputDecoration(labelText: 'Metode Pembelajaran'),
                    ),
                    TextField(
                      controller: dokumenController,
                      decoration: const InputDecoration(labelText: 'Dokumen'),
                    ),
                    TextField(
                      controller: unitPenyelenggaraController,
                      decoration: const InputDecoration(labelText: 'Unit Penyelenggara'),
                    ),
                    Row(
                      children: [
                        const Text('Capaian Kuliah Sikap:'),
                        Checkbox(
                          value: capaianKuliahSikap,
                          onChanged: (bool? newValue) {
                            setState(() {
                              capaianKuliahSikap = newValue ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Capaian Kuliah Pengetahuan:'),
                        Checkbox(
                          value: capaianKuliahPengetahuan,
                          onChanged: (bool? newValue) {
                            setState(() {
                              capaianKuliahPengetahuan = newValue ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Capaian Kuliah Keterampilan Umum:'),
                        Checkbox(
                          value: capaianKuliahKeterampilanUmum,
                          onChanged: (bool? newValue) {
                            setState(() {
                              capaianKuliahKeterampilanUmum = newValue ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Capaian Kuliah Keterampilan Khusus:'),
                        Checkbox(
                          value: capaianKuliahKeterampilanKhusus,
                          onChanged: (bool? newValue) {
                            setState(() {
                              capaianKuliahKeterampilanKhusus = newValue ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    TextField(
                      controller: tahunController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Tahun'),
                    ),
                  ],
                );
              },
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
                if (namaMataKuliahController.text.isEmpty ||
                    kodeMataKuliahController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nama dan Kode Mata Kuliah harus diisi.')),
                  );
                  return;
                }

                // Buat objek MataKuliah yang diperbarui untuk memanfaatkan toJson()
                final updatedMataKuliah = MataKuliah(
                  id: id,
                  userId: userId,
                  namaMataKuliah: namaMataKuliahController.text,
                  kodeMataKuliah: kodeMataKuliahController.text,
                  mataKuliahKompetensi: mataKuliahKompetensi,
                  sksKuliah: int.tryParse(sksKuliahController.text),
                  sksSeminar: int.tryParse(sksSeminarController.text),
                  sksPraktikum: int.tryParse(sksPraktikumController.text),
                  konversiSks: int.tryParse(konversiSksController.text),
                  sks: null, // Akan dihitung di dalam toJson()
                  semester: int.tryParse(semesterController.text),
                  metodePembelajaran: metodePembelajaranController.text.isEmpty ? null : metodePembelajaranController.text,
                  dokumen: dokumenController.text.isEmpty ? null : dokumenController.text,
                  unitPenyelenggara: unitPenyelenggaraController.text.isEmpty ? null : unitPenyelenggaraController.text,
                  capaianKuliahSikap: capaianKuliahSikap,
                  capaianKuliahPengetahuan: capaianKuliahPengetahuan,
                  capaianKuliahKeterampilanUmum: capaianKuliahKeterampilanUmum,
                  capaianKuliahKeterampilanKhusus: capaianKuliahKeterampilanKhusus,
                  tahun: tahunController.text.isEmpty ? null : tahunController.text,
                  createdAt: currentData['created_at'] != null ? DateTime.tryParse(currentData['created_at']) : null,
                  updatedAt: DateTime.now(),
                );

                _editData(id, updatedMataKuliah.toJson()); // Kirim data yang sudah di-toJson()
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
