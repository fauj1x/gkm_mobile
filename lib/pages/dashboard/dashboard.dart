import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/pages/ubahdata/ubahdata.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:gkm_mobile/services/auth.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ApiService apiService = ApiService();
  List<TahunAjaran> tahunAjaranList = [];

  Future<void> _fetchTahunAjaran() async {
    var data = await apiService.getData(TahunAjaran.fromJson, "tahun-ajaran");
    data = data.reversed.toList();
    setState(() {
      tahunAjaranList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTahunAjaran();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exitConfirmed = await _showExitPopup(context);
        return exitConfirmed;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // HEADER / PROFIL
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.person, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'KOKO Faisal',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Dosen',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // KOTAK INFO (disesuaikan dengan desain dari gambar)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TEKS
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat Datang, Administrator! 🎉',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Lihat perkembangan terbaru dan kelola data dengan mudah di sini!',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 36,
                              child: OutlinedButton(
                                onPressed: () {
                                  // Aksi ketika tombol ditekan
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.indigo.shade400),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Selengkapnya',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.indigo.shade400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // ILUSTRASI GAMBAR
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              'assets/images/ilustrasi_dashboard.png',
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // TABEL DATA
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Tombol Import (kiri)
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  dynamic rawId = await AuthProvider().getId();
                                  int userId = rawId is int ? rawId : int.tryParse(rawId.toString()) ?? 0;
                                  _openExcelImportDialog(context, userId);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: Colors.teal.shade700, width: 1.5),
                                  ),
                                ),
                                icon: Icon(Icons.upload_file, color: Colors.teal[700]),
                                label: Text(
                                  'Import Excel',
                                  style: GoogleFonts.poppins(
                                    color: Colors.teal[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          // Tombol Export (kanan)
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Ganti dengan fungsi export kamu
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal.shade700,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: Icon(Icons.download, color: Colors.white),
                                label: Text(
                                  'Export Excel',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Tahun Ajaran',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Semester',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Aksi',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 16),
                      for (var tahunAjaran in tahunAjaranList) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0), // Space antar baris
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    tahunAjaran.tahunAjaran,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    (tahunAjaran.semester == 'ganjil')
                                        ? 'Ganjil'
                                        : 'Genap',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 40,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => UbahData(tahunAjaran: tahunAjaran),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.teal[700],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            elevation: 2,
                                          ),
                                          icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                                          label: Text(
                                            'Ubah Data',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openExcelImportDialog(BuildContext context, int userId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      withData: true, // <-- Tambahkan ini
    );

    if (result != null) {
      String fileName = result.files.single.name;
      String filePath = result.files.single.path ?? '';
      print("DEBUG: filePath: $filePath");
      Uint8List? fileBytes = result.files.single.bytes;

      if (fileBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal membaca file, coba lagi.")),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Konfirmasi Import',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Apakah Anda ingin mengimpor file:\n\n$fileName',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: GoogleFonts.poppins()),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();

                try {
                  final response = await apiService.importExcel(
                    userId: userId,
                    filePath: filePath,
                  );

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      title: Text(
                        'Import Berhasil',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        'File berhasil diimpor ke sistem.',
                        style: GoogleFonts.poppins(),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal[700],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('OK', style: GoogleFonts.poppins(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      title: Text(
                        'Import Gagal',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        'Terjadi kesalahan saat mengimpor file:\n\n$e',
                        style: GoogleFonts.poppins(),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('OK', style: GoogleFonts.poppins(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Import', style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File tidak dipilih atau path null")),
      );
    }
  }

  Future<bool> _showExitPopup(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'Konfirmasi Keluar',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00B98F),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Keluar',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    ) ?? false;
  }
}