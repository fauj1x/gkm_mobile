import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gkm_mobile/pages/onboarding/onboarding.dart';
import 'package:gkm_mobile/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../dashboard/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  Future<bool> _delayedAuthCheck(BuildContext context) async {
    // enteni sek 2 detik ben ketok apik
    await Future.delayed(const Duration(seconds: 2));
    // lagek jajal login
    return Provider.of<AuthProvider>(context, listen: false).checkAuth();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _delayedAuthCheck(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show splash while waiting
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Image.asset(
                        'assets/images/logoGKM.png',
                        width: 150,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          );
        } else {
          bool isAuthenticated = snapshot.data ?? false;
          // Navigate to the correct screen
          return isAuthenticated ? DashboardScreen() : OnboardingScreen();
        }
      },
    );
  }
}
