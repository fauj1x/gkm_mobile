import 'package:flutter/material.dart';
import 'package:gkm_mobile/pages/dashboard/frontend/login.dart';
import 'package:gkm_mobile/pages/dashboard/frontend/register.dart';
class onboarding extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<onboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      "image": "assets/onboarding.png", 
      "title": "Selamat datang di GKM POLIJE",
      "description": "SI GKM di Prodi Teknik Informatika PSDKU Sidoarjo adalah Sistem Informasi yang digunakan untuk mengelola dan memantau kegiatan penjaminan mutu guna meningkatkan kualitas pendidikan di program studi."
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) => OnboardingContent(
                image: onboardingData[index]["image"]!,
                title: onboardingData[index]["title"]!,
                description: onboardingData[index]["description"]!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                   Navigator.push(
                            context,
                              MaterialPageRoute(builder: (context) => login()),
                             );
                  },
                  child: Text("Masuk", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                            context,
                              MaterialPageRoute(builder: (context) => register()),
                             );
                  },
                  child: Text("Baru di platform kami? Buat akun", style: TextStyle(color: Colors.teal)),
                ),
                SizedBox(height: 20),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String image, title, description;
  OnboardingContent({required this.image, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),
        Image.asset(image, height: 250),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
