import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/luaran_penelitian_lain_aio.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BukuChapterDosen extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const BukuChapterDosen({Key? key, required this.tahunAjaran})
      : super(key: key);
  @override
  BukuChapterDosenState createState() => BukuChapterDosenState();
}

class BukuChapterDosenState extends State<BukuChapterDosen> {
  // final List<String> yesNoOptions = ['Tidak', 'Ya'];
  List<LuaranPenelitianLainAioModel> dataList = [];
  ApiService apiService = ApiService();
  String menuName = "Kinerja Dosen - Luaran Penelitian Lain";
  String subMenuName = "Buku & Chapter";
  String endPoint = "luaran-bukuchapter";
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
      final data = await apiService.getData(
          LuaranPenelitianLainAioModel.fromJson, endPoint);
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
          LuaranPenelitianLainAioModel.fromJson, newData, endPoint);
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
          LuaranPenelitianLainAioModel.fromJson, index, updatedData, endPoint);
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
                                // No.
                                // Luaran Penelitian dan PkM
                                // Tahun (YYYY)
                                // Keterangan
                                // Aksi
                                _headerCell("No", 50),
                                _headerCell("Luaran Penelitian dan PkM", 100),
                                _headerCell("Tahun (YYYY)", 100),
                                _headerCell("Keterangan", 200),
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),

                          // Header Baris 2 (Tingkat)
                          // Container(
                          //   color: Colors.teal,
                          //   child: Row(
                          //     children: [
                          //     ],
                          //   ),
                          // ),

                          // Isi Data
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50),
                              1: FixedColumnWidth(100),
                              2: FixedColumnWidth(100),
                              3: FixedColumnWidth(200),
                              4: FixedColumnWidth(50),
                            },
                            children: dataList.asMap().entries.map((entry) {
                              List<String> row = [
                                (entry.key + 1).toString(),
                                entry.value.luaranPenelitian,
                                entry.value.tahun,
                                entry.value.keterangan,
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
                                              'luaran_penelitian':
                                                  entry.value.luaranPenelitian,
                                              'tahun': entry.value.tahun,
                                              'keterangan':
                                                  entry.value.keterangan,
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
            bottom: 48,
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

  // Widget _emptyCell(double width) {
  //   return Container(width: width, height: 40);
  // }

  void _showAddDialog() {
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
                TextField(
                  controller: controller1,
                  decoration: const InputDecoration(
                    labelText: 'Luaran Penelitian dan PkM',
                  ),
                ),
                TextField(
                  controller: controller2,
                  decoration: const InputDecoration(
                    labelText: 'Tahun (YYYY)',
                  ),
                ),
                TextField(
                  controller: controller3,
                  decoration: const InputDecoration(
                    labelText: 'Keterangan',
                  ),
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
                _addData({
                  'user_id': userId,
                  'luaran_penelitian': controller1.text,
                  'tahun': controller2.text,
                  'keterangan': controller3.text,
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

    controller1.text = currentData['luaran_penelitian'] ?? '';
    controller2.text = currentData['tahun'] ?? '';
    controller3.text = currentData['keterangan'] ?? '';

    // String? selectedKesesuaianDenganKompetensi =
    //     currentData['kesesuaian_kompetensi'] == true ? "Ya" : "Tidak";
    // String? selectedKesesuaianBidangKeahlian =
    //     currentData['kesesuaian_keahlian_mk'] == true ? "Ya" : "Tidak";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: controller1,
                  decoration: const InputDecoration(
                    labelText: 'Luaran Penelitian dan PkM',
                  ),
                ),
                TextField(
                  controller: controller2,
                  decoration: const InputDecoration(
                    labelText: 'Tahun (YYYY)',
                  ),
                ),
                TextField(
                  controller: controller3,
                  decoration: const InputDecoration(
                    labelText: 'Keterangan',
                  ),
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
                _editData(id, {
                  'user_id': userId,
                  'luaran_penelitian': controller1.text,
                  'tahun': controller2.text,
                  'keterangan': controller3.text,
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
