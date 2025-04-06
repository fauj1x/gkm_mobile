import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/dosen_praktisi.dart';
import 'package:gkm_mobile/services/api_services.dart';

class TestApiPage extends StatefulWidget {
  const TestApiPage({Key? key}) : super(key: key);

  @override
  State<TestApiPage> createState() => _TestApiPageState();
}

class _TestApiPageState extends State<TestApiPage> {
  List<DosenPraktisi> _dosenList = [];
  bool _isLoading = true;
  int? _selectedId;

  @override
  void initState() {
    super.initState();
    _fetchDosenPraktisi();
  }

  Future<void> _fetchDosenPraktisi() async {
    try {
      final data = await ApiService().getData<DosenPraktisi>(
        DosenPraktisi.fromJson,
        customEndpoint: "dosen-praktisi",
      );
      setState(() {
        _dosenList = data;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() => _isLoading = false);
    }
  }

  void _addDosenPraktisi() {
    final namaController = TextEditingController();
    final nidkController = TextEditingController();
    final perusahaanController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Dosen Praktisi'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: namaController, decoration: const InputDecoration(labelText: 'Nama Dosen')),
                TextField(controller: nidkController, decoration: const InputDecoration(labelText: 'NIDK')),
                TextField(controller: perusahaanController, decoration: const InputDecoration(labelText: 'Perusahaan')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () async {
                setState(() => _isLoading = true);
                final body = {
                  "nama_dosen": namaController.text,
                  "nidk": nidkController.text,
                  "perusahaan": perusahaanController.text,
                  "user_id": 1,
                  "tahun_ajaran_id": 1,
                  "pendidikan_tertinggi": "S2",
                  "bidang_keahlian": "Teknik Informatika",
                  "sertifikat_kompetensi": "Sertifikat",
                  "mk_diampu": "5",
                  "bobot_kredit_sks": 3.0,
                };

                try {
                  await ApiService().postData<DosenPraktisi>(
                    DosenPraktisi.fromJson,
                    body,
                    customEndpoint: "dosen-praktisi",
                  );
                  Navigator.pop(context);
                  _fetchDosenPraktisi();
                } catch (e) {
                  print("Error adding data: $e");
                  Navigator.pop(context);
                  setState(() => _isLoading = false);
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _updateDosenPraktisi(DosenPraktisi dosen) {
    final namaController = TextEditingController(text: dosen.namaDosen);
    final nidkController = TextEditingController(text: dosen.nidk);
    final perusahaanController = TextEditingController(text: dosen.perusahaan);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Dosen Praktisi'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: namaController, decoration: const InputDecoration(labelText: 'Nama Dosen')),
                TextField(controller: nidkController, decoration: const InputDecoration(labelText: 'NIDK')),
                TextField(controller: perusahaanController, decoration: const InputDecoration(labelText: 'Perusahaan')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () async {
                setState(() => _isLoading = true);
                final body = {
                  "nama_dosen": namaController.text,
                  "nidk": nidkController.text,
                  "perusahaan": perusahaanController.text,
                  "user_id": dosen.userId,
                  "tahun_ajaran_id": dosen.tahunAjaranId,
                  "pendidikan_tertinggi": dosen.pendidikanTertinggi,
                  "bidang_keahlian": dosen.bidangKeahlian,
                  "sertifikat_kompetensi": dosen.sertifikatKompetensi,
                  "mk_diampu": dosen.mkDiampu.toString(),
                  "bobot_kredit_sks": dosen.bobotKreditSks,
                };
                try {
                  await ApiService().updateData<DosenPraktisi>(
                    DosenPraktisi.fromJson,
                    dosen.id,
                    body,
                    customEndpoint: "dosen-praktisi",
                  );
                  Navigator.pop(context);
                  _fetchDosenPraktisi();
                } catch (e) {
                  print("Error updating data: $e");
                  Navigator.pop(context);
                  setState(() => _isLoading = false);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteDosenPraktisi(int id) async {
    setState(() => _isLoading = true);
    try {
      await ApiService().deleteData<DosenPraktisi>(
        id,
        customEndpoint: "dosen-praktisi",
      );
      _fetchDosenPraktisi();
    } catch (e) {
      print("Error deleting data: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Dosen Praktisi')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dosenList.isEmpty
          ? const Center(child: Text('Tidak ada data'))
          : ListView.builder(
        itemCount: _dosenList.length,
        itemBuilder: (context, index) {
          final dosen = _dosenList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                dosen.namaDosen,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Perusahaan: ${dosen.perusahaan}"),
                  Text("Bidang: ${dosen.bidangKeahlian}"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      setState(() => _selectedId = dosen.id);
                      _updateDosenPraktisi(dosen);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteDosenPraktisi(dosen.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDosenPraktisi,
        child: const Icon(Icons.add),
      ),
    );
  }
}
