import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/kinerja_pengakuan.dart';
// Import model baru
import 'package:gkm_mobile/models/kinerja_pengakuan.dart'; // Sesuaikan nama file jika berbeda
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pengakuan_kinerja extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const Pengakuan_kinerja({Key? key, required this.tahunAjaran}) : super(key: key);
  @override
  PkmDTPSState createState() => PkmDTPSState(); // Ganti nama State class
}

// Ganti nama State class
class PkmDTPSState extends State<Pengakuan_kinerja> {
  List<Pengakuan_rekognisi> dataList = [];
  ApiService apiService = ApiService();
  String menuName = "Pengakuan Rekognisi";
  String subMenuName = "Pengakuan Rekognisi"; // Nama sub-menu sesuai kelas
  String endPoint = "kinerja-rekognisi"; // Pastikan endpoint ini benar untuk Pengabdian Masyarakat DTPS
  int userId = 0;

  // Tambahkan controllers untuk field baru
  final TextEditingController namaDosenController = TextEditingController();
  final TextEditingController bidangKeahlianController = TextEditingController();
  final TextEditingController namaRekognisiController = TextEditingController();
  final TextEditingController buktiPendukungController = TextEditingController();
  final TextEditingController tingkatController = TextEditingController();
  final TextEditingController tahunController = TextEditingController();


  // Opsi untuk dropdown tingkat (sesuaikan jika diperlukan)
  final List<String> tingkatOptions = ['Lokal', 'Nasional', 'Internasional']; // Sesuaikan dengan opsi yang valid

  @override
  void initState() {
    super.initState();
    _fetchUserId(); // Ambil userId sebelum fetch data
    _fetchData();
  }

  @override
  void dispose() {
    // Buang controllers saat widget di dispose
    namaDosenController.dispose();
    bidangKeahlianController.dispose();
    namaRekognisiController.dispose();
    buktiPendukungController.dispose();
    tingkatController.dispose();
    tahunController.dispose();
    super.dispose();
  }


