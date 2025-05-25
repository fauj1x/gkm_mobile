import 'package:flutter/material.dart';
// Removed unused import
import 'package:gkm_mobile/models/ewmp_dosen.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EwmpDosen extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const EwmpDosen({Key? key, required this.tahunAjaran}) : super(key: key);
  @override
  EwmpDosenState createState() => EwmpDosenState();
}

class EwmpDosenState extends State<EwmpDosen> {
  final List<String> yesNoOptions = ['Tidak', 'Ya'];
  List<EwmpDosenModel> dataList = [];
  ApiService apiService = ApiService();
  String menuName = "EWMP Dosen";
  String subMenuName = "";
  String endPoint = "ewmp-dosen";
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

  List<EwmpDosenModel> filterByIdAndTahun(
      List<EwmpDosenModel> list,
      int userId,
      int tahunAjaranId) {
    return list.where((item) =>
    item.tahunAjaranId == tahunAjaranId &&
        item.userId == userId
    ).toList();
  }

  Future<void> _fetchData() async {
    try {
      final data = await apiService.getData(EwmpDosenModel.fromJson, endPoint);
      setState(() {
        dataList = filterByIdAndTahun(data, userId, widget.tahunAjaran.id);
      });
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
  }

  Future<void> _addData(Map<String, dynamic> newData) async {
    try {
      await apiService.postData(EwmpDosenModel.fromJson, newData, endPoint);
      _fetchData();
    } catch (e) {
      debugPrint("Error adding data: $e");
    }
  }

  Future<void> _deleteData(int index) async {
    try {
      await apiService.deleteData(index, endPoint);
      _fetchData();
    } catch (e) {
      debugPrint("Error deleting data: $e");
    }
  }

  Future<void> _editData(int index, Map<String, dynamic> updatedData) async {
    try {
      await apiService.updateData(
          EwmpDosenModel.fromJson, index, updatedData, endPoint);
      _fetchData();
    } catch (e) {
      debugPrint("Error editing data: $e");
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
                                _headerCell("No", 50),
                                _headerCell("Nama Dosen (DT)", 100),
                                _headerCell("DTPS", 100),
                                _headerCell(
                                    "Ekuivalen Waktu Mengajar Penuh (EWMP) pada saat TS dalam satuan kredit semester (SKS)",
                                    600),
                                _headerCell("Jumlah (SKS)", 100),
                                _headerCell(
                                    "Rata-rata per Semester (SKS)", 100),
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),

                          // Header Baris 2 (Tingkat)
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _emptyCell(250),
                                _headerCell(
                                    "Pendidikan:\nPembelajaran dan Pembimbingan",
                                    300),
                                _headerCell("Penelitian", 100),
                                _headerCell("PkM", 100),
                                _headerCell(
                                    "Tugas Tambahan dan/atau Penunjang", 100),
                                _emptyCell(250),
                              ],
                            ),
                          ),

                          // Header Baris 3 (Tingkat)
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _emptyCell(250),
                                _headerCell("PS yang Diakreditasi", 100),
                                _headerCell("PS Lain di dalam PT", 100),
                                _headerCell("PS Lain di luar PT", 100),
                                _emptyCell(550),
                              ],
                            ),
                          ),

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
                              9: FixedColumnWidth(100),
                              10: FixedColumnWidth(100),
                              11: FixedColumnWidth(50),
                            },
                            children: dataList.asMap().entries.map((entry) {
                              List<String> row = [
                                (entry.key + 1).toString(),
                                entry.value.namaDosen,
                                entry.value.isDtps == true ? "Ya" : "Tidak",
                                entry.value.psDiakreditasi?.toString() ?? "-",
                                entry.value.psLainDalamPt?.toString() ?? "-",
                                entry.value.psLainLuarPt?.toString() ?? "-",
                                entry.value.penelitian?.toString() ?? "-",
                                entry.value.pkm?.toString() ?? "-",
                                entry.value.tugasTambahan?.toString() ?? "-",
                                entry.value.jumlahSks?.toString() ?? "-",
                                entry.value.avgPerSemester?.toString() ?? "-",
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
                                              'nama_dosen':
                                                  entry.value.namaDosen,
                                              'is_dtps': entry.value.isDtps,
                                              'ps_diakreditasi':
                                                  entry.value.psDiakreditasi,
                                              'ps_lain_dalam_pt':
                                                  entry.value.psLainDalamPt,
                                              'ps_lain_luar_pt':
                                                  entry.value.psLainLuarPt,
                                              'penelitian':
                                                  entry.value.penelitian,
                                              'pkm': entry.value.pkm,
                                              'tugas_tambahan':
                                                  entry.value.tugasTambahan,
                                              'jumlah_sks':
                                                  entry.value.jumlahSks,
                                              'avg_per_semester':
                                                  entry.value.avgPerSemester,
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
    // final TextEditingController controller2 = TextEditingController();
    final TextEditingController controller3 = TextEditingController();
    final TextEditingController controller4 = TextEditingController();
    final TextEditingController controller5 = TextEditingController();
    final TextEditingController controller7 = TextEditingController();
    final TextEditingController controller8 = TextEditingController();
    final TextEditingController controller9 = TextEditingController();
    final TextEditingController controller10 = TextEditingController();
    final TextEditingController controller11 = TextEditingController();

    String? selectedIsDtps;

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
                  decoration:
                      const InputDecoration(labelText: "Nama Dosen (DT)"),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'DTPS'),
                  value: selectedIsDtps,
                  items: yesNoOptions
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                                value[0].toUpperCase() + value.substring(1)),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    selectedIsDtps = newValue;
                  },
                ),
                TextField(
                  controller: controller3,
                  decoration:
                      const InputDecoration(labelText: "PS yang Diakreditasi"),
                ),
                TextField(
                  controller: controller4,
                  decoration:
                      const InputDecoration(labelText: "PS Lain di dalam PT"),
                ),
                TextField(
                  controller: controller5,
                  decoration:
                      const InputDecoration(labelText: "PS Lain di luar PT"),
                ),
                TextField(
                  controller: controller7,
                  decoration: const InputDecoration(labelText: "Penelitian"),
                ),
                TextField(
                  controller: controller8,
                  decoration: const InputDecoration(labelText: "PkM"),
                ),
                TextField(
                  controller: controller9,
                  decoration: const InputDecoration(
                      labelText: "Tugas Tambahan dan/atau Penunjang"),
                ),
                TextField(
                  controller: controller10,
                  decoration: const InputDecoration(labelText: "Jumlah (SKS)"),
                ),
                TextField(
                  controller: controller11,
                  decoration: const InputDecoration(
                      labelText: "Rata-rata per Semester (SKS)"),
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
                  'is_dtps': selectedIsDtps == "Ya",
                  'ps_diakreditasi': controller3.text,
                  'ps_lain_dalam_pt': controller4.text,
                  'ps_lain_luar_pt': controller5.text,
                  'penelitian': controller7.text,
                  'pkm': controller8.text,
                  'tugas_tambahan': controller9.text,
                  'jumlah_sks': controller10.text,
                  'avg_per_semester': controller11.text,
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
    // final TextEditingController controller2 =
    //     TextEditingController(text: currentData['is_dtps']);
    final TextEditingController controller3 =
        TextEditingController(text: currentData['ps_diakreditasi']?.toString());
    final TextEditingController controller4 = TextEditingController(
        text: currentData['ps_lain_dalam_pt']?.toString());
    final TextEditingController controller5 =
        TextEditingController(text: currentData['ps_lain_luar_pt']?.toString());
    final TextEditingController controller7 =
        TextEditingController(text: currentData['penelitian']?.toString());
    final TextEditingController controller8 =
        TextEditingController(text: currentData['pkm']?.toString());
    final TextEditingController controller9 =
        TextEditingController(text: currentData['tugas_tambahan']?.toString());
    final TextEditingController controller10 =
        TextEditingController(text: currentData['jumlah_sks']?.toString());
    final TextEditingController controller11 = TextEditingController(
        text: currentData['avg_per_semester']?.toString());

    String? selectedIsDtps = currentData['is_dtps'] == true ? "Ya" : "Tidak";

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
                  decoration:
                      const InputDecoration(labelText: "Nama Dosen (DT)"),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'DTPS'),
                  value: selectedIsDtps,
                  items: yesNoOptions
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                                value[0].toUpperCase() + value.substring(1)),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    selectedIsDtps = newValue;
                  },
                ),
                TextField(
                  controller: controller3,
                  decoration:
                      const InputDecoration(labelText: "PS yang Diakreditasi"),
                ),
                TextField(
                  controller: controller4,
                  decoration:
                      const InputDecoration(labelText: "PS Lain di dalam PT"),
                ),
                TextField(
                  controller: controller5,
                  decoration:
                      const InputDecoration(labelText: "PS Lain di luar PT"),
                ),
                TextField(
                  controller: controller7,
                  decoration: const InputDecoration(labelText: "Penelitian"),
                ),
                TextField(
                  controller: controller8,
                  decoration: const InputDecoration(labelText: "PkM"),
                ),
                TextField(
                  controller: controller9,
                  decoration: const InputDecoration(
                      labelText: "Tugas Tambahan dan/atau Penunjang"),
                ),
                TextField(
                  controller: controller10,
                  decoration: const InputDecoration(labelText: "Jumlah (SKS)"),
                ),
                TextField(
                  controller: controller11,
                  decoration: const InputDecoration(
                      labelText: "Rata-rata per Semester (SKS)"),
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
                  'nama_dosen': controller1.text,
                  'is_dtps': selectedIsDtps == "Ya",
                  'ps_diakreditasi': controller3.text,
                  'ps_lain_dalam_pt': controller4.text,
                  'ps_lain_luar_pt': controller5.text,
                  'penelitian': controller7.text,
                  'pkm': controller8.text,
                  'tugas_tambahan': controller9.text,
                  'jumlah_sks': controller10.text,
                  'avg_per_semester': controller11.text,
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
