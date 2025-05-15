import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/pengakuan_rekognisi_dosen.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengakuanRekognisiDosen extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const PengakuanRekognisiDosen({Key? key, required this.tahunAjaran}) : super(key: key);
  @override
  PengakuanRekognisiDosenState createState() => PengakuanRekognisiDosenState();
}

class PengakuanRekognisiDosenState extends State<PengakuanRekognisiDosen> {
  // final List<String> yesNoOptions = ['Tidak', 'Ya'];
  List<PengakuanRekognisiDosenModel> dataList = [];
  ApiService apiService = ApiService();
  String menuName = "Kinerja Dosen";
  String subMenuName = "Pengakuan/Rekognisi DTPS";
  String endPoint = "kinerja-rekognisi";
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
          await apiService.getData(PengakuanRekognisiDosenModel.fromJson, endPoint);
      setState(() {
        dataList = data;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> _addData(Map<String, dynamic> newData) async {
    try {
      await apiService.postData(PengakuanRekognisiDosenModel.fromJson, newData, endPoint);
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
          PengakuanRekognisiDosenModel.fromJson, index, updatedData, endPoint);
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
                                _headerCell("Bidang Keahlian", 100),
                                _headerCell(
                                    "Nama Rekognisi", 100),
                                _headerCell(
                                    "Bukti Pendukung", 100),
                                _headerCell("Tingkat", 375),
                                _headerCell("Tahun (YYYY)", 100),
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),

                          // Header Baris 2 (Tingkat)
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _emptyCell(450),
                                _headerCell("Wilayah", 125),
                                _headerCell("Nasional", 125),
                                _headerCell("Internasional", 125),
                                _emptyCell(150),
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
                              5: FixedColumnWidth(125),
                              6: FixedColumnWidth(125),
                              7: FixedColumnWidth(125),
                              8: FixedColumnWidth(100),
                              9: FixedColumnWidth(50),
                            },
                            children: dataList.asMap().entries.map((entry) {
                              List<String> row = [
                                (entry.key + 1).toString(),
                                entry.value.namaDosen,
                                entry.value.bidangKeahlian,
                                entry.value.namaRekognisi,
                                entry.value.buktiPendukung,
                                entry.value.tingkat == "internasional"
                                    ? "✅"
                                    : "", // Tingkat: Internasional
                                entry.value.tingkat == "nasional"
                                    ? "✅"
                                    : "", // Tingkat: Nasional
                                entry.value.tingkat == "lokal"
                                    ? "✅"
                                    : "", // Tingkat: Wilayah/Lokal
                                entry.value.tahun,
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
                                              "id": entry.value.id,
                                              "user_id": entry.value.userId,
                                              "nama_dosen": entry.value.namaDosen,
                                              "bidang_keahlian":
                                                  entry.value.bidangKeahlian,
                                              "nama_rekognisi":
                                                  entry.value.namaRekognisi,
                                              "bukti_pendukung":
                                                  entry.value.buktiPendukung,
                                              "tingkat": entry.value.tingkat,
                                              "tahun": entry.value.tahun,
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
    return SizedBox(width: width, height: 40);
  }

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
                // Form input fields
                TextField(
                  controller: controller1,
                  decoration: const InputDecoration(
                    labelText: 'Nama Dosen',
                  ),
                ),
                TextField(
                  controller: controller2,
                  decoration: const InputDecoration(
                    labelText: 'Bidang Keahlian',
                  ),
                ),
                TextField(
                  controller: controller3,
                  decoration: const InputDecoration(
                    labelText: 'Nama Rekognisi',
                  ),
                ),
                TextField(
                  controller: controller4,
                  decoration: const InputDecoration(
                    labelText: 'Bukti Pendukung',
                  ),
                ),
                TextField(
                  controller: controller5,
                  decoration: const InputDecoration(
                    labelText: 'Tingkat',
                  ),
                ),
                TextField(
                  controller: controller6,
                  decoration: const InputDecoration(
                    labelText: 'Tahun (YYYY)',
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
                  "user_id": userId,
                  "nama_dosen": controller1.text,
                  "bidang_keahlian": controller2.text,
                  "nama_rekognisi": controller3.text,
                  "bukti_pendukung": controller4.text,
                  "tingkat": controller5.text,
                  "tahun": controller6.text,
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

    controller1.text = currentData['nama_dosen'] ?? '';
    controller2.text = currentData['bidang_keahlian'] ?? '';
    controller3.text = currentData['nama_rekognisi'] ?? '';
    controller4.text = currentData['bukti_pendukung'] ?? '';
    controller5.text = currentData['tingkat'] ?? '';
    controller6.text = currentData['tahun'] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Form input fields
                TextField(
                  controller: controller1,
                  decoration: const InputDecoration(
                    labelText: 'Nama Dosen',
                  ),
                ),
                TextField(
                  controller: controller2,
                  decoration: const InputDecoration(
                    labelText: 'Bidang Keahlian',
                  ),
                ),
                TextField(
                  controller: controller3,
                  decoration: const InputDecoration(
                    labelText: 'Nama Rekognisi',
                  ),
                ),
                TextField(
                  controller: controller4,
                  decoration: const InputDecoration(
                    labelText: 'Bukti Pendukung',
                  ),
                ),
                TextField(
                  controller: controller5,
                  decoration: const InputDecoration(
                    labelText: 'Tingkat',
                  ),
                ),
                TextField(
                  controller: controller6,
                  decoration: const InputDecoration(
                    labelText: 'Tahun (YYYY)',
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
                  "id": id,
                  "user_id": userId,
                  "nama_dosen": controller1.text,
                  "bidang_keahlian": controller2.text,
                  "nama_rekognisi": controller3.text,
                  "bukti_pendukung": controller4.text,
                  "tingkat": controller5.text,
                  "tahun": controller6.text,
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
