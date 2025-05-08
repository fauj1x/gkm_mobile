import 'package:flutter/material.dart';
import "package:gkm_mobile/pages/onboarding/onboarding.dart";
import "package:gkm_mobile/pages/rekapdata/rekapdata.dart";
import "package:gkm_mobile/pages/login/login.dart";
import "package:gkm_mobile/pages/register/register.dart";
import "package:gkm_mobile/pages/dashboard/dashboard.dart";
import "package:gkm_mobile/pages/tabelevaluasi/tabelevaluasi.dart";
import "package:gkm_mobile/pages/ubahdata/ubahdata.dart";
import 'package:gkm_mobile/pages/diagram/diagram.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: "/",  // Menentukan halaman awal
      routes: {
        "/": (context) => const onboarding(),// Halaman pertama saat aplikasi dibuka
        "/login": (context) => const login(),
        "/dashboard": (context) => const DashboardScreen(),
        "/register": (context) => const register(),
        "/ubahdata": (context) => const UbahData(),
        "/diagram": (context) => const GrafikMahasiswa(),
        "/rekapdata": (context) => const rekapdata(),
        "/tabelevaluasi": (context) =>  tabelevaluasi(),
      },
    );
  }
}
