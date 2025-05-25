// lib/screens/user_profile_form_screen.dart
import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/user_profiles.dart'; // Sesuaikan path ini
import 'package:gkm_mobile/pages/onboarding/onboarding.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts

class UserProfileFormScreen extends StatefulWidget {
  final UserProfile? initialProfile; // Menerima data profil awal (opsional)

  const UserProfileFormScreen({Key? key, this.initialProfile}) : super(key: key);

  @override
  UserProfileFormScreenState createState() => UserProfileFormScreenState();
}

class UserProfileFormScreenState extends State<UserProfileFormScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>(); // Kunci untuk validasi form

  // Controllers untuk setiap field input
  late TextEditingController _nipController;
  late TextEditingController _nikController;
  late TextEditingController _nidnController;
  late TextEditingController _namaController;
  late TextEditingController _jabatanFungsionalController;
  late TextEditingController _jabatanIdController;
  late TextEditingController _handphoneController;
  int _userId = 0; // Untuk menyimpan userId dari SharedPreferences

  bool _isLoading = true; // Status loading data
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
        // Asumsi API Anda memiliki endpoint untuk mendapatkan profil user yang sedang login
        // atau Anda perlu mengirim userId sebagai parameter.
        // Contoh: apiService.getData(UserProfile.fromJson, "user-profile", queryParams: {'user_id': _userId.toString()});
        // Atau jika API mengembalikan profil user yang sedang login tanpa parameter tambahan:
        final List<UserProfile> profiles = await apiService.getData(UserProfile.fromJson, "user-profile");
        // Filter berdasarkan userId yang login
        _currentProfile = profiles.firstWhere(
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
  Future<void> _saveUserProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

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
          await apiService.updateData(UserProfile.fromJson, _currentProfile!.id, updatedData, "user-profile");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil berhasil diperbarui!')),
          );
        } else {
          // Jika profil belum ada (ID 0), lakukan post (buat baru)
          await apiService.postData(UserProfile.fromJson, updatedData, "user-profile");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil berhasil ditambahkan!')),
          );
        }
        Navigator.pop(context, true); // Kembali ke layar sebelumnya dengan indikasi sukses
      } catch (e) {
        print("Error saving user profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan profil: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
        MaterialPageRoute(builder: (context) => OnboardingScreen()), // Ganti dengan LoginScreen Anda
        (Route<dynamic> route) => false, // Hapus semua rute di stack
      );
    }
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
          "Edit Profil Pengguna",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 30), // Spasi sebelum tombol
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveUserProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[700], // Warna tombol yang lebih kuat
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18), // Padding lebih besar
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Border radius lebih besar
                          ),
                          elevation: 5, // Tambahkan shadow
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'Simpan Perubahan',
                                style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
