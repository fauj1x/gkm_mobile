import 'package:flutter/material.dart';
import 'package:gkm_mobile/pages/onboarding/onboarding.dart';

// Pastikan file dashboard.dart ada

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const onboarding()), // Nama kelas harus PascalCase
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
            const SizedBox(height: 20),
            const Text(
              'GKM MOBILE',
              style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 8, 208, 44)),
            ),
          ],
        ),
      ),
    );
  }
}  
