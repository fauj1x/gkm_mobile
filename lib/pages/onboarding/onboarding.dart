import 'package:flutter/material.dart';
import 'package:gkm_mobile/pages/login/login.dart';
import 'package:google_fonts/google_fonts.dart';

class onboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logoGKM.png',
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Gambar tidak ditemukan!');
                    },
                  ),
                  SizedBox(height: 40),

                  // Ilustrasi atau Gambar
                  Image.asset(
                    'assets/images/onboarding.png',
                    height: 200,
                  ),
                  SizedBox(height: 20),

                  // Judul
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(text: 'Selamat datang di '),
                        TextSpan(
                          text: 'GKM POLIJE',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00B98F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  // Deskripsi
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.grey[700],
                      ),
                      children: [
                        TextSpan(text: 'Si '),
                        TextSpan(
                          text: 'GKM',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Color(0xFF00B98F),
                          ),
                        ),
                        TextSpan(
                          text:
                          ' di Prodi Teknik Informatika PSDKU Sidoarjo adalah Sistem Informasi yang digunakan untuk mengelola dan memantau kegiatan penjaminan mutu guna meningkatkan kualitas pendidikan di program studi.',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // Tombol Masuk
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF003C2E),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => login()),
                      );
                    },
                    child: Text(
                      'Masuk',
                      style:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            // Spacer untuk mendorong footer ke bawah
            SizedBox(height: 20),

            // Footer
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text.rich(
                  TextSpan(
                    text: "©",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "GKM POLIJE",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          color: Color(0xFF00B98F), // Warna hijau
                        ),
                      ),
                      TextSpan(
                        text: ", All Right Reserved. Designed By ",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: "Team GKM\n",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          color: Color(0xFF00B98F), // Warna hijau
                        ),
                      ),
                      TextSpan(
                        text: "Distributed By: ",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: "Team GKM",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          color: Color(0xFF00B98F), // Warna hijau
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
