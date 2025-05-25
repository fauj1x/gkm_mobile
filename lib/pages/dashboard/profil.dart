// lib/screens/user_profile_form_screen.dart
import 'dart:convert'; // Import untuk jsonEncode jika belum ada di ApiService
import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/user_profiles.dart'; // Sesuaikan path ini
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts
import 'package:gkm_mobile/pages/login/login.dart'; // Asumsi path ke LoginScreen Anda

class UserProfileFormScreen extends StatefulWidget {
  final UserProfile? initialProfile; // Menerima data profil awal (opsional)

  const UserProfileFormScreen({Key? key, this.initialProfile}) : super(key: key);

  @override
  UserProfileFormScreenState createState() => UserProfileFormScreenState();
}

class UserProfileFormScreenState extends State<UserProfileFormScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>(); // Kunci untuk validasi form utama

  // Controllers untuk setiap field input
  late TextEditingController _nipController;
  late TextEditingController _nikController;
  late TextEditingController _nidnController;
  late TextEditingController _namaController;
  late TextEditingController _jabatanFungsionalController;
  late TextEditingController _jabatanIdController;
  late TextEditingController _handphoneController;
  int _userId = 0; // Untuk menyimpan userId dari SharedPreferences

  bool _isLoading = true; // Status loading data untuk layar utama
  UserProfile? _currentProfile; // Profil yang sedang ditampilkan/diedit

  @override
  void initState() {
    super.initState();
    _nipController = TextEditingController();
    _nikController = TextEditingController();
    _nidnController = TextEditingController();
    _namaController = TextEditingController();
    _jabatanFungsionalController = TextEditingController();
    _jabatanIdController = TextEditingController();
    _handphoneController = TextEditingController();

    _loadUserProfile(); // Memuat profil saat inisialisasi
  }

  @override
  void dispose() {
    // Pastikan untuk membuang controllers saat widget di-dispose
    _nipController.dispose();
    _nikController.dispose();
    _nidnController.dispose();
    _namaController.dispose();
    _jabatanFungsionalController.dispose();
    _jabatanIdController.dispose();
    _handphoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = int.tryParse(prefs.getString('id') ?? '0') ?? 0;

    if (widget.initialProfile != null) {
      // Jika profil awal sudah diberikan dari halaman sebelumnya
      _currentProfile = widget.initialProfile;
      _populateControllers(_currentProfile!);
    } else if (_userId != 0) {
      // Jika tidak ada profil awal, coba ambil dari API berdasarkan userId
      try {
        final List<UserProfile> profile = await apiService.getData(UserProfile.fromJson, "user-profiles");
        // Filter berdasarkan userId yang login
        _currentProfile = profile.firstWhere(
          (profile) => profile.userId == _userId,
          orElse: () => UserProfile( // Default jika tidak ditemukan
            id: 0, // ID 0 atau ID sementara untuk profil baru
            userId: _userId,
            nip: '', nik: '', nidn: '', nama: '',
            jabatanFungsional: '', jabatanId: 0, handphone: '',
          ),
        );
        _populateControllers(_currentProfile!);
      } catch (e) {
        print("Error loading user profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat profil: $e')),
        );
        // Inisialisasi controller dengan nilai kosong jika gagal memuat
        _populateControllers(UserProfile(
            id: 0, userId: _userId, nip: '', nik: '', nidn: '', nama: '',
            jabatanFungsional: '', jabatanId: 0, handphone: '',
        ));
      }
    } else {
      // Jika userId tidak ditemukan, inisialisasi dengan data kosong
      _populateControllers(UserProfile(
          id: 0, userId: 0, nip: '', nik: '', nidn: '', nama: '',
          jabatanFungsional: '', jabatanId: 0, handphone: '',
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Mengisi controllers dengan data profil
  void _populateControllers(UserProfile profile) {
    _nipController.text = profile.nip;
    _nikController.text = profile.nik;
    _nidnController.text = profile.nidn;
    _namaController.text = profile.nama;
    _jabatanFungsionalController.text = profile.jabatanFungsional;
    _jabatanIdController.text = profile.jabatanId.toString();
    _handphoneController.text = profile.handphone;
  }

  // Menyimpan perubahan profil ke API
  // Fungsi ini dipanggil baik dari form utama maupun dari dialog
  Future<void> _saveUserProfile() async {
    final Map<String, dynamic> updatedData = {
      'id': _currentProfile?.id ?? 0, // Gunakan ID yang ada atau 0 jika baru
      'user_id': _userId, // Pastikan userId yang benar
      'nip': _nipController.text,
      'nik': _nikController.text,
      'nidn': _nidnController.text,
      'nama': _namaController.text,
      'jabatan_fungsional': _jabatanFungsionalController.text,
      'jabatan_id': int.tryParse(_jabatanIdController.text) ?? 0,
      'handphone': _handphoneController.text,
    };

    try {
      if (_currentProfile != null && _currentProfile!.id != 0) {
        // Jika profil sudah ada (memiliki ID), lakukan update
        await apiService.updateData(UserProfile.fromJson, _currentProfile!.id, updatedData, "user-profiles"); // UBAH KE "user-profiles"
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui!')),
        );
      } else {
        // Jika profil belum ada (ID 0), lakukan post (buat baru)
        await apiService.postData(UserProfile.fromJson, updatedData, "user-profiles"); // UBAH KE "user-profiles"
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil ditambahkan!')),
        );
      }
      // Setelah sukses menyimpan, muat ulang data profil di layar utama
      await _loadUserProfile();
    } catch (e) {
      print("Error saving user profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan profil: $e')),
      );
      rethrow; // Melemparkan error agar bisa ditangkap oleh caller (dialog)
    }
  }

  // Fungsi untuk logout
  Future<void> _logout() async {
    // Tampilkan dialog konfirmasi logout
    bool confirmLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'Konfirmasi Logout',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
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
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    ) ?? false;

    if (confirmLogout) {
      // Hapus data sesi dari SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Menghapus semua data yang disimpan

      // Navigasi ke layar login dan hapus semua rute sebelumnya
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => login()), // Ganti dengan LoginScreen Anda
        (Route<dynamic> route) => false, // Hapus semua rute di stack
      );
    }
  }

  // --- Fungsi untuk menampilkan dialog edit profil ---
  void _showEditProfileDialog() {
    // Pastikan _currentProfile tidak null sebelum mengisi controllers
    if (_currentProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada data profil untuk diedit.')),
      );
      return;
    }

    // Isi controllers dengan data profil saat ini
    // Ini penting agar dialog menampilkan data yang terbaru
    _populateControllers(_currentProfile!);

    showDialog(
      context: context,
      builder: (context) {
        final _dialogFormKey = GlobalKey<FormState>(); // Kunci form untuk validasi di dalam dialog
        
        // Gunakan StatefulBuilder untuk mengelola state lokal di dalam dialog
        // seperti status loading untuk tombol "Simpan"
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            bool _isSaving = false; // Status loading lokal untuk dialog

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: Text(
                'Edit Profil Pengguna',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _dialogFormKey, // Terapkan key form untuk validasi di dialog
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Agar dialog menyesuaikan konten
                    children: [
                      TextFormField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          labelText: 'Nama Lengkap',
                          hintText: 'Masukkan nama lengkap Anda',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15), // Spasi antar field
                      TextFormField(
                        controller: _nipController,
                        decoration: InputDecoration(
                          labelText: 'NIP',
                          hintText: 'Masukkan NIP Anda',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _nikController,
                        decoration: InputDecoration(
                          labelText: 'NIK',
                          hintText: 'Masukkan NIK Anda',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _nidnController,
                        decoration: InputDecoration(
                          labelText: 'NIDN',
                          hintText: 'Masukkan NIDN Anda',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _jabatanFungsionalController,
                        decoration: InputDecoration(
                          labelText: 'Jabatan Fungsional',
                          hintText: 'Masukkan jabatan fungsional Anda',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _jabatanIdController,
                        decoration: InputDecoration(
                          labelText: 'ID Jabatan',
                          hintText: 'Masukkan ID jabatan Anda',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                            return 'ID Jabatan harus berupa angka';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _handphoneController,
                        decoration: InputDecoration(
                          labelText: 'Nomor Handphone',
                          hintText: 'Masukkan nomor handphone Anda',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog
                    // Setel ulang controllers agar tidak mempertahankan data yang belum disimpan
                    _populateControllers(_currentProfile!);
                  },
                  child: Text(
                    'Batal',
                    style: GoogleFonts.poppins(color: Colors.black54),
                  ),
                ),
                ElevatedButton(
                  // Tombol dinonaktifkan jika sedang dalam proses penyimpanan
                  onPressed: _isSaving ? null : () async {
                    if (_dialogFormKey.currentState!.validate()) {
                      setStateDialog(() { // Set state loading di dalam dialog
                        _isSaving = true;
                      });
                      try {
                        await _saveUserProfile(); // Panggil fungsi simpan
                        // Jika berhasil disimpan, dialog akan ditutup
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        // Error sudah ditangani di _saveUserProfile
                        // Tapi kita pastikan _isSaving kembali false
                      } finally {
                        if (mounted) {
                          setStateDialog(() { // Pastikan _isSaving kembali false di dalam dialog
                            _isSaving = false;
                          });
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[700], // Warna tombol yang lebih kuat
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Border radius lebih besar
                    ),
                  ),
                  child: _isSaving // Tampilkan CircularProgressIndicator jika _isSaving true
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Simpan',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Background yang lebih terang
      appBar: AppBar(
        backgroundColor: Colors.teal[700], // Warna app bar yang konsisten
        elevation: 4, // Sedikit shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Profil Pengguna", // Judul disesuaikan karena ada tombol edit
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          // Tombol untuk membuka dialog edit
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _isLoading ? null : _showEditProfileDialog, // Disable jika sedang loading
            tooltip: 'Edit Profil',
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white), // Icon logout
            onPressed: _logout, // Panggil fungsi logout
            tooltip: 'Logout', // Tooltip untuk tombol
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0), // Padding yang lebih besar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileInfoRow('Nama Lengkap', _namaController.text),
                  _buildProfileInfoRow('NIP', _nipController.text.isEmpty ? '-' : _nipController.text),
                  _buildProfileInfoRow('NIK', _nikController.text.isEmpty ? '-' : _nikController.text),
                  _buildProfileInfoRow('NIDN', _nidnController.text.isEmpty ? '-' : _nidnController.text),
                  _buildProfileInfoRow('Jabatan Fungsional', _jabatanFungsionalController.text.isEmpty ? '-' : _jabatanFungsionalController.text),
                  _buildProfileInfoRow('ID Jabatan', _jabatanIdController.text.isEmpty || _jabatanIdController.text == '0' ? '-' : _jabatanIdController.text),
                  _buildProfileInfoRow('Nomor Handphone', _handphoneController.text.isEmpty ? '-' : _handphoneController.text),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  // Widget pembantu untuk menampilkan baris informasi profil
  Widget _buildProfileInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}