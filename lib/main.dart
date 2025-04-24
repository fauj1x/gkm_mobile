import "dart:io";

import 'package:flutter/material.dart';
import "package:gkm_mobile/pages/onboarding/onboarding.dart";
import "package:gkm_mobile/pages/rekapdata/rekapdata.dart";
import "package:gkm_mobile/pages/login/login.dart";
import "package:gkm_mobile/pages/register/register.dart";
import "package:gkm_mobile/pages/dashboard/dashboard.dart";
import "package:gkm_mobile/pages/tabelevaluasi/tabelevaluasi.dart";
import "package:gkm_mobile/pages/ubahdata/ubahdata.dart";
import 'package:gkm_mobile/pages/diagram/diagram.dart';
import "package:gkm_mobile/services/auth.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => AuthProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Provider.of<AuthProvider>(context, listen: false).checkAuth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GKM POLIJE',
            theme: ThemeData(primarySwatch: Colors.blue),
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else {
          bool isAuthenticated = snapshot.data ?? false;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GKM POLIJE',
            theme: ThemeData(primarySwatch: Colors.blue),
            home: isAuthenticated ? dashboard() : onboarding(),
          );
        }
      },
    );
  }
}
