import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/user_profiles.dart';
import 'package:gkm_mobile/pages/onboarding/onboarding.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfileFormScreen extends StatefulWidget {
  final UserProfile? initialProfile;

  const UserProfileFormScreen({Key? key, this.initialProfile}) : super(key: key);

  @override
  UserProfileFormScreenState createState() => UserProfileFormScreenState();
}

class UserProfileFormScreenState extends State<UserProfileFormScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nipController;
  late TextEditingController _nikController;
  late TextEditingController _nidnController;
  late TextEditingController _namaController;
  late TextEditingController _jabatanFungsionalController;
  late TextEditingController _jabatanIdController;
  late TextEditingController _handphoneController;
  int _userId = 0;

  bool _isLoading = true;
  UserProfile? _currentProfile;

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

    _loadUserProfile();
  }

  @override
  void dispose() {
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
      _currentProfile = widget.initialProfile;
    } else if (_userId != 0) {
      try {
        final List<UserProfile> profile = await apiService.getData(UserProfile.fromJson, "user-profiles");
        _currentProfile = profile.firstWhere(
          (profile) => profile.userId == _userId,
          orElse: () => UserProfile(
            id: 0,
            userId: _userId,
            nip: '', nik: '', nidn: '', nama: '',
            jabatanFungsional: '', jabatanId: 0, handphone: '',
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat profil: $e')),
        );
        _currentProfile = UserProfile(
          id: 0, userId: _userId, nip: '', nik: '', nidn: '', nama: '',
          jabatanFungsional: '', jabatanId: 0, handphone: '',
        );
      }
    } else {
      _currentProfile = UserProfile(
        id: 0, userId: 0, nip: '', nik: '', nidn: '', nama: '',
        jabatanFungsional: '', jabatanId: 0, handphone: '',
      );
    }

    _populateControllers(_currentProfile!);

    setState(() {
      _isLoading = false;
    });
  }

  void _populateControllers(UserProfile profile) {
    _nipController.text = profile.nip;
    _nikController.text = profile.nik;
    _nidnController.text = profile.nidn;
    _namaController.text = profile.nama;
    _jabatanFungsionalController.text = profile.jabatanFungsional;
    _jabatanIdController.text = profile.jabatanId.toString();
    _handphoneController.text = profile.handphone;
  }

  Future<void> _saveUserProfile() async {
    final Map<String, dynamic> updatedData = {
      'id': _currentProfile?.id ?? 0,
      'user_id': _userId,
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
        await apiService.updateData(UserProfile.fromJson, _currentProfile!.id, updatedData, "user-profiles");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui!')),
        );
      } else {
        await apiService.postData(UserProfile.fromJson, updatedData, "user-profiles");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil ditambahkan!')),
        );
      }

      await _loadUserProfile();

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan profil: $e')),
      );
    }
  }

  Future<void> _logout() async {
    bool confirmLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text('Konfirmasi Logout', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin keluar dari akun ini?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Batal', style: GoogleFonts.poppins(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Logout', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;

    if (confirmLogout) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profil', style: GoogleFonts.poppins()),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            child: Icon(Icons.person, size: 40),
                          ),
                          const SizedBox(height: 10),
                          Text('Form Data Profil', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildTextField("Nama", _namaController),
                                _buildTextField("NIP", _nipController),
                                _buildTextField("NIK", _nikController),
                                _buildTextField("NIDN", _nidnController),
                                _buildTextField("Jabatan Fungsional", _jabatanFungsionalController),
                                _buildTextField("Jabatan ID", _jabatanIdController, keyboardType: TextInputType.number),
                                _buildTextField("No Handphone", _handphoneController, keyboardType: TextInputType.phone),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _saveUserProfile,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    child: Text("Simpan", style: GoogleFonts.poppins(fontSize: 16)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
