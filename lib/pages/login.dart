import 'package:flutter/material.dart';

class login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showDialog("Harap isi email dan kata sandi!");
      return;
    }

    // TODO: Implementasikan registrasi ke backend di sini

  // Tampilkan Snackbar saat berhasil registrasi
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Login berhasil! 🎉"),
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
              "Selamat Datang",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 10),
            Text(
              "Silahkan masukkan akunmu dan mulai petualangan bersama GKM!",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 20),
            _buildInputField("Email", "Masukkan emailmu di sini", emailController, false),
            _buildInputField("Kata Sandi", "Masukkan Kata sandimu di sini", passwordController, true),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Tambahkan fungsi lupa password
                },
                child: Text("Lupa password?", style: TextStyle(color: Colors.teal[900])),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[900],
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                "Log in",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/register"); // Arahkan ke halaman register
                },
                child: Text("Baru di platform kami? Buat akun", style: TextStyle(color: Colors.teal[900])),
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