  Future<void> _fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = int.parse(prefs.getString('id') ?? '0');
    });
  }

  Future<void> _fetchData() async {
    try {
      final data = await apiService.getData(Pengakuan_rekognisi.fromJson, endPoint);
      setState(() {
        // Filter data berdasarkan tahun ajaran yang dipilih jika endpoint mendukung
        // dataList = data.where((item) => item.tahun_ajaran_id == widget.tahunAjaran.id).toList();
        dataList = data; // Jika filtering dilakukan di backend atau tidak diperlukan
      });
    } catch (e) {
      print("Error fetching data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data: ${e.toString()}')),
      );
    }
  }

  Future<void> _addData(Map<String, dynamic> newData) async {
    try {
      await apiService.postData(Pengakuan_rekognisi.fromJson, newData, endPoint);
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

  Future<void> _deleteData(int id) async {
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

  Future<void> _editData(int id, Map<String, dynamic> updatedData) async {
    try {
      await apiService.updateData(Pengakuan_rekognisi.fromJson, id, updatedData, endPoint);
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
                          // Header Tabel - Sesuaikan dengan field di model Pkm_DTPS
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _headerCell("No", 50),
                                _headerCell("Nama Dosen", 150),
                                _headerCell("Bidang Keahlian", 150),
                                _headerCell("Nama Rekognisi", 200),
                                _headerCell("Bukti Pendukung", 150),
                                _headerCell("Tingkat", 100),
                                _headerCell("Tahun", 100),
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),

                          // Isi Data - Sesuaikan dengan field di model Pkm_DTPS
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50), // No
                              1: FixedColumnWidth(150), // Nama Dosen
                              2: FixedColumnWidth(150), // Bidang Keahlian
                              3: FixedColumnWidth(200), // Nama Rekognisi
                              4: FixedColumnWidth(150), // Bukti Pendukung
                              5: FixedColumnWidth(100), // Tingkat
                              6: FixedColumnWidth(100), // Tahun
                              7: FixedColumnWidth(50), // Aksi
                            },
                            children: dataList.asMap().entries.map((entry) {
                              int index = entry.key;
                              Pengakuan_rekognisi data = entry.value; // Menggunakan model baru
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
                                      child: Center(child: Text(data.namaDosen)),
                                    ),
                                  ),
                                  // Bidang Keahlian
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.bidangKeahlian)),
                                    ),
                                  ),
                                  // Nama Rekognisi
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.namaRekognisi)),
                                    ),
                                  ),
                                  // Bukti Pendukung
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.buktiPendukung)),
                                    ),
                                  ),
                                  // Tingkat
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.tingkat)),
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
                                        icon: const Icon(Icons.more_vert, color: Colors.black87),
                                        onSelected: (String choice) {
                                          if (choice == "Edit") {
                                            // Pastikan ID data ada sebelum mengedit
                                            if (data.id != null) {
                                              _showEditDialog(data.id!, {
                                                'nama_dosen': data.namaDosen,
                                                'bidang_keahlian': data.bidangKeahlian,
                                                'nama_rekognisi': data.namaRekognisi,
                                                'bukti_pendukung': data.buktiPendukung,
                                                'tingkat': data.tingkat,
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
                                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }


  void _showAddDialog() {
    // Clear controllers sebelum menampilkan dialog add
    namaDosenController.clear();
    bidangKeahlianController.clear();
    namaRekognisiController.clear();
    buktiPendukungController.clear();
    tingkatController.clear(); // Mungkin perlu default value atau dropdown
    tahunController.clear();

    // Variabel untuk menyimpan nilai terpilih dari dropdown Tingkat
    String? selectedTingkat;


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data Pengabdian Masyarakat'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Agar dialog menyesuaikan konten
              children: [
                TextField(
                  controller: namaDosenController,
                  decoration: const InputDecoration(labelText: 'Nama Dosen'),
                ),
                TextField(
                  controller: bidangKeahlianController,
                  decoration: const InputDecoration(labelText: 'Bidang Keahlian'),
                ),
                TextField(
                  controller: namaRekognisiController,
                  decoration: const InputDecoration(labelText: 'Nama Rekognisi'),
                ),
                TextField(
                  controller: buktiPendukungController,
                  decoration: const InputDecoration(labelText: 'Bukti Pendukung'),
                ),
                // Dropdown untuk Tingkat
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Tingkat'),
                  value: selectedTingkat,
                  items: tingkatOptions.map((String tingkat) {
                    return DropdownMenuItem<String>(
                      value: tingkat,
                      child: Text(tingkat),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                       selectedTingkat = newValue;
                    });
                  },
                ),
                TextField(
                  controller: tahunController,
                  keyboardType: TextInputType.number, // Input angka
                  decoration: const InputDecoration(labelText: 'Tahun'),
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
                // Validasi sederhana sebelum mengirim
                if (namaDosenController.text.isEmpty ||
                    bidangKeahlianController.text.isEmpty ||
                    namaRekognisiController.text.isEmpty ||
                    buktiPendukungController.text.isEmpty ||
                    selectedTingkat == null || // Validasi dropdown
                    tahunController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua field harus diisi.')),
                  );
                  return; // Jangan lanjutkan jika ada field yang kosong
                }

                // Coba parse tahun menjadi integer (sesuaikan jika backend butuh string)
                // int? tahun = int.tryParse(tahunController.text);
                // if (tahun == null) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text('Tahun harus berupa angka.')),
                //   );
                //   return;
                // }

                _addData({
                  'user_id': userId,
                  // 'tahun_ajaran_id': widget.tahunAjaran.id, // Cek apakah backend butuh tahun_ajaran_id di endpoint ini
                  'nama_dosen': namaDosenController.text,
                  'bidang_keahlian': bidangKeahlianController.text,
                  'nama_rekognisi': namaRekognisiController.text,
                  'bukti_pendukung': buktiPendukungController.text,
                  'tingkat': selectedTingkat, // Kirim nilai dari dropdown
                  'tahun': tahunController.text, // Kirim sebagai string (sesuai model)
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
    // Isi controllers dengan data saat ini
    namaDosenController.text = currentData['nama_dosen']?.toString() ?? '';
    bidangKeahlianController.text = currentData['bidang_keahlian']?.toString() ?? '';
    namaRekognisiController.text = currentData['nama_rekognisi']?.toString() ?? '';
    buktiPendukungController.text = currentData['bukti_pendukung']?.toString() ?? '';
    tingkatController.text = currentData['tingkat']?.toString() ?? ''; // Akan digunakan sebagai initial value untuk dropdown
    tahunController.text = currentData['tahun']?.toString() ?? '';

    // Variabel untuk menyimpan nilai terpilih dari dropdown Tingkat saat edit
    String? selectedTingkat = currentData['tingkat']?.toString();


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Pengabdian Masyarakat'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Agar dialog menyesuaikan konten
              children: [
                TextField(
                  controller: namaDosenController,
                  decoration: const InputDecoration(labelText: 'Nama Dosen'),
                ),
                TextField(
                  controller: bidangKeahlianController,
                  decoration: const InputDecoration(labelText: 'Bidang Keahlian'),
                ),
                TextField(
                  controller: namaRekognisiController,
                  decoration: const InputDecoration(labelText: 'Nama Rekognisi'),
                ),
                TextField(
                  controller: buktiPendukungController,
                  decoration: const InputDecoration(labelText: 'Bukti Pendukung'),
                ),
                 // Dropdown untuk Tingkat
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Tingkat'),
                   value: selectedTingkat,
                  items: tingkatOptions.map((String tingkat) {
                    return DropdownMenuItem<String>(
                      value: tingkat,
                      child: Text(tingkat),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                     setState(() {
                       selectedTingkat = newValue;
                    });
                  },
                ),
                TextField(
                  controller: tahunController,
                  keyboardType: TextInputType.number, // Input angka
                  decoration: const InputDecoration(labelText: 'Tahun'),
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
                // Validasi sederhana sebelum mengirim
                if (namaDosenController.text.isEmpty ||
                    bidangKeahlianController.text.isEmpty ||
                    namaRekognisiController.text.isEmpty ||
                    buktiPendukungController.text.isEmpty ||
                     selectedTingkat == null || // Validasi dropdown
                    tahunController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua field harus diisi.')),
                  );
                  return; // Jangan lanjutkan jika ada field yang kosong
                }

                 // Coba parse tahun menjadi integer (sesuaikan jika backend butuh string)
                // int? tahun = int.tryParse(tahunController.text);
                // if (tahun == null) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text('Tahun harus berupa angka.')),
                //   );
                //   return;
                // }


                _editData(id, {
                  'nama_dosen': namaDosenController.text,
                  'bidang_keahlian': bidangKeahlianController.text,
                  'nama_rekognisi': namaRekognisiController.text,
                  'bukti_pendukung': buktiPendukungController.text,
                  'tingkat': selectedTingkat, // Kirim nilai dari dropdown
                  'tahun': tahunController.text, // Kirim sebagai string (sesuai model)
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