import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/dosen_tidak_tetap.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DosenTidakTetap extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const DosenTidakTetap({Key? key, required this.tahunAjaran})
      : super(key: key);
  @override
  DosenTidakTetapState createState() => DosenTidakTetapState();
}

class DosenTidakTetapState extends State<DosenTidakTetap> {
  final List<String> yesNoOptions = ['Tidak', 'Ya'];
  List<DosenTidakTetapModel> dataList = [];
  ApiService apiService = ApiService();
  String menuName = "Dosen Tidak Tetap";
  String subMenuName = "";
  String endPoint = "dosen-tidak-tetap";
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
          await apiService.getData(DosenTidakTetapModel.fromJson, endPoint);
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
          DosenTidakTetapModel.fromJson, newData, endPoint);
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
          DosenTidakTetapModel.fromJson, index, updatedData, endPoint);
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
                                _headerCell("Nama Dosen", 100),
                                _headerCell("NIDN/NIDK", 100),
                                _headerCell("Pendidikan Pasca Sarjana", 100),
                                _headerCell("Bidang Keahlian", 100),
                                _headerCell("Jabatan Akademik", 100),
                                _headerCell(
                                    "Sertifikat Pendidik Profesional", 100),
                                _headerCell(
                                    "Sertifikat Kompetensi/Profesi/Industri",
                                    100),
                                _headerCell(
                                    "Mata Kuliah yang Diampu pada PS", 100),
                                _headerCell(
                                    "Kesesuaian Bidang Keahlian dengan Mata Kuliah yang Diampu",
                                    100),
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),

                          // // Header Baris 2 (Unused)
                          // Container(
                          //   color: const Color(0xFF009688),
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
                              9: FixedColumnWidth(100),
                              10: FixedColumnWidth(50),
                            },
                            children: dataList.asMap().entries.map((entry) {
                              List<String> row = [
                                (entry.key + 1).toString(),
                                entry.value.namaDosen,
                                entry.value.nidnNidk ?? "-",
                                entry.value.pendidikanPascasarjana ?? "-",
                                entry.value.bidangKeahlian ?? "-",
                                entry.value.jabatanAkademik ?? "-",
                                entry.value.sertifikatPendidik ?? "-",
                                entry.value.sertifikatKompetensi ?? "-",
                                entry.value.mkDiampu ?? "-",
                                entry.value.kesesuaianKeahlianMk == true
                                    ? "✅"
                                    : "",
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
                                              'nidn_nidk': entry.value.nidnNidk,
                                              'pendidikan_pascasarjana': entry
                                                  .value.pendidikanPascasarjana,
                                              'bidang_keahlian':
                                                  entry.value.bidangKeahlian,
                                              'jabatan_akademik':
                                                  entry.value.jabatanAkademik,
                                              'sertifikat_pendidik': entry
                                                  .value.sertifikatPendidik,
                                              'sertifikat_kompetensi': entry
                                                  .value.sertifikatKompetensi,
                                              'mk_diampu': entry.value.mkDiampu,
                                              'kesesuaian_keahlian_mk': entry
                                                  .value.kesesuaianKeahlianMk,
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
            bottom: 64,
            right: 16,
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

    String? selectedKesesuaianDenganKompetensi;

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
                  decoration: const InputDecoration(labelText: "NIDN/NIDK"),
                ),
                TextField(
                  controller: controller3,
                  decoration: const InputDecoration(
                      labelText: "Pendidikan Pasca Sarjana"),
                ),
                TextField(
                  controller: controller4,
                  decoration:
                      const InputDecoration(labelText: "Bidang Keahlian"),
                ),
                TextField(
                  controller: controller5,
                  decoration:
                      const InputDecoration(labelText: "Jabatan Akademik"),
                ),
                TextField(
                  controller: controller6,
                  decoration: const InputDecoration(
                      labelText: "Sertifikat Pendidik Profesional"),
                ),
                TextField(
                  controller: controller7,
                  decoration: const InputDecoration(
                      labelText: "Sertifikat Kompetensi/Profesi/Industri"),
                ),
                TextField(
                  controller: controller8,
                  decoration: const InputDecoration(
                      labelText: "Mata Kuliah yang Diampu pada PS"),
                ),
                DropdownButtonFormField<String>(
                  value: selectedKesesuaianDenganKompetensi,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedKesesuaianDenganKompetensi = newValue;
                    });
                  },
                  items: yesNoOptions
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                      labelText:
                          "Kesesuaian Bidang Keahlian dengan Mata Kuliah yang Diampu"),
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
                  'nidn_nidk': controller2.text,
                  'pendidikan_pascasarjana': controller3.text,
                  'bidang_keahlian': controller4.text,
                  'jabatan_akademik': controller5.text,
                  'sertifikat_pendidik': controller6.text,
                  'sertifikat_kompetensi': controller7.text,
                  'mk_diampu': controller8.text,
                  'kesesuaian_keahlian_mk':
                      selectedKesesuaianDenganKompetensi == "Ya",
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
        TextEditingController(text: currentData['nidn_nidk']);
    final TextEditingController controller3 =
        TextEditingController(text: currentData['pendidikan_pascasarjana']);
    final TextEditingController controller4 =
        TextEditingController(text: currentData['bidang_keahlian']);
    final TextEditingController controller5 =
        TextEditingController(text: currentData['jabatan_akademik']);
    final TextEditingController controller6 =
        TextEditingController(text: currentData['sertifikat_pendidik']);
    final TextEditingController controller7 =
        TextEditingController(text: currentData['sertifikat_kompetensi']);
    final TextEditingController controller8 =
        TextEditingController(text: currentData['mk_diampu']);

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
                TextField(
                  controller: controller1,
                  decoration: const InputDecoration(labelText: "Nama Dosen"),
                ),
                TextField(
                  controller: controller2,
                  decoration: const InputDecoration(labelText: "NIDN/NIDK"),
                ),
                TextField(
                  controller: controller3,
                  decoration: const InputDecoration(
                      labelText: "Pendidikan Pasca Sarjana"),
                ),
                TextField(
                  controller: controller4,
                  decoration:
                      const InputDecoration(labelText: "Bidang Keahlian"),
                ),
                TextField(
                  controller: controller5,
                  decoration:
                      const InputDecoration(labelText: "Jabatan Akademik"),
                ),
                TextField(
                  controller: controller6,
                  decoration: const InputDecoration(
                      labelText: "Sertifikat Pendidik Profesional"),
                ),
                TextField(
                  controller: controller7,
                  decoration: const InputDecoration(
                      labelText: "Sertifikat Kompetensi/Profesi/Industri"),
                ),
                TextField(
                  controller: controller8,
                  decoration: const InputDecoration(
                      labelText: "Mata Kuliah yang Diampu pada PS"),
                ),
                DropdownButtonFormField<String>(
                  value: selectedKesesuaianBidangKeahlian,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedKesesuaianBidangKeahlian = newValue;
                    });
                  },
                  items: yesNoOptions
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                      labelText:
                          "Kesesuaian Bidang Keahlian dengan Mata Kuliah yang Diampu"),
                ),
                const SizedBox(height: 10),
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
                  'nidn_nidk': controller2.text,
                  'pendidikan_pascasarjana': controller3.text,
                  'bidang_keahlian': controller4.text,
                  'jabatan_akademik': controller5.text,
                  'sertifikat_pendidik': controller6.text,
                  'sertifikat_kompetensi': controller7.text,
                  'mk_diampu': controller8.text,
                  'kesesuaian_keahlian_mk':
                      selectedKesesuaianBidangKeahlian == "Ya",
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
