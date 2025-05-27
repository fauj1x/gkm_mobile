import 'package:flutter/material.dart';
import 'package:gkm_mobile/pages/login/login.dart';
import 'package:gkm_mobile/pages/dashboard/dashboard.dart';
import 'package:gkm_mobile/pages/onboarding/onboarding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';

class register extends StatefulWidget {
  const register({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true; // Untuk toggle password visibility

  void showSuccessNotification(BuildContext context) {
    Flushbar(
      message: "Registrasi berhasil! 🎉\nLink verifikasi telah dikirim ke email Anda.",
      icon: const Icon(Icons.check_circle, color: Colors.white, size: 28),
      duration: const Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(8),
      backgroundGradient:
          const LinearGradient(colors: [Color(0xFF00B98F), Colors.teal]),
      boxShadows: const [
        BoxShadow(color: Colors.black45, offset: Offset(2, 2), blurRadius: 4)
      ],
      isDismissible: true,
    ).show(context);
  }

  Future<void> register() async {
    String name = nameController.text.trim();
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (username.isEmpty ||
        name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showDialog("Tolong lengkapi semua kolom!");
      return;
    }

    if (password != confirmPassword) {
      _showDialog("Kata sandi tidak cocok!");
      return;
    }

    var registerResult = await Provider.of<AuthProvider>(context, listen: false)
        .register(name, username, email, password);

    switch (registerResult) {
      case 200:
        break;
      case 401:
        _showDialog("Registrasi gagal! Data yang anda masukan tidak valid.");
        return;
      default:
        // Gagal karena alasan lain
        _showDialog("Terjadi kesalahan. Silakan coba lagi.");
        return;
    }

    // Tampilkan notifikasi modern saat registrasi berhasil
    showSuccessNotification(context);

    // Pindah ke Login setelah 2
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    });
  }

  void _showDialog(String message) {
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
                const Icon(Icons.info_outline,
                    size: 50, color: Color(0xFF00B98F)),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Pusatkan form di tengah
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Buat akun baru",
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00B98F),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Silahkan buat akunmu untuk memulai petualangan bersama GKM!",
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    _buildInputField("Nama Lengkap", "Masukkan nama anda",
                        nameController, false),
                    _buildInputField("Username", "Masukkan username anda",
                        usernameController, false),
                    _buildInputField("Email", "Masukkan emailmu di sini",
                        emailController, false),
                    _buildInputField(
                        "Kata Sandi",
                        "Masukkan passwordmu di sini",
                        passwordController,
                        true),
                    _buildInputField(
                        "Konfirmasi Kata Sandi",
                        "Ketik ulang kata sandi anda",
                        confirmPasswordController,
                        true),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[900],
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        "Buat Akun",
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
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Sudah memiliki akun? ",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "Masuk",
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
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color(0xFF00B98F), width: 2), // Hover warna 0xFF00B98F
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
}
