import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/kerjasama_tridharma_aio.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pendidikan extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const Pendidikan({Key? key, required this.tahunAjaran}) : super(key: key);
  @override
  PendidikanState createState() => PendidikanState();
}

class PendidikanState extends State<Pendidikan> {
  final List<String> tingkatOptions = ['lokal', 'nasional', 'internasional'];
  List<KerjasamaTridharmaAioModel> dataList = [];
  ApiService apiService = ApiService();
  String menuName = "Kerjasama Tridharma";
  String subMenuName = "Pendidikan";
  String endPoint = "kstd-pendidikan";
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
          KerjasamaTridharmaAioModel.fromJson, endPoint);
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
          KerjasamaTridharmaAioModel.fromJson, newData, endPoint);
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
          KerjasamaTridharmaAioModel.fromJson, index, updatedData, endPoint);
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
                                _headerCell("No", 50),
                                _headerCell("Lembaga Mitra", 150),
                                _headerCell("Tingkat", 270),
                                _headerCell("Judul Kerjasama", 200),
                                _headerCell("Manfaat bagi PS", 200),
                                _headerCell("Waktu Durasi", 150),
                                _headerCell("Bukti Kerjasama", 150),
                                _headerCell("Tahun Berakhir", 150),
                                _headerCell("Aksi", 50),
                              ],
                            ),
                          ),

                          // Header Baris 2 (Tingkat)
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _emptyCell(50),
                                _emptyCell(150),
                                _headerCell("Internasional", 90),
                                _headerCell("Nasional", 90),
                                _headerCell("Wilayah/Lokal", 90),
                                _emptyCell(200),
                                _emptyCell(200),
                                _emptyCell(150),
                                _emptyCell(150),
                                _emptyCell(150),
                                _emptyCell(50),
                              ],
                            ),
                          ),

                          // Isi Data
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50),
                              1: FixedColumnWidth(150),
                              2: FixedColumnWidth(90),
                              3: FixedColumnWidth(90),
                              4: FixedColumnWidth(90),
                              5: FixedColumnWidth(200),
                              6: FixedColumnWidth(200),
                              7: FixedColumnWidth(150),
                              8: FixedColumnWidth(150),
                              9: FixedColumnWidth(150),
                              10: FixedColumnWidth(50),
                            },
                            children: dataList.asMap().entries.map((entry) {
                              List<String> row = [
                                entry.value.id.toString(), // Nomor
                                entry.value.lembagaMitra, // Lembaga Mitra
                                entry.value.tingkat == "internasional"
                                    ? "✅"
                                    : "", // Tingkat: Internasional
                                entry.value.tingkat == "nasional"
                                    ? "✅"
                                    : "", // Tingkat: Nasional
                                entry.value.tingkat == "lokal"
                                    ? "✅"
                                    : "", // Tingkat: Wilayah/Lokal
                                entry.value.judulKegiatan, // Judul Kerjasama
                                entry.value.manfaat, // Manfaat
                                entry.value.waktuDurasi, // Waktu Durasi
                                entry.value.buktiKerjasama, // Bukti Kerjasama
                                entry.value.tahunBerakhir, // Tahun Berakhir
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
                                              'lembaga_mitra':
                                                  entry.value.lembagaMitra,
                                              'tingkat': entry.value.tingkat,
                                              'judul_kegiatan':
                                                  entry.value.judulKegiatan,
                                              'manfaat': entry.value.manfaat,
                                              'bukti_kerjasama':
                                                  entry.value.buktiKerjasama,
                                              'waktu_durasi':
                                                  entry.value.waktuDurasi,
                                              'tahun_berakhir':
                                                  entry.value.tahunBerakhir,
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
    final TextEditingController lembagaController = TextEditingController();
    final TextEditingController judulController = TextEditingController();
    final TextEditingController manfaatController = TextEditingController();
    final TextEditingController waktuController = TextEditingController();
    final TextEditingController buktiController = TextEditingController();
    final TextEditingController tahunController = TextEditingController();

    String? selectedTingkat;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    controller: lembagaController,
                    decoration: const InputDecoration(labelText: 'Lembaga Mitra')),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Tingkat'),
                  value: selectedTingkat,
                  items: tingkatOptions
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                                value[0].toUpperCase() + value.substring(1)),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    selectedTingkat = newValue;
                  },
                ),
                TextField(
                    controller: judulController,
                    decoration: const InputDecoration(labelText: 'Judul Kerjasama')),
                TextField(
                    controller: manfaatController,
                    decoration: const InputDecoration(labelText: 'Manfaat')),
                TextField(
                    controller: waktuController,
                    decoration: const InputDecoration(labelText: 'Waktu Durasi')),
                TextField(
                    controller: buktiController,
                    decoration: const InputDecoration(labelText: 'Bukti Kerjasama')),
                TextField(
                    controller: tahunController,
                    decoration: const InputDecoration(labelText: 'Tahun Berakhir')),
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
                  'tahun_ajaran_id': widget.tahunAjaran.id,
                  'lembaga_mitra': lembagaController.text,
                  'tingkat': selectedTingkat ?? '',
                  'judul_kegiatan': judulController.text,
                  'manfaat': manfaatController.text,
                  'waktu_durasi': waktuController.text,
                  'bukti_kerjasama': buktiController.text,
                  'tahun_berakhir': tahunController.text,
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
    final TextEditingController lembagaController =
        TextEditingController(text: currentData['lembaga_mitra']);
    final TextEditingController judulController =
        TextEditingController(text: currentData['judul_kegiatan']);
    final TextEditingController manfaatController =
        TextEditingController(text: currentData['manfaat']);
    final TextEditingController waktuController =
        TextEditingController(text: currentData['waktu_durasi']);
    final TextEditingController buktiController =
        TextEditingController(text: currentData['bukti_kerjasama']);
    final TextEditingController tahunController =
        TextEditingController(text: currentData['tahun_berakhir']);

    String? selectedTingkat = currentData['tingkat'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    controller: lembagaController,
                    decoration: const InputDecoration(labelText: 'Lembaga Mitra')),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Tingkat'),
                  value: selectedTingkat,
                  items: tingkatOptions
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                                value[0].toUpperCase() + value.substring(1)),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    selectedTingkat = newValue;
                  },
                ),
                TextField(
                    controller: judulController,
                    decoration: const InputDecoration(labelText: 'Judul Kerjasama')),
                TextField(
                    controller: manfaatController,
                    decoration: const InputDecoration(labelText: 'Manfaat')),
                TextField(
                    controller: waktuController,
                    decoration: const InputDecoration(labelText: 'Waktu Durasi')),
                TextField(
                    controller: buktiController,
                    decoration: const InputDecoration(labelText: 'Bukti Kerjasama')),
                TextField(
                    controller: tahunController,
                    decoration: const InputDecoration(labelText: 'Tahun Berakhir')),
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
                  'lembaga_mitra': lembagaController.text,
                  'tingkat': selectedTingkat ?? '',
                  'judul_kegiatan': judulController.text,
                  'manfaat': manfaatController.text,
                  'waktu_durasi': waktuController.text,
                  'bukti_kerjasama': buktiController.text,
                  'tahun_berakhir': tahunController.text,
                  'tahun_ajaran_id': widget.tahunAjaran.id,
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
