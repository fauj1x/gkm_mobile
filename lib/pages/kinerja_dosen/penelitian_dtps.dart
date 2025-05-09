import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/penelitian_dtps.dart'; // Pastikan ini model yang benar
import 'package:gkm_mobile/models/tahun_ajaran.dart'; // Mungkin tidak diperlukan
import 'package:gkm_mobile/services/api_services.dart'; // Menggunakan ApiService Anda
import 'package:shared_preferences/shared_preferences.dart';

// Mengganti nama kelas agar lebih sesuai dengan data yang ditampilkan
class PenelitianDtps extends StatefulWidget {
  final TahunAjaran tahunAjaran; // Mungkin tidak diperlukan
  const PenelitianDtps({Key? key, required this.tahunAjaran})
      : super(key: key);
  @override
  PenelitianDtpsState createState() => PenelitianDtpsState();
}

class PenelitianDtpsState extends State<PenelitianDtps> {
  List<PenelitianDtpsModel> dataList = [];
  ApiService apiService = ApiService(); // Menggunakan instance ApiService Anda
  String menuName = "Kinerja Dosen"; // Mengganti nama menu
  String subMenuName = "Penelitian DTPS"; // Sesuaikan jika ada sub menu
  String endPoint = "kinerja-penelitian"; // Sesuaikan endpoint API jika berbeda
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = int.parse(prefs.getString('id') ?? '0');
    });
  }

  Future<void> _fetchData() async {
    try {
      final data =
          await apiService.getData(PenelitianDtpsModel.fromJson, endPoint);
      setState(() {
        dataList = data;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> _addData(Map<String, dynamic> newData) async {
    try {
      await apiService.postData(
          PenelitianDtpsModel.fromJson, newData, endPoint);
      _fetchData();
    } catch (e) {
      print("Error adding data: $e");
    }
  }

  Future<void> _deleteData(int index) async {
    try {
      await apiService.deleteData(index, endPoint);
      _fetchData();
    } catch (e) {
      print("Error deleting data: $e");
    }
  }

  Future<void> _editData(int index, Map<String, dynamic> updatedData) async {
    try {
      await apiService.updateData(
          PenelitianDtpsModel.fromJson, index, updatedData, endPoint);
      _fetchData();
    } catch (e) {
      print("Error editing data: $e");
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
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          // Header Baris 1
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _headerCell("No.", 50),
                                _headerCell("Sumber Pembiayaan", 100),
                                _headerCell("Jumlah Judul", 100),
                                _headerCell("Tahun", 100),
                                _emptyCell(50), // Untuk Aksi
                              ],
                            ),
                          ),

                          // Header Baris 2 (Tingkat)
                          // Container(
                          //   color: Colors.teal,
                          //   child: Row(
                          //     children: [],
                          //   ),
                          // ),

                          // Isi Data
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50),
                              1: FixedColumnWidth(100),
                              2: FixedColumnWidth(100),
                              3: FixedColumnWidth(100),
                              4: FixedColumnWidth(50),
                            },
                            children: dataList.asMap().entries.map((entry) {
                              List<String> row = [
                                (entry.key + 1).toString(),
                                {
                                      "lokal":
                                          "Perguruan Tinggi (POLIJE)/Mandiri",
                                      "nasional":
                                          "Lembaga Dalam Negeri (Di luar POLIJE)",
                                      "internasional": "Lembaga Luar Negeri"
                                    }[entry.value.sumberDana] ??
                                    entry.value.sumberDana,
                                entry.value.jumlahJudul.toString(),
                                entry.value.tahunPenelitian,
                              ];
                              return TableRow(
                                children: [
                                  ...row.map((cell) {
                                    return TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                                cell.isEmpty ? "-" : cell)),
                                      ),
                                    );
                                  }).toList(),

                                  // Aksi Button
                                  TableCell(
                                    child: Center(
                                      child: PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert,
                                            color: Colors.black87),
                                        onSelected: (String choice) {
                                          if (choice == "Edit") {
                                            _showEditDialog(entry.value.id, {
                                              'sumber_dana':
                                                  entry.value.sumberDana,
                                              'jumlah_judul':
                                                  entry.value.jumlahJudul,
                                              'tahun_penelitian':
                                                  entry.value.tahunPenelitian,
                                            });
                                          } else if (choice == "Hapus") {
                                            _deleteData(entry.value.id);
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
    final TextEditingController controller1 = TextEditingController();
    final TextEditingController controller2 = TextEditingController();
    final TextEditingController controller3 = TextEditingController();
    final TextEditingController controller4 = TextEditingController();
    final TextEditingController controller5 = TextEditingController();
    final TextEditingController controller7 = TextEditingController();
    final TextEditingController controller8 = TextEditingController();
    final TextEditingController controller9 = TextEditingController();
    final TextEditingController controller10 = TextEditingController();
    final TextEditingController controller12 = TextEditingController();

    String? selectedKesesuaianDenganKompetensi;
    String? selectedKesesuaianBidangKeahlian;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Form input untuk data baru
                TextField(
                  controller: controller1,
                  decoration: const InputDecoration(
                    labelText: "Sumber Pembiayaan",
                  ),
                ),
                TextField(
                  controller: controller2,
                  decoration: const InputDecoration(
                    labelText: "Jumlah Judul",
                  ),
                ),
                TextField(
                  controller: controller3,
                  decoration: const InputDecoration(
                    labelText: "Tahun Penelitian",
                  ),
                ),
                // Tambahkan input lain sesuai kebutuhan
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
                _addData({
                  'sumber_dana': controller1.text,
                  'jumlah_judul': controller2.text,
                  'tahun_penelitian': controller3.text,
                  'user_id': userId,
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
    final TextEditingController controller1 = TextEditingController();
    final TextEditingController controller2 = TextEditingController();
    final TextEditingController controller3 = TextEditingController();
    final TextEditingController controller4 = TextEditingController();
    final TextEditingController controller5 = TextEditingController();
    final TextEditingController controller6 = TextEditingController();
    final TextEditingController controller7 = TextEditingController();
    final TextEditingController controller8 = TextEditingController();
    final TextEditingController controller9 = TextEditingController();
    final TextEditingController controller10 = TextEditingController();
    final TextEditingController controller12 = TextEditingController();

    controller1.text = currentData['sumber_dana'] ?? '';
    controller2.text = currentData['jumlah_judul']?.toString() ?? '';
    controller3.text = currentData['tahun_penelitian']?.toString() ?? '';

    String? selectedKesesuaianDenganKompetensi =
        currentData['kesesuaian_kompetensi'] == true ? "Ya" : "Tidak";
    String? selectedKesesuaianBidangKeahlian =
        currentData['kesesuaian_keahlian_mk'] == true ? "Ya" : "Tidak";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Form input untuk data yang diedit
                TextField(
                  controller: controller1,
                  decoration: const InputDecoration(
                    labelText: "Sumber Pembiayaan",
                  ),
                ),
                TextField(
                  controller: controller2,
                  decoration: const InputDecoration(
                    labelText: "Jumlah Judul",
                  ),
                ),
                TextField(
                  controller: controller3,
                  decoration: const InputDecoration(
                    labelText: "Tahun Penelitian",
                  ),
                ),
                // Tambahkan input lain sesuai kebutuhan
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
                _editData(id, {
                  'sumber_dana': controller1.text,
                  'jumlah_judul': controller2.text,
                  'tahun_penelitian': controller3.text,
                  'user_id': userId,
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
