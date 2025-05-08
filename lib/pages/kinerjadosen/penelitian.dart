import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/kinerja_penelitiandtps.dart'; // Pastikan ini model yang benar
import 'package:gkm_mobile/models/tahun_ajaran.dart'; // Mungkin tidak diperlukan
import 'package:gkm_mobile/services/api_services.dart'; // Menggunakan ApiService Anda
import 'package:shared_preferences/shared_preferences.dart';

// Mengganti nama kelas agar lebih sesuai dengan data yang ditampilkan
class PenelitianDtpsPage extends StatefulWidget {
  final TahunAjaran tahunAjaran; // Mungkin tidak diperlukan
  const PenelitianDtpsPage({Key? key, required this.tahunAjaran}) : super(key: key);
  @override
  PenelitianDtpsPageState createState() => PenelitianDtpsPageState();
}

class PenelitianDtpsPageState extends State<PenelitianDtpsPage> {
  List<PenelitianDTPS> dataList = [];
  ApiService apiService = ApiService(); // Menggunakan instance ApiService Anda
  String menuName = "Penelitian DTPS"; // Mengganti nama menu
  String subMenuName = ""; // Sesuaikan jika ada sub menu
  String endPoint =  "kinerja-penelitian"; // Sesuaikan endpoint API jika berbeda
  int userId = 0;
  bool _isLoading = true; // Tambahkan state untuk loading
  TextEditingController _searchController = TextEditingController(); // Controller untuk search

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    // _fetchData() akan dipanggil setelah _fetchUserId selesai
  }

  Future<void> _fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = int.tryParse(prefs.getString('id') ?? '0') ?? 0;
    });
    // Panggil fetch data di sini setelah userId didapatkan
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true; // Set loading true saat memulai fetch
    });
    try {
      // Panggil method getData dari ApiService Anda
      // Asumsikan getData mengembalikan List<dynamic>
      final List<dynamic> rawData = await apiService.getData(PenelitianDTPS.fromJson, endPoint);

      // Konversi rawData menjadi List<PenelitianDTPS>
      final List<PenelitianDTPS> convertedData = rawData.map((item) => PenelitianDTPS.fromJson(item)).toList();

      setState(() {
        dataList = convertedData;
      });
    } catch (e) {
      print("Error fetching data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengambil data: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Set loading false setelah selesai fetch
      });
    }
  }

  Future<void> _addData(Map<String, dynamic> newData) async {
    try {
      // Panggil method postData dari ApiService Anda
      // Asumsikan postData mengembalikan objek yang ditambahkan (opsional)
      await apiService.postData(PenelitianDTPS.fromJson, newData, endPoint); // Sesuaikan pemanggilan method postData
      _fetchData(); // Refresh data setelah berhasil menambah
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data berhasil ditambahkan")),
      );
    } catch (e) {
      print("Error adding data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menambah data: $e")),
      );
    }
  }

  Future<void> _deleteData(int id) async {
    try {
      // Panggil method deleteData dari ApiService Anda
      await apiService.deleteData(id, endPoint); // Sesuaikan pemanggilan method deleteData
      _fetchData(); // Refresh data setelah berhasil menghapus
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data berhasil dihapus")),
      );
    } catch (e) {
      print("Error deleting data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus data: $e")),
      );
    }
  }

  Future<void> _editData(int id, Map<String, dynamic> updatedData) async {
    try {
      // Panggil method updateData dari ApiService Anda
      // Asumsikan updateData mengembalikan objek yang diupdate (opsional)
      await apiService.updateData(PenelitianDTPS.fromJson, id, updatedData, endPoint); // Sesuaikan pemanggilan method updateData
      _fetchData(); // Refresh data setelah berhasil mengedit
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data berhasil diperbarui")),
      );
    } catch (e) {
      print("Error editing data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengedit data: $e")),
      );
    }
  }

   @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                // Input Search
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
                          controller: _searchController, // Gunakan controller
                          style: const TextStyle(color: Color(0xFF009688)),
                           onChanged: (value) {
                             // Implementasi search filtering di sini jika diperlukan
                             // Untuk saat ini, hanya controller yang ditambahkan
                           },
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
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Tampilkan loading indicator jika sedang loading
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              border: TableBorder.all(color: Colors.black54),
                              columns: const [
                                DataColumn(label: Text('No.')),
                                DataColumn(label: Text('Jumlah Judul')),
                                DataColumn(label: Text('Sumber Dana')),
                                DataColumn(label: Text('Tahun Penelitian')),
                                DataColumn(label: Text('Dibuat Pada')),
                                DataColumn(label: Text('Diperbarui Pada')),
                                DataColumn(label: Text('Aksi')),
                              ],
                              rows: dataList.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;

                                return DataRow(
                                  cells: [
                                    DataCell(Text((index + 1).toString())),
                                    DataCell(Text(item.jumlahJudul.toString())),
                                    DataCell(Text(item.sumberDana)),
                                    DataCell(Text(item.tahunPenelitian)),
                                    DataCell(Text(item.createdAt.toString().split(' ').first)),
                                    DataCell(Text(item.updatedAt.toString().split(' ').first)),
                                    DataCell(
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert, color: Colors.black87),
                                        onSelected: (String choice) {
                                          if (choice == "Edit" && item.id != null) {
                                            _showEditDialog(item.id!, {
                                              'jumlah_judul': item.jumlahJudul,
                                              'sumber_dana': item.sumberDana,
                                              'tahun_penelitian': item.tahunPenelitian,
                                              // Tidak perlu mengirim created_at, updated_at, deleted_at, user_id saat edit
                                            });
                                          } else if (choice == "Hapus" && item.id != null) {
                                            // Tampilkan konfirmasi dialog sebelum menghapus
                                            _showDeleteConfirmationDialog(item.id!);
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
                                  ],
                                );
                              }).toList(),
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

  // Fungsi untuk menampilkan dialog tambah data
  void _showAddDialog() {
    final TextEditingController controllerJumlahJudul = TextEditingController();
    final TextEditingController controllerSumberDana = TextEditingController();
    final TextEditingController controllerTahunPenelitian = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data Penelitian DTPS'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Agar konten tidak melebihi layar
              children: [
                TextField(
                  controller: controllerJumlahJudul,
                  decoration: const InputDecoration(labelText: "Jumlah Judul"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: controllerSumberDana,
                  decoration: const InputDecoration(labelText: "Sumber Dana"),
                ),
                TextField(
                  controller: controllerTahunPenelitian,
                  decoration: const InputDecoration(labelText: "Tahun Penelitian"),
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
                if (controllerJumlahJudul.text.isEmpty ||
                    controllerSumberDana.text.isEmpty ||
                    controllerTahunPenelitian.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Semua field harus diisi")),
                  );
                  return;
                }

                _addData({
                  'jumlah_judul': int.tryParse(controllerJumlahJudul.text) ?? 0,
                  'sumber_dana': controllerSumberDana.text,
                  'tahun_penelitian': controllerTahunPenelitian.text,
                  'user_id': userId, // Sertakan user_id
                  // API biasanya menangani created_at dan updated_at secara otomatis
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

  // Fungsi untuk menampilkan dialog edit data
  void _showEditDialog(int id, Map<String, dynamic> currentData) {
    final TextEditingController controllerJumlahJudul =
        TextEditingController(text: currentData['jumlah_judul'].toString());
    final TextEditingController controllerSumberDana =
        TextEditingController(text: currentData['sumber_dana']);
    final TextEditingController controllerTahunPenelitian =
        TextEditingController(text: currentData['tahun_penelitian']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Penelitian DTPS'),
          content: SingleChildScrollView(
            child: Column(
               mainAxisSize: MainAxisSize.min, // Agar konten tidak melebihi layar
              children: [
                TextField(
                  controller: controllerJumlahJudul,
                  decoration: const InputDecoration(labelText: "Jumlah Judul"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: controllerSumberDana,
                  decoration: const InputDecoration(labelText: "Sumber Dana"),
                ),
                TextField(
                  controller: controllerTahunPenelitian,
                  decoration: const InputDecoration(labelText: "Tahun Penelitian"),
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
                if (controllerJumlahJudul.text.isEmpty ||
                    controllerSumberDana.text.isEmpty ||
                    controllerTahunPenelitian.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Semua field harus diisi")),
                  );
                  return;
                }
                _editData(id, {
                  'jumlah_judul': int.tryParse(controllerJumlahJudul.text) ?? 0,
                  'sumber_dana': controllerSumberDana.text,
                  'tahun_penelitian': controllerTahunPenelitian.text,
                  // API biasanya menangani updated_at secara otomatis
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

  // Fungsi untuk menampilkan dialog konfirmasi hapus
  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _deleteData(id);
                Navigator.pop(context);
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

// Catatan:
// 1. Pastikan model PenelitianDTPS Anda memiliki factory constructor fromJson.
// 2. Pastikan ApiService Anda memiliki method getData, postData, deleteData, dan updateData
//    dengan signature yang sesuai dengan pemanggilan di kode ini.
// 3. Sesuaikan endpoint API "penelitian-dtps" jika berbeda di backend Anda.