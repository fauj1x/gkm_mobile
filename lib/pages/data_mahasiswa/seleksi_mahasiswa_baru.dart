import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/seleksi_mahasiswa_baru.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeleksiMahasiswaBaru extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const SeleksiMahasiswaBaru({Key? key, required this.tahunAjaran})
      : super(key: key);
  @override
  SeleksiMahasiswaBaruState createState() => SeleksiMahasiswaBaruState();
}

class SeleksiMahasiswaBaruState extends State<SeleksiMahasiswaBaru> {
  List<SeleksiMahasiswaBaruModel> dataList = [];
  ApiService apiService = ApiService();
  String menuName = "Seleksi Mahasiswa Baru";
  String subMenuName = "";
  String endPoint = "seleksi-maba";
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
          SeleksiMahasiswaBaruModel.fromJson, endPoint);
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
          SeleksiMahasiswaBaruModel.fromJson, newData, endPoint);
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
          SeleksiMahasiswaBaruModel.fromJson, index, updatedData, endPoint);
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
                                _headerCell("Tahun Akademik", 100),
                                _headerCell("Daya Tampung", 100),
                                _headerCell("Jumlah Calon Mahasiswa", 200),
                                _headerCell("Jumlah Mahasiswa Baru", 200),
                                _headerCell("Jumlah Mahasiswa Aktif", 200),
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),

                          // Header Baris 2 (Tingkat)
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _emptyCell(100),
                                _emptyCell(100),
                                _headerCell("Pendaftar", 100),
                                _headerCell("Lulus Seleksi", 100),
                                _headerCell("Reguler", 100),
                                _headerCell("Transfer", 100),
                                _headerCell("Reguler", 100),
                                _headerCell("Transfer", 100),
                                _emptyCell(50),
                              ],
                            ),
                          ),

                          // Isi Data
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(100),
                              1: FixedColumnWidth(100),
                              2: FixedColumnWidth(100),
                              3: FixedColumnWidth(100),
                              4: FixedColumnWidth(100),
                              5: FixedColumnWidth(100),
                              6: FixedColumnWidth(100),
                              7: FixedColumnWidth(100),
                              8: FixedColumnWidth(50),
                            },
                            children: dataList.asMap().entries.map((entry) {
                              List<String> row = [
                                entry.value.tahunAkademik,
                                entry.value.dayaTampung.toString(),
                                entry.value.pendaftar.toString(),
                                entry.value.lulusSeleksi.toString(),
                                entry.value.mabaReguler.toString(),
                                entry.value.mabaTransfer.toString(),
                                entry.value.mhsAktifReguler.toString(),
                                entry.value.mhsAktifTransfer.toString(),
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
                                              'tahun_akademik':
                                                  entry.value.tahunAkademik,
                                              'daya_tampung':
                                                  entry.value.dayaTampung,
                                              'pendaftar':
                                                  entry.value.pendaftar,
                                              'lulus_seleksi':
                                                  entry.value.lulusSeleksi,
                                              'maba_reguler':
                                                  entry.value.mabaReguler,
                                              'maba_transfer':
                                                  entry.value.mabaTransfer,
                                              'mhs_aktif_reguler':
                                                  entry.value.mhsAktifReguler,
                                              'mhs_aktif_transfer':
                                                  entry.value.mhsAktifTransfer,
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
    final TextEditingController controller1Controller = TextEditingController();
    final TextEditingController controller2Controller = TextEditingController();
    final TextEditingController controller3Controller = TextEditingController();
    final TextEditingController controller4Controller = TextEditingController();
    final TextEditingController controller5Controller = TextEditingController();
    final TextEditingController controller6Controller = TextEditingController();
    final TextEditingController controller7Controller = TextEditingController();
    final TextEditingController controller8Controller = TextEditingController();

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
                    decoration: const InputDecoration(labelText: 'Tahun Akademik')),
                TextField(
                    controller: controller2Controller,
                    decoration: const InputDecoration(labelText: 'Daya Tampung')),
                TextField(
                    controller: controller3Controller,
                    decoration: const InputDecoration(labelText: 'Pendaftar')),
                TextField(
                    controller: controller4Controller,
                    decoration: const InputDecoration(labelText: 'Lulus Seleksi')),
                TextField(
                    controller: controller5Controller,
                    decoration:
                        const InputDecoration(labelText: 'Mahasiswa Baru Reguler')),
                TextField(
                    controller: controller6Controller,
                    decoration:
                        const InputDecoration(labelText: 'Mahasiswa Baru Transfer')),
                TextField(
                    controller: controller7Controller,
                    decoration:
                        const InputDecoration(labelText: 'Mahasiswa Aktif Reguler')),
                TextField(
                    controller: controller8Controller,
                    decoration:
                        const InputDecoration(labelText: 'Mahasiswa Aktif Transfer')),
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
                  'tahun_akademik': controller1Controller.text,
                  'daya_tampung': int.parse(controller2Controller.text),
                  'pendaftar': int.parse(controller3Controller.text),
                  'lulus_seleksi': int.parse(controller4Controller.text),
                  'maba_reguler': int.parse(controller5Controller.text),
                  'maba_transfer': int.parse(controller6Controller.text),
                  'mhs_aktif_reguler': int.parse(controller7Controller.text),
                  'mhs_aktif_transfer': int.parse(controller8Controller.text),
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
        TextEditingController(text: currentData['tahun_akademik']);
    final TextEditingController controller2Controller =
        TextEditingController(text: currentData['daya_tampung'].toString());
    final TextEditingController controller3Controller =
        TextEditingController(text: currentData['pendaftar'].toString());
    final TextEditingController controller4Controller =
        TextEditingController(text: currentData['lulus_seleksi'].toString());
    final TextEditingController controller5Controller =
        TextEditingController(text: currentData['maba_reguler'].toString());
    final TextEditingController controller6Controller =
        TextEditingController(text: currentData['maba_transfer'].toString());
    final TextEditingController controller7Controller = TextEditingController(
        text: currentData['mhs_aktif_reguler'].toString());
    final TextEditingController controller8Controller = TextEditingController(
        text: currentData['mhs_aktif_transfer'].toString());

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
                    decoration: const InputDecoration(labelText: 'Tahun Akademik')),
                TextField(
                    controller: controller2Controller,
                    decoration: const InputDecoration(labelText: 'Daya Tampung')),
                TextField(
                    controller: controller3Controller,
                    decoration: const InputDecoration(labelText: 'Pendaftar')),
                TextField(
                    controller: controller4Controller,
                    decoration: const InputDecoration(labelText: 'Lulus Seleksi')),
                TextField(
                    controller: controller5Controller,
                    decoration:
                        const InputDecoration(labelText: 'Mahasiswa Baru Reguler')),
                TextField(
                    controller: controller6Controller,
                    decoration:
                        const InputDecoration(labelText: 'Mahasiswa Baru Transfer')),
                TextField(
                    controller: controller7Controller,
                    decoration:
                        const InputDecoration(labelText: 'Mahasiswa Aktif Reguler')),
                TextField(
                    controller: controller8Controller,
                    decoration:
                        const InputDecoration(labelText: 'Mahasiswa Aktif Transfer')),
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
                  'tahun_akademik': controller1Controller.text,
                  'daya_tampung': int.parse(controller2Controller.text),
                  'pendaftar': int.parse(controller3Controller.text),
                  'lulus_seleksi': int.parse(controller4Controller.text),
                  'maba_reguler': int.parse(controller5Controller.text),
                  'maba_transfer': int.parse(controller6Controller.text),
                  'mhs_aktif_reguler': int.parse(controller7Controller.text),
                  'mhs_aktif_transfer': int.parse(controller8Controller.text),
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
