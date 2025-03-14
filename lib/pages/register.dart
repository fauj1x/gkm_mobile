import 'package:flutter/material.dart';
import 'package:gkm_mobile/pages/dashboard/frontend/login.dart';
import 'package:gkm_mobile/pages/dashboard/frontend/dashboard.dart';

class register extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

 void register() {
  String email = emailController.text.trim();
  String password = passwordController.text.trim();
  String confirmPassword = confirmPasswordController.text.trim();

  if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
    _showDialog("Harap isi semua field!");
    return;
  }

  if (password != confirmPassword) {
    _showDialog("Kata sandi tidak cocok!");
    return;
  }

  // TODO: Implementasikan registrasi ke backend di sini

  // Tampilkan Snackbar saat berhasil registrasi
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Registrasi berhasil! 🎉"),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ),
  );

  // Pindah ke Dashboard setelah 2 detik (setelah Snackbar tampil)
  Future.delayed(Duration(seconds: 2), () {
    Navigator.pushReplacementNamed(context, "/dashboard");
  });
}


  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pemberitahuan"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Buat akun baru",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 10),
            Text(
              "Silahkan buat akunmu untuk memulai petualangan bersama GKM!",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 20),
            _buildInputField("Email", "Masukkan emailmu di sini", emailController, false),
            _buildInputField("Kata Sandi", "Masukkan passwordmu di sini", passwordController, true),
            _buildInputField("Konfirmasi Kata Sandi", "Ketik ulang kata sandimu", confirmPasswordController, true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[900],
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                "Buat Akun",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                            context,
                              MaterialPageRoute(builder: (context) => login()),
                             );
                },
                child: Text("Sudah memiliki akun? Masuk", style: TextStyle(color: Colors.teal[900])),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.teal),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          ),
        ),
      ],
    );
  }
}
