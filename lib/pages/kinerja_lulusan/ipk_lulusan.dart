import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/kinerjalulusan_ipk.dart'; // Sesuaikan path ini jika perlu
import 'package:gkm_mobile/models/tahun_ajaran.dart'; // Jika masih relevan, pertahankan
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IpkLulusan extends StatefulWidget {
  // Jika tahunAjaran tidak digunakan, bisa dihapus atau disesuaikan
  final TahunAjaran? tahunAjaran; 
  const IpkLulusan({Key? key, this.tahunAjaran}) : super(key: key);

  @override
  IpkLulusanState createState() => IpkLulusanState();
}

class IpkLulusanState extends State<IpkLulusan> {
  List<IpkLulusanModel> dataList = [];
  ApiService apiService = ApiService();
  String menuName = "Data IPK Lulusan";
  String subMenuName = ""; // Biarkan kosong jika tidak ada sub-menu
  String endPoint = "ipk-lulusan"; // Endpoint API untuk IPK Lulusan
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

  Future<void> _fetchData() async {
    try {
      final data = await apiService.getData(IpkLulusanModel.fromJson, endPoint);
      setState(() {
        dataList = data;
      });
    } catch (e) {
      print("Error fetching data: $e");
      // Tampilkan SnackBar atau dialog kepada user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data: $e')),
      );
    }
  }

  Future<void> _addData(Map<String, dynamic> newData) async {
    try {
      await apiService.postData(IpkLulusanModel.fromJson, newData, endPoint);
      _fetchData(); // Refresh data setelah menambahkan
    } catch (e) {
      print("Error adding data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan data: $e')),
      );
    }
  }

  Future<void> _deleteData(int id) async {
    try {
      await apiService.deleteData(id, endPoint);
      _fetchData(); // Refresh data setelah menghapus
    } catch (e) {
      print("Error deleting data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data: $e')),
      );
    }
  }

  Future<void> _editData(int id, Map<String, dynamic> updatedData) async {
    try {
      await apiService.updateData(IpkLulusanModel.fromJson, id, updatedData, endPoint);
      _fetchData(); // Refresh data setelah mengedit
    } catch (e) {
      print("Error editing data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengedit data: $e')),
      );
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
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                          // Header Tabel
                          Container(
                            color: Colors.teal,
                            child: Row(
                              children: [
                                _headerCell("No.", 50),
                                _headerCell("Tahun", 100),
                                _headerCell("Jumlah Lulusan", 120),
                                _headerCell("IPK Minimal", 100),
                                _headerCell("IPK Maksimal", 100),
                                _headerCell("IPK Rata-Rata", 120),
                                _headerCell("Aksi", 80),
                              ],
                            ),
                          ),

                          // Isi Data Tabel
                          Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: const {
                              0: FixedColumnWidth(50),
                              1: FixedColumnWidth(100),
                              2: FixedColumnWidth(120),
                              3: FixedColumnWidth(100),
                              4: FixedColumnWidth(100),
                              5: FixedColumnWidth(120),
                              6: FixedColumnWidth(80),
                            },
                            children: dataList.asMap().entries.map((entry) {
                              final data = entry.value; // Ambil objek model langsung
                              return TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text((entry.key + 1).toString())),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.tahun)),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.jumlahLulusan.toString())),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.ipkMinimal.toStringAsFixed(2))), // Format ke 2 desimal
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.ipkMaksimal.toStringAsFixed(2))), // Format ke 2 desimal
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(data.ipkRataRata.toStringAsFixed(2))), // Format ke 2 desimal
                                    ),
                                  ),
                                  // Aksi Button
                                  TableCell(
                                    child: Center(
                                      child: PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert, color: Colors.black87),
                                        onSelected: (String choice) {
                                          if (choice == "Edit") {
                                            _showEditDialog(data.id, data); // Meneruskan objek model
                                          } else if (choice == "Hapus") {
                                            _deleteData(data.id);
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<String>>[
                                          const PopupMenuItem<String>(
                                            value: "Edit",
                                            child: ListTile(
                                              leading: Icon(Icons.edit, color: Colors.blue),
                                              title: Text("Edit"),
                                            ),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: "Hapus",
                                            child: ListTile(
                                              leading: Icon(Icons.delete, color: Colors.red),
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
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54), // Menambahkan border
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showAddDialog() {
    final TextEditingController tahunController = TextEditingController();
    final TextEditingController jumlahLulusanController = TextEditingController();
    final TextEditingController ipkMinimalController = TextEditingController();
    final TextEditingController ipkMaksimalController = TextEditingController();
    final TextEditingController ipkRataRataController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data IPK Lulusan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tahunController,
                  decoration: const InputDecoration(labelText: 'Tahun'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: ipkMinimalController,
                  decoration: const InputDecoration(labelText: 'IPK Minimal'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Untuk input desimal
                ),
                TextField(
                  controller: ipkMaksimalController,
                  decoration: const InputDecoration(labelText: 'IPK Maksimal'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Untuk input desimal
                ),
                TextField(
                  controller: ipkRataRataController,
                  decoration: const InputDecoration(labelText: 'IPK Rata-Rata'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Untuk input desimal
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
                // Validasi input
                if (tahunController.text.isEmpty ||
                    jumlahLulusanController.text.isEmpty ||
                    ipkMinimalController.text.isEmpty ||
                    ipkMaksimalController.text.isEmpty ||
                    ipkRataRataController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua bidang harus diisi')),
                  );
                  return;
                }

                _addData({
                  'user_id': userId,
                  'tahun': tahunController.text,
                  'jumlah_lulusan': int.tryParse(jumlahLulusanController.text) ?? 0,
                  'ipk_minimal': double.tryParse(ipkMinimalController.text) ?? 0.0,
                  'ipk_maksimal': double.tryParse(ipkMaksimalController.text) ?? 0.0,
                  'ipk_rata_rata': double.tryParse(ipkRataRataController.text) ?? 0.0,
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

  void _showEditDialog(int id, IpkLulusanModel currentData) {
    final TextEditingController tahunController = TextEditingController(text: currentData.tahun);
    final TextEditingController jumlahLulusanController = TextEditingController(text: currentData.jumlahLulusan.toString());
    final TextEditingController ipkMinimalController = TextEditingController(text: currentData.ipkMinimal.toString());
    final TextEditingController ipkMaksimalController = TextEditingController(text: currentData.ipkMaksimal.toString());
    final TextEditingController ipkRataRataController = TextEditingController(text: currentData.ipkRataRata.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data IPK Lulusan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tahunController,
                  decoration: const InputDecoration(labelText: 'Tahun'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: jumlahLulusanController,
                  decoration: const InputDecoration(labelText: 'Jumlah Lulusan'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: ipkMinimalController,
                  decoration: const InputDecoration(labelText: 'IPK Minimal'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                TextField(
                  controller: ipkMaksimalController,
                  decoration: const InputDecoration(labelText: 'IPK Maksimal'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                TextField(
                  controller: ipkRataRataController,
                  decoration: const InputDecoration(labelText: 'IPK Rata-Rata'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                // Validasi input
                if (tahunController.text.isEmpty ||
                    jumlahLulusanController.text.isEmpty ||
                    ipkMinimalController.text.isEmpty ||
                    ipkMaksimalController.text.isEmpty ||
                    ipkRataRataController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua bidang harus diisi')),
                  );
                  return;
                }

                _editData(id, {
                  'id': id, // Pastikan ID dikirim kembali untuk update
                  'user_id': userId,
                  'tahun': tahunController.text,
                  'jumlah_lulusan': int.tryParse(jumlahLulusanController.text) ?? 0,
                  'ipk_minimal': double.tryParse(ipkMinimalController.text) ?? 0.0,
                  'ipk_maksimal': double.tryParse(ipkMaksimalController.text) ?? 0.0,
                  'ipk_rata_rata': double.tryParse(ipkRataRataController.text) ?? 0.0,
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