import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/pages/ubahdata/ubahdata.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gkm_mobile/models/user_profiles.dart'; // Menggunakan user_profiles.dart sesuai permintaan
import 'package:gkm_mobile/pages/dashboard/profil.dart'; // Menggunakan profil.dart sesuai permintaan
import 'package:shared_preferences/shared_preferences.dart';

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
        // Mengubah endpoint dari "user-profile" menjadi "pkm-mahasiswa"
        final List<UserProfile> profiles = await apiService.getData(UserProfile.fromJson, "user-profiles");
        _userProfile = profiles.firstWhere(
          (profile) => profile.userId == userId,
          orElse: () => UserProfile( // Default jika tidak ditemukan
            id: 0, userId: userId, nip: '', nik: '', nidn: '', nama: 'Pengguna',
            jabatanFungsional: 'Tidak Diketahui', jabatanId: 0, handphone: '',
          ),
        );
      } else {
        _userProfile = UserProfile(
          id: 0, userId: 0, nip: '', nik: '', nidn: '', nama: 'Tamu',
          jabatanFungsional: 'Tidak Diketahui', jabatanId: 0, handphone: '',
        );
      }
    } catch (e) {
      print("Error fetching user profile for dashboard: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat profil pengguna: $e')),
      );
      _userProfile = UserProfile(
        id: 0, userId: 0, nip: '', nik: '', nidn: '', nama: 'Error',
        jabatanFungsional: 'Terjadi Kesalahan', jabatanId: 0, handphone: '',
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: InkWell( // Menggunakan InkWell agar bisa diklik
                    onTap: () async {
                      if (_userProfile != null) {
                        // Navigasi ke UserProfileFormScreen dan tunggu hasilnya
                        // Asumsi 'profil.dart' berisi class UserProfileFormScreen
                        final bool? profileUpdated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfileFormScreen(initialProfile: _userProfile),
                          ),
                        );
                        // Jika profil diperbarui, refresh data di halaman ini
                        if (profileUpdated == true) {
                          _fetchUserProfile();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profil sedang dimuat atau tidak tersedia.')),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey[300],
                          child: _isLoadingProfile
                              ? const CircularProgressIndicator(color: Colors.teal) // Indikator loading
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
                                      _userProfile?.nama ?? 'Nama Pengguna', // Mengambil nama dari model
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
                                      _userProfile?.jabatanFungsional ?? 'Jabatan', // Mengambil jabatan dari model
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Aksi untuk notifikasi
                          },
                          icon: Image.asset(
                            'assets/icons/notification.png', // Pastikan path ini benar
                            width: 24,
                            height: 24,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Aksi untuk pusat bantuan
                          },
                          icon: Image.asset(
                            'assets/icons/pusatbantuan.png', // Pastikan path ini benar
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // KOTAK INFO (disesuaikan dengan desain dari gambar)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.teal[700],
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/detail.png'), // Pastikan path ini benar
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Anda memiliki data yang belum terisi',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '1. Data Semester genap 2023 / 2024\n'
                            '2. Data Semester ganjil 2022 / 2023\n'
                            '3. Data Semester ganjil 2024 / 2025',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.teal[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              // Aksi untuk mengisi data sekarang
                            },
                            child: Text(
                              'Isi sekarang',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '45%',
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
                          mainAxisAlignment: MainAxisAlignment.end, // Mendorong ke bawah
                          crossAxisAlignment: CrossAxisAlignment.end, // Mendorong ke kanan
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
                                onPressed: () {
                                  _openExcelImportDialog(context);
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

                          SizedBox(width: 12), // Spasi antar tombol

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
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Tahun Ajaran',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Semester',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Aksi',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      for (int i = 0; i < tahunAjaranList.length; i++) ...[ // Menggunakan tahunAjaranList
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                tahunAjaranList[i].tahunAjaran, // Mengambil tahunAjaran dari model
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                tahunAjaranList[i].semester, // Mengambil semester dari model
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black54,
                                ),
                                overflow: TextOverflow.ellipsis, // Tambahkan ini jika teks terlalu panjang
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Row(
                                children: [
                                  // Tombol Ubah Data
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => UbahData(tahunAjaran: tahunAjaranList[i])),
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
                        if (i < tahunAjaranList.length - 1) const Divider(), // Divider hanya jika bukan item terakhir
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

  Future<void> _openExcelImportDialog(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      String fileName = result.files.single.name;

      // Untuk Web: pakai bytes, Mobile pakai path
      Uint8List? fileBytes = result.files.single.bytes;
      String? filePath = result.files.single.path;

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
                  if (kIsWeb) {
                    // Web harus ada bytes
                    if (fileBytes == null) {
                      throw Exception('File bytes tidak tersedia untuk web.');
                    }
                  } else {
                    // Mobile/Desktop harus ada path
                    if (filePath == null) {
                      throw Exception('File path tidak tersedia.');
                    }
                  }

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
                  print('Gagal mengimpor file: $e');

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

