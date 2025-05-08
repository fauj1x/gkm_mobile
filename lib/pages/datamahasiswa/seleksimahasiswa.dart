import 'package:flutter/material.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'model.dart';
import 'package:gkm_mobile/pages/datamahasiswa/model.dart';

class SeleksiMahasiswaBaruScreen extends StatefulWidget {
  @override
  _SeleksiMahasiswaBaruScreenState createState() => _SeleksiMahasiswaBaruScreenState();
}

class _SeleksiMahasiswaBaruScreenState extends State<SeleksiMahasiswaBaruScreen> {
  List<SeleksiMahasiswaBaru> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService().getData(
        (json) => SeleksiMahasiswaBaru.fromJson(json),
        "seleksi_mahasiswa_baru",
      );
      setState(() {
        _data = data;
      });
    } catch (e) {
      print(e);
    }
    setState(() => _isLoading = false);
  }

  void _showForm({SeleksiMahasiswaBaru? item}) {
    final TextEditingController tahunAkademikController = TextEditingController(text: item?.tahunAkademik ?? '');
    final TextEditingController dayaTampungController = TextEditingController(text: item?.dayaTampung.toString() ?? '');
    final TextEditingController pendaftarController = TextEditingController(text: item?.pendaftar.toString() ?? '');
    final TextEditingController lulusSeleksiController = TextEditingController(text: item?.lulusSeleksi.toString() ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item == null ? 'Tambah Data' : 'Edit Data'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: tahunAkademikController,
                decoration: InputDecoration(labelText: 'Tahun Akademik'),
              ),
              TextField(
                controller: dayaTampungController,
                decoration: InputDecoration(labelText: 'Daya Tampung'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: pendaftarController,
                decoration: InputDecoration(labelText: 'Pendaftar'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: lulusSeleksiController,
                decoration: InputDecoration(labelText: 'Lulus Seleksi'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Simpan'),
            onPressed: () async {
              final newData = SeleksiMahasiswaBaru(
                userId: 1,
                tahunAjaranId: 1,
                tahunAkademik: tahunAkademikController.text,
                dayaTampung: int.parse(dayaTampungController.text),
                pendaftar: int.parse(pendaftarController.text),
                lulusSeleksi: int.parse(lulusSeleksiController.text),
                mabaReguler: 0,
                mabaTransfer: 0,
                mhsAktifReguler: 0,
                mhsAktifTransfer: 0,
              );

              try {
                if (item == null) {
                  await ApiService().postData(
                    (json) => SeleksiMahasiswaBaru.fromJson(json),
                    newData.toJson(),
                    "seleksi_mahasiswa_baru",
                  );
                } else {
                  await ApiService().updateData(
                    (json) => SeleksiMahasiswaBaru.fromJson(json),
                    item.id!,
                    newData.toJson(),
                    "seleksi_mahasiswa_baru",
                  );
                }
                Navigator.pop(context);
                _loadData();
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(int id) async {
    try {
      await ApiService().deleteData(id, "seleksi_mahasiswa_baru");
      _loadData();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleksi Mahasiswa Baru'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Tahun Akademik')),
                  DataColumn(label: Text('Daya Tampung')),
                  DataColumn(label: Text('Pendaftar')),
                  DataColumn(label: Text('Lulus Seleksi')),
                  DataColumn(label: Text('Aksi')),
                ],
                rows: _data.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(item.id.toString())),
                    DataCell(Text(item.tahunAkademik)),
                    DataCell(Text(item.dayaTampung.toString())),
                    DataCell(Text(item.pendaftar.toString())),
                    DataCell(Text(item.lulusSeleksi.toString())),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showForm(item: item),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteItem(item.id!),
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showForm(),
      ),
    );
  }
}
