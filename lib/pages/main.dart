import 'package:flutter/material.dart';
import "package:gkm_mobile/pages/dashboard/frontend/splashscreen.dart";
import "package:gkm_mobile/pages/dashboard/frontend/login.dart";
import "package:gkm_mobile/pages/dashboard/frontend/register.dart";
import "package:gkm_mobile/pages/dashboard/frontend/dashboard.dart";

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
        "/": (context) => SplashScreen(),  // Halaman pertama saat aplikasi dibuka
        "/login": (context) => login(),
        "/register": (context) => register(),
        "/dashboard": (context) => HomeScreen(),
      },
    );
  }
}
