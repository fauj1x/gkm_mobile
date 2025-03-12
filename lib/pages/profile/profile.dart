import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          _buildHeader(context),
          _buildProfileInfo(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F6B52),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 16, right: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const Text(
                "Profile",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile.jpg'), // Ganti dengan gambar profil pengguna
          ),
          const SizedBox(height: 10),
          Text(
            "KOKO Faisal",
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            "Admin GKM",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Personal"),
            _buildInfoRow(Icons.person, "Username", "KOKO Faisal"),
            _buildInfoRow(Icons.email, "Email", "kokofaisal@gmail.com"),
            const Divider(),
            _buildSectionTitle("Kata Sandi"),
            _buildInfoRow(Icons.lock, "Kata Sandi", "xxxxxxxx xxx"),
            const Divider(),
            _buildSectionTitle("Nomor Hp"),
            _buildInfoRow(Icons.phone, "Nomor Hp", "(+62) 8781 2345 274"),
            const Divider(),
            _buildSectionTitle("Pengaturan Lainnya"),
            _buildInfoRow(Icons.info, "Tentang Aplikasi", ""),
            _buildInfoRow(Icons.help, "Bantuan", ""),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: value.isNotEmpty ? Text(value, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)) : null,
    );
  }
}
