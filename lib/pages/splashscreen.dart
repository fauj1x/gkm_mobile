import 'package:flutter/material.dart';
import 'package:gkm_mobile/pages/dashboard/frontend/dashboard.dart';
import 'package:gkm_mobile/pages/dashboard/frontend/onboarding.dart';
// Pastikan file dashboard.dart ada

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => onboarding()), // Nama kelas harus PascalCase
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logopolije.png',
              width: 150,
            ),
            SizedBox(height: 20),
            Text(
              'GKM MOBILE',
              style: TextStyle(fontSize: 24, color: const Color.fromARGB(255, 8, 208, 44)),
            ),
          ],
        ),
      ),
    );
  }
}
