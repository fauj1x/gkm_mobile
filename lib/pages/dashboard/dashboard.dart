import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // Digunakan untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/pages/ubahdata/ubahdata.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:gkm_mobile/services/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gkm_mobile/models/user_profiles.dart'; // Menggunakan user_profiles.dart sesuai permintaan
import 'package:gkm_mobile/pages/dashboard/profil.dart'; // Menggunakan profil.dart sesuai permintaan (asumsi ini UserProfileFormScreen)
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Diperlukan untuk SharedPreferences

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ApiService apiService = ApiService();
  List<TahunAjaran> tahunAjaranList = [];

  UserProfile? _userProfile; // Variabel untuk menyimpan data profil pengguna
  bool _isLoadingProfile = true; // Status loading data profil

  @override
  void initState() {
    super.initState();
    _fetchTahunAjaran();
    _fetchUserProfile(); // Panggil fungsi untuk mengambil profil saat initState
  }

  Future<void> _fetchTahunAjaran() async {
    try {
      var data = await apiService.getData(TahunAjaran.fromJson, "tahun-ajaran");
      data = data.reversed.toList();
      setState(() {
        tahunAjaranList = data;
      });
    } catch (e) {
      print("Error fetching tahun ajaran: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data Tahun Ajaran: $e')),
      );
    }
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoadingProfile = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = int.tryParse(prefs.getString('id') ?? '0') ?? 0;

      if (userId != 0) {
        // Menggunakan endpoint "pkm-mahasiswa" sesuai permintaan Anda
        final List<UserProfile> profiles =
            await apiService.getData(UserProfile.fromJson, "user-profiles");

        if (profiles.isNotEmpty) {
          _userProfile = profiles.firstWhere(
            (profile) => profile.userId == userId,
            orElse: () => UserProfile(
              // Default jika tidak ditemukan di antara profil yang ada
              id: 0, userId: userId, nip: '', nik: '', nidn: '',
              nama: 'Pengguna',
              jabatanFungsional: 'Tidak Diketahui', jabatanId: 0, handphone: '',
            ),
          );
        } else {
          // Jika list profiles kosong dari API, buat profil default
          _userProfile = UserProfile(
            id: 0,
            userId: userId,
            nip: '',
            nik: '',
            nidn: '',
            nama: 'Pengguna',
            jabatanFungsional: 'Tidak Diketahui',
            jabatanId: 0,
            handphone: '',
          );
        }
      } else {
        // Jika userId tidak ditemukan di SharedPreferences
        _userProfile = UserProfile(
          id: 0,
          userId: 0,
          nip: '',
          nik: '',
          nidn: '',
          nama: 'Tamu',
          jabatanFungsional: 'Tidak Diketahui',
          jabatanId: 0,
          handphone: '',
        );
      }
    } catch (e) {
      print("Error fetching user profile for dashboard: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat profil pengguna: $e')),
      );
      // Atur profil ke default 'Error' jika terjadi kesalahan
      _userProfile = UserProfile(
        id: 0,
        userId: 0,
        nip: '',
        nik: '',
        nidn: '',
        nama: 'Error',
        jabatanFungsional: 'Terjadi Kesalahan',
        jabatanId: 0,
        handphone: '',
      );
    } finally {
      setState(() {
        _isLoadingProfile = false;
      });
    }
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: InkWell(
                    // Menggunakan InkWell agar bisa diklik
                    onTap: () async {
                      if (_userProfile != null) {
                        // Navigasi ke UserProfileFormScreen dan tunggu hasilnya
                        // Asumsi 'profil.dart' berisi class UserProfileFormScreen
                        final bool? profileUpdated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfileFormScreen(
                                initialProfile: _userProfile),
                          ),
                        );
                        // Jika profil diperbarui, refresh data di halaman ini
                        if (profileUpdated == true) {
                          _fetchUserProfile();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Profil sedang dimuat atau tidak tersedia.')),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey[300],
                          child: _isLoadingProfile
                              ? const CircularProgressIndicator(
                                  color: Colors.teal) // Indikator loading
                              : Icon(Icons.person, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _isLoadingProfile
                                  ? Text(
                                      'Memuat...',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Text(
                                      _userProfile?.nama ??
                                          'Nama Pengguna', // Mengambil nama dari model
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              _isLoadingProfile
                                  ? Text(
                                      'Memuat...',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    )
                                  : Text(
                                      _userProfile?.jabatanFungsional ??
                                          'Jabatan', // Mengambil jabatan dari model
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
                ),

                // KOTAK INFO (disesuaikan dengan desain dari gambar)
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                              _userProfile != null
                                  ? 'Selamat Datang, ${_userProfile!.nama}! 🎉'
                                  : 'Selamat Datang! 🎉',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[700],
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
                                  side: BorderSide(color: Colors.teal.shade700),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Selengkapnya',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.teal[700],
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
                        // Mengubah SizedBox menjadi Row untuk tombol import/export
                        children: [
                          // Tombol Import (kiri)
                          Expanded(
                            child: SizedBox(
                              height: 43,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  dynamic rawId = await AuthProvider().getId();
                                  int userId = rawId is int
                                      ? rawId
                                      : int.tryParse(rawId.toString()) ?? 0;
                                  _openExcelImportDialog(context, userId);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                        color: Colors.teal.shade700,
                                        width: 1.5),
                                  ),
                                ),
                                icon: Icon(Icons.upload_file,
                                    color: Colors.teal[700]),
                                label: Text(
                                  'Import Excel', // Teks disingkat
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
                              height: 43,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  dynamic rawId = await AuthProvider().getId();
                                  int userId = rawId is int
                                      ? rawId
                                      : int.tryParse(rawId.toString()) ?? 0;
                                  await exportExcelToFile(userId: userId);
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
                                  'Export Excel', // Teks disingkat
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0), // Space antar baris
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
                                                builder: (context) => UbahData(
                                                    tahunAjaran: tahunAjaran),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.teal[700],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            elevation: 2,
                                          ),
                                          icon: const Icon(Icons.edit,
                                              size: 16, color: Colors.white),
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
    // Simpan context utama
    final mainContext = context;
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  await apiService.importExcel(
                    userId: userId,
                    filePath: filePath,
                  );

                  showDialog(
                    context: mainContext,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('OK',
                              style: GoogleFonts.poppins(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  print("Error fetching tahun ajaran: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Gagal mengambil data Tahun Ajaran: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Import',
                  style: GoogleFonts.poppins(color: Colors.white)),
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

  // Save excel file interactively
  Future<void> exportExcelToFile({
    required int userId,
  }) async {
    try {
      Uint8List bytes = await apiService.exportExcel(userId: userId);
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      String? sanitizedDir = selectedDirectory?.replaceAll(
          RegExp(r'(/Documents)+$'), '/Documents');

      if (selectedDirectory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Penyimpanan dibatalkan oleh pengguna.')),
        );
        return;
      }

      final filePath =
          '$sanitizedDir/rekap_${userId}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final file = File(filePath);

      if (await file.exists()) {
        bool? overwrite = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Konfirmasi'),
            content: Text('File sudah ada. Timpa file yang lama?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Timpa'),
              ),
            ],
          ),
        );
        if (overwrite != true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ekspor dibatalkan. File tidak ditimpa.')),
          );
          return;
        }
      }

      await file.writeAsBytes(bytes);
      print("File berhasil disimpan di: $filePath");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File berhasil diekspor ke $filePath')),
      );
    } catch (e) {
      print("Error exporting Excel file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengekspor file: $e')),
      );
    }
  }

  Future<bool> _showExitPopup(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        ) ??
        false;
  }
}
