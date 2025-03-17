import 'package:flutter/material.dart';
import "package:gkm_mobile/pages/onboarding/onboarding.dart";
import "package:gkm_mobile/pages/rekapdata/rekapdata.dart";
import "package:gkm_mobile/pages/splashscreen/splashscreen.dart";
import "package:gkm_mobile/pages/login/login.dart";
import "package:gkm_mobile/pages/register/register.dart";
import "package:gkm_mobile/pages/dashboard/dashboard.dart";
import "package:gkm_mobile/pages/tabelevaluasi/tabelevaluasi.dart";
import "package:gkm_mobile/pages/ubahdata/ubahdata.dart";
import 'package:gkm_mobile/pages/diagram/diagram.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: "/",  // Menentukan halaman awal
      routes: {
        "/": (context) => onboarding(),// Halaman pertama saat aplikasi dibuka
        "/login": (context) => login(),
        "/dashboard": (context) => DashboardScreen(),
        "/register": (context) => register(),
        "/ubahdata": (context) => UbahData(),
        "/diagram": (context) => GrafikMahasiswa(),
        "/rekapdata": (context) => rekapdata(),
        "/tabelevaluasi": (context) => tabelevaluasi(),
      },
    );
  }
}
