import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/mahasiswa_asing.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MahasiswaAsing extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const MahasiswaAsing({Key? key, required this.tahunAjaran}) : super(key: key);
  @override
  MahasiswaAsingState createState() => MahasiswaAsingState();
}

class MahasiswaAsingState extends State<MahasiswaAsing> {
  List<MahasiswaAsingModel> dataList = [];
  ApiService apiService = ApiService();
  String menuName = "Mahasiswa Asing";
  String subMenuName = "";
  String endPoint = "mahasiswa-asing";
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _fetchData();
  }

  Future<void> _fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = int.parse(prefs.getString('id') ?? '0');
    });
  }

  List<MahasiswaAsingModel> filterByIdAndTahun(
      List<MahasiswaAsingModel> list,
      int userId,
      int tahunAjaranId) {
    return list.where((item) =>
    item.tahunAjaranId == tahunAjaranId &&
        item.userId == userId
    ).toList();
  }

  Future<void> _fetchData() async {
    try {
      final data =
          await apiService.getData(MahasiswaAsingModel.fromJson, endPoint);
      setState(() {
        dataList = filterByIdAndTahun(data, userId, widget.tahunAjaran.id);
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> _addData(Map<String, dynamic> newData) async {
    try {
      await apiService.postData(
          MahasiswaAsingModel.fromJson, newData, endPoint);
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
          MahasiswaAsingModel.fromJson, index, updatedData, endPoint);
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
                          // Header Baris 1
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _headerCell(
                                    "Jumlah Mahasiswa Asing Aktif", 150),
                                _headerCell(
                                    "Jumlah Mahasiswa Asing Penuh Waktu (Full-time)",
                                    200),
                                _headerCell(
                                    "Jumlah Mahasiswa Asing Paruh Waktu (Part-time)",
                                    200),
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),

                          // Isi Data
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(150),
                              1: FixedColumnWidth(200),
                              2: FixedColumnWidth(200),
                              3: FixedColumnWidth(50),
                            },
                            children: dataList.asMap().entries.map((entry) {
                              List<String> row = [
                                entry.value.mhsAktif.toString(),
                                entry.value.mhsAsingFulltime.toString(),
                                entry.value.mhsAsingParttime.toString(),
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
                                              'mhs_aktif': entry.value.mhsAktif,
                                              'mhs_asing_fulltime':
                                                  entry.value.mhsAsingFulltime,
                                              'mhs_asing_parttime':
                                                  entry.value.mhsAsingParttime,
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
    final TextEditingController controller1Controller = TextEditingController();
    final TextEditingController controller2Controller = TextEditingController();
    final TextEditingController controller3Controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    controller: controller1Controller,
                    decoration:
                        const InputDecoration(labelText: 'Jumlah Mahasiswa Aktif	')),
                TextField(
                    controller: controller2Controller,
                    decoration: const InputDecoration(
                        labelText:
                            'Jumlah Mahasiswa Asing Penuh Waktu (Full-time)')),
                TextField(
                    controller: controller3Controller,
                    decoration: const InputDecoration(
                        labelText:
                            'Jumlah Mahasiswa Asing Paruh Waktu (Part-time)')),
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
                  'mhs_aktif': int.parse(controller1Controller.text),
                  'mhs_asing_fulltime': int.parse(controller2Controller.text),
                  'mhs_asing_parttime': int.parse(controller3Controller.text),
                  'tahun_ajaran_id': widget.tahunAjaran.id,
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
    final TextEditingController controller1Controller =
        TextEditingController(text: currentData['mhs_aktif'].toString());
    final TextEditingController controller2Controller = TextEditingController(
        text: currentData['mhs_asing_fulltime'].toString());
    final TextEditingController controller3Controller = TextEditingController(
        text: currentData['mhs_asing_parttime'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    controller: controller1Controller,
                    decoration:
                        const InputDecoration(labelText: 'Jumlah Mahasiswa Aktif	')),
                TextField(
                    controller: controller2Controller,
                    decoration: const InputDecoration(
                        labelText:
                            'Jumlah Mahasiswa Asing Penuh Waktu (Full-time)')),
                TextField(
                    controller: controller3Controller,
                    decoration: const InputDecoration(
                        labelText:
                            'Jumlah Mahasiswa Asing Paruh Waktu (Part-time)')),
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
                  'mhs_aktif': int.parse(controller1Controller.text),
                  'mhs_asing_fulltime': int.parse(controller2Controller.text),
                  'mhs_asing_parttime': int.parse(controller3Controller.text),
                  'tahun_ajaran_id': widget.tahunAjaran.id,
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
