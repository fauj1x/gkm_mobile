import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/user_profiles.dart';
import 'package:gkm_mobile/services/api_services.dart';

class ProfilDetailPage extends StatefulWidget {
  final String email; // Tambahkan parameter email
  const ProfilDetailPage({Key? key, required this.email}) : super(key: key);

  @override
  _ProfilDetailPageState createState() => _ProfilDetailPageState();
}

class _ProfilDetailPageState extends State<ProfilDetailPage> {
  UserProfile? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final apiService = ApiService();
    try {
      // Sesuaikan endpoint dan parameter
      final data = await apiService.getData(
        UserProfile.fromJson,
        'user-profiles?email=${widget.email}',
      );
      
      // Jika API mengembalikan list, ambil data pertama
      if (data is List && data.isNotEmpty) {
        setState(() {
          userProfile = data[0];
        });
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Detail Profil')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userProfile == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Detail Profil')),
        body: Center(child: Text('Data tidak ditemukan')),
      );
    }

    // Tampilkan data profil
    return Scaffold(
      appBar: AppBar(title: Text('Detail Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ListTile(
              title: Text('Nama'),
              subtitle: Text(userProfile!.nama),
            ),
            ListTile(
              title: Text('NIP'),
              subtitle: Text(userProfile!.nip),
            ),
            ListTile(
              title: Text('NIK'),
              subtitle: Text(userProfile!.nik),
            ),
            ListTile(
              title: Text('NIDN'),
              subtitle: Text(userProfile!.nidn),
            ),
            ListTile(
              title: Text('Jabatan Fungsional'),
              subtitle: Text(userProfile!.jabatanFungsional),
            ),
            ListTile(
              title: Text('Handphone'),
              subtitle: Text(userProfile!.handphone),
            ),
            // Tambahkan field lain sesuai kebutuhan
          ],
        ),
      ),
    );
  }
}