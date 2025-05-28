raimport 'package:flutter/material.dart';
import 'package:gkm_mobile/pages/onboarding/onboarding.dart';
import 'package:gkm_mobile/pages/splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:gkm_mobile/services/auth.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GKM POLIJE',
      home: SplashScreen(), // Ini WAJIB agar logo GKM tampil dulu
    );
  }
}

