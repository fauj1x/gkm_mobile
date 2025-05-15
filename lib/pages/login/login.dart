import 'package:flutter/material.dart';
import 'package:gkm_mobile/pages/dashboard/dashboard.dart';
import 'package:gkm_mobile/pages/register/register.dart';
import 'package:gkm_mobile/services/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:gkm_mobile/services/simpan.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true; // Untuk toggle visibilitas password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selamat Datang",
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00B98F),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text.rich(
                      TextSpan(
                        text:
                            "Silahkan masukkan akunmu dan mulai petualangan\n",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(text: "bersama "),
                          TextSpan(
                            text: "GKM",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF00B98F),
                            ),
                          ),
                          const TextSpan(text: "!"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInputField("Email", "Masukkan emailmu di sini",
                        emailController, false),
                    _buildInputField(
                        "Kata Sandi",
                        "Masukkan kata sandimu di sini",
                        passwordController,
                        true),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Lupa password?",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.teal[900],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => login(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[900],
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      child: Text(
                        "Log in",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const register()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Baru di platform kami? ",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "Buat akun",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF00B98F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint,
      TextEditingController controller, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          label,
          style: GoogleFonts.poppins(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
                color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              // Default border tetap sama
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              // Border berubah saat ditekan
              borderSide: const BorderSide(color: Color(0xFF00B98F), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }

  void login(BuildContext context) async {
  String email = emailController.text.trim();
  String password = passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    _showDialog(context, "Harap isi email dan kata sandi!");
    return;
  }

  var loginSuccess = await Provider.of<AuthProvider>(context, listen: false)
      .login(email, password);

  if (!loginSuccess) {
    _showDialog(context, "Email atau kata sandi salah!");
    await saveUserEmail(email);
    return;
  }

  // Simpan email setelah login sukses
  await saveUserEmail(email);

  // Tampilkan loading
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(25),
          width: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SpinKitThreeBounce(
                color: Color(0xFF00B98F),
                size: 40,
              ),
              const SizedBox(height: 10),
              Text(
                "Loading...",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

    // Simulasi delay sebelum berpindah halaman
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return; // Pastikan widget masih ada sebelum pop
      Navigator.of(context, rootNavigator: true).pop(); // Tutup dialog loading

      if (!mounted) return; // Pastikan widget masih ada sebelum navigasi
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    });
  }

  Future<void> _showDialog(BuildContext context, String message) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outline, size: 50, color: Color(0xFF00B98F)),
                  const SizedBox(height: 10),
                  Text(
                    "Pemberitahuan",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B98F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(120, 40),
                    ),
                    child: Text(
                      "OK",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
        // Delay agar loading terlihat
  await Future.delayed(const Duration(seconds: 2));

  // Tutup dialog loading
  Navigator.of(context, rootNavigator: true).pop();

  // Navigasi ke Dashboard
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => DashboardScreen()),
  );
}
  }

