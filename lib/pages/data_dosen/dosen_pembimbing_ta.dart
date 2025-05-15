import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/dosen_pembimbing_ta.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DosenPembimbingTa extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const DosenPembimbingTa({Key? key, required this.tahunAjaran})
      : super(key: key);
  @override
  DosenPembimbingTaState createState() => DosenPembimbingTaState();
}

class DosenPembimbingTaState extends State<DosenPembimbingTa> {
  // final List<String> yesNoOptions = ['Tidak', 'Ya'];
  List<DosenPembimbingTaModel> dataList = [];
  ApiService apiService = ApiService();
  String menuName = "Dosen Pembimbing TA";
  String subMenuName = "";
  String endPoint = "dosen-pembimbing-ta";
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
          await apiService.getData(DosenPembimbingTaModel.fromJson, endPoint);
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
          DosenPembimbingTaModel.fromJson, newData, endPoint);
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
          DosenPembimbingTaModel.fromJson, index, updatedData, endPoint);
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
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
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
                ElevatedButton.icon(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF009688),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  ),
  onPressed: () {
    // Aksi import file
  },
  icon: Icon(Icons.upload_file, color: Colors.white),
  label: Text(
    'Impor File Excel',
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
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
                                _headerCell("Nama Dosen", 100),
                                _headerCell(
                                    "Jumlah Mahasiswa yang Dibimbing", 250),
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),

                          // Header Baris 2
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _emptyCell(50),
                                _emptyCell(100),
                                _headerCell("pada PS", 125),
                                _headerCell("pada PS Lain", 125),
                                _emptyCell(50),
                              ],
                            ),
                          ),

                          // Isi Data
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50),
                              1: FixedColumnWidth(100),
                              2: FixedColumnWidth(125),
                              3: FixedColumnWidth(125),
                              4: FixedColumnWidth(50),
                            },
                            children: dataList.asMap().entries.map((entry) {
                              List<String> row = [
                                (entry.key + 1).toString(),
                                entry.value.namaDosen,
                                entry.value.mhsBimbinganPs?.toString() ?? "-",
                                entry.value.mhsBimbinganPsLain?.toString() ??
                                    "-",
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
                                              'id': entry.value.id,
                                              'nama_dosen':
                                                  entry.value.namaDosen,
                                              'mhs_bimbingan_ps':
                                                  entry.value.mhsBimbinganPs,
                                              'mhs_bimbingan_ps_lain': entry
                                                  .value.mhsBimbinganPsLain,
                                              'tahun_ajaran_id':
                                                  widget.tahunAjaran.id,
                                              'user_id': userId,
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

  Widget _emptyCell(double width) {
    return SizedBox(width: width);
  }

  void _showAddDialog() {
    final TextEditingController controller1 = TextEditingController();
    final TextEditingController controller2 = TextEditingController();
    final TextEditingController controller3 = TextEditingController();
    // String? selectedKesesuaianDenganKompetensi;
    // String? selectedKesesuaianBidangKeahlian;

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
                  decoration: const InputDecoration(labelText: "Nama Dosen"),
                ),
                TextField(
                  controller: controller2,
                  decoration: const InputDecoration(
                      labelText: "Mahasiswa yang Dibimbing pada PS"),
                ),
                TextField(
                  controller: controller3,
                  decoration: const InputDecoration(
                      labelText: "Mahasiswa yang Dibimbing pada PS Lain"),
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
                  'nama_dosen': controller1.text,
                  'mhs_bimbingan_ps': int.tryParse(controller2.text) ?? 0,
                  'mhs_bimbingan_ps_lain': int.tryParse(controller3.text) ?? 0,
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
    final TextEditingController controller1 =
        TextEditingController(text: currentData['nama_dosen']);
    final TextEditingController controller2 = TextEditingController(
        text: currentData['mhs_bimbingan_ps']?.toString());
    final TextEditingController controller3 = TextEditingController(
        text: currentData['mhs_bimbingan_ps_lain']?.toString());

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
                  decoration: const InputDecoration(labelText: "Nama Dosen"),
                ),
                TextField(
                  controller: controller2,
                  decoration: const InputDecoration(
                      labelText: "Mahasiswa yang Dibimbing pada PS"),
                ),
                TextField(
                  controller: controller3,
                  decoration: const InputDecoration(
                      labelText: "Mahasiswa yang Dibimbing pada PS Lain"),
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
                  'id': id,
                  'nama_dosen': controller1.text,
                  'mhs_bimbingan_ps': int.tryParse(controller2.text) ?? 0,
                  'mhs_bimbingan_ps_lain': int.tryParse(controller3.text) ?? 0,
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
