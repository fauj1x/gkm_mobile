import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/dosen_industri_praktisi.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DosenIndustriPraktisi extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const DosenIndustriPraktisi({Key? key, required this.tahunAjaran})
      : super(key: key);
  @override
  DosenIndustriPraktisiState createState() => DosenIndustriPraktisiState();
}

class DosenIndustriPraktisiState extends State<DosenIndustriPraktisi> {
  // final List<String> yesNoOptions = ['Tidak', 'Ya'];
  List<DosenIndustriPraktisiModel> dataList = [];
  ApiService apiService = ApiService();
  String menuName = "Dosen Industri/Praktisi";
  String subMenuName = "";
  String endPoint = "dosen-praktisi";
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

  List<DosenIndustriPraktisiModel> filterByIdAndTahun(
      List<DosenIndustriPraktisiModel> list,
      int userId,
      int tahunAjaranId) {
    return list.where((item) =>
    item.tahunAjaranId == tahunAjaranId &&
        item.userId == userId
    ).toList();
  }

  Future<void> _fetchData() async {
    try {
      final data = await apiService.getData(
          DosenIndustriPraktisiModel.fromJson, endPoint);
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
          DosenIndustriPraktisiModel.fromJson, newData, endPoint);
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
          DosenIndustriPraktisiModel.fromJson, index, updatedData, endPoint);
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
                                _headerCell("NIDK", 100),
                                _headerCell("Perusahaan/Industri", 100),
                                _headerCell("Pendidikan Tertinggi", 100),
                                _headerCell("Bidang Keahlian", 100),
                                _headerCell(
                                    "Sertifikat Profesi/Kompetensi/Industri",
                                    100),
                                _headerCell("Mata Kuliah yang Diampu", 100),
                                _headerCell("Bobot Kredit (sks)", 100),
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),

                          // Header Baris 2 (Unused)
                          // Container(
                          //   color: Colors.teal,
                          //   child: Row(
                          //     children: [
                          //       _emptyCell(50),
                          //       _emptyCell(100),
                          //       _emptyCell(100),
                          //       _headerCell(
                          //           "Magister/Magister Terapan/Spesialis", 100),
                          //       _headerCell(
                          //           "Doktor/Doktor Terapan/Spesialis", 100),
                          //       _emptyCell(100),
                          //       _emptyCell(100),
                          //       _emptyCell(100),
                          //       _emptyCell(100),
                          //       _emptyCell(100),
                          //       _emptyCell(200),
                          //       _emptyCell(100),
                          //       _emptyCell(200),
                          //       _emptyCell(50),
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
                              3: FixedColumnWidth(100),
                              4: FixedColumnWidth(100),
                              5: FixedColumnWidth(100),
                              6: FixedColumnWidth(100),
                              7: FixedColumnWidth(100),
                              8: FixedColumnWidth(100),
                              9: FixedColumnWidth(50),
                            },
                            children: dataList.asMap().entries.map((entry) {
                              List<String> row = [
                                (entry.key + 1).toString(),
                                entry.value.namaDosen,
                                entry.value.nidk ?? "-",
                                entry.value.perusahaan ?? "-",
                                entry.value.pendidikanTertinggi ?? "-",
                                entry.value.bidangKeahlian ?? "-",
                                entry.value.sertifikatKompetensi ?? "-",
                                entry.value.mkDiampu ?? "-",
                                entry.value.bobotKreditSks?.toString() ?? "-",
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
                                              'nidk': entry.value.nidk,
                                              'perusahaan':
                                                  entry.value.perusahaan,
                                              'pendidikan_tertinggi': entry
                                                  .value.pendidikanTertinggi,
                                              'bidang_keahlian':
                                                  entry.value.bidangKeahlian,
                                              'sertifikat_kompetensi': entry
                                                  .value.sertifikatKompetensi,
                                              'mk_diampu': entry.value.mkDiampu,
                                              'bobot_kredit_sks':
                                                  entry.value.bobotKreditSks,
                                              'tahun_ajaran_id':
                                                  entry.value.tahunAjaranId,
                                              'user_id': entry.value.userId,
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
                  decoration: const InputDecoration(labelText: "NIDK"),
                ),
                TextField(
                  controller: controller3,
                  decoration:
                      const InputDecoration(labelText: "Pendidikan Tertinggi"),
                ),
                TextField(
                  controller: controller4,
                  decoration:
                      const InputDecoration(labelText: "Bidang Keahlian"),
                ),
                TextField(
                  controller: controller5,
                  decoration:
                      const InputDecoration(labelText: "Perusahaan/Industri"),
                ),
                TextField(
                  controller: controller6,
                  decoration:
                      const InputDecoration(labelText: "Sertifikat Kompetensi"),
                ),
                TextField(
                  controller: controller7,
                  decoration: const InputDecoration(
                      labelText: "Mata Kuliah yang Diampu"),
                ),
                TextField(
                  controller: controller8,
                  decoration:
                      const InputDecoration(labelText: "Bobot Kredit (sks)"),
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
                  'nidk': controller2.text,
                  'perusahaan': controller5.text,
                  'pendidikan_tertinggi': controller3.text,
                  'bidang_keahlian': controller4.text,
                  'sertifikat_kompetensi': controller6.text,
                  'mk_diampu': controller7.text,
                  'bobot_kredit_sks': double.tryParse(controller8.text) ?? 0.0,
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
    final TextEditingController controller2 =
        TextEditingController(text: currentData['nidk']);
    final TextEditingController controller3 =
        TextEditingController(text: currentData['perusahaan']);
    final TextEditingController controller4 =
        TextEditingController(text: currentData['pendidikan_tertinggi']);
    final TextEditingController controller5 =
        TextEditingController(text: currentData['bidang_keahlian']);
    final TextEditingController controller6 =
        TextEditingController(text: currentData['sertifikat_kompetensi']);
    final TextEditingController controller7 =
        TextEditingController(text: currentData['mk_diampu']);
    final TextEditingController controller8 = TextEditingController(
        text: currentData['bobot_kredit_sks']?.toString() ?? "0");

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
                  decoration: const InputDecoration(labelText: "NIDK"),
                ),
                TextField(
                  controller: controller3,
                  decoration:
                      const InputDecoration(labelText: "Perusahaan/Industri"),
                ),
                TextField(
                  controller: controller4,
                  decoration:
                      const InputDecoration(labelText: "Pendidikan Tertinggi"),
                ),
                TextField(
                  controller: controller5,
                  decoration:
                      const InputDecoration(labelText: "Bidang Keahlian"),
                ),
                TextField(
                  controller: controller6,
                  decoration:
                      const InputDecoration(labelText: "Sertifikat Kompetensi"),
                ),
                TextField(
                  controller: controller7,
                  decoration: const InputDecoration(
                      labelText: "Mata Kuliah yang Diampu"),
                ),
                TextField(
                  controller: controller8,
                  decoration:
                      const InputDecoration(labelText: "Bobot Kredit (sks)"),
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
                  'nidk': controller2.text,
                  'perusahaan': controller3.text,
                  'pendidikan_tertinggi': controller4.text,
                  'bidang_keahlian': controller5.text,
                  'sertifikat_kompetensi': controller6.text,
                  'mk_diampu': controller7.text,
                  'bobot_kredit_sks': double.tryParse(controller8.text) ?? 0.0,
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
