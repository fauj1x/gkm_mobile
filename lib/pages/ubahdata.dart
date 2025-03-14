import 'package:flutter/material.dart';
import 'package:gkm_mobile/pages/dashboard/frontend/kerjasama.dart';
import 'package:gkm_mobile/pages/dashboard/frontend/kinerjadosen.dart';
import 'package:gkm_mobile/pages/dashboard/frontend/datadosen.dart';
import 'package:gkm_mobile/pages/dashboard/frontend/diagram.dart';
import 'package:gkm_mobile/pages/dashboard/frontend/tabelevaluasi.dart';

class ubahdata extends StatefulWidget {
  const ubahdata({super.key});

  @override
  _UbahDataState createState() => _UbahDataState();
}

class _UbahDataState extends State<ubahdata> {
  String? expandedMenu;

  void toggleMenu(String title) {
    setState(() {
      expandedMenu = (expandedMenu == title) ? null : title;
    });
  }

  Widget buildMenuButton(String title, String imagePath, Color color, Widget page, List<String> submenus) {
    bool isExpanded = expandedMenu == title;
    
    return Column(
      children: [
        GestureDetector(
          onTap: () => toggleMenu(title),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset(imagePath, width: 50, height: 50, errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.red, size: 50);
                }),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white)
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isExpanded ? (submenus.length * 50.0) : 0,
          curve: Curves.easeInOut,
          child: Column(
            children: submenus.map((submenu) => ListTile(
              title: Text(submenu),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
            )).toList(),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Data'),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            buildMenuButton("Kerjasama Tridarma", "assets/logopolije.png", Colors.teal, kerjasama(), ["Pendidikan", "Penelitian", "Pengabdian Masyarakat"]),
            buildMenuButton("Data Mahasiswa", "assets/datamahasiswa.png", Colors.grey.shade300, GrafikMahasiswa(), ["Seleksi Mahasiswa","Mahasiswa Asing"]),
            buildMenuButton("Data Dosen", "assets/kinerjadosen.png", Colors.teal,  datadosen(), []),
            buildMenuButton("Kinerja Dosen", "assets/rekapdata.png", Colors.grey.shade300, kinerjadosen(), []),
            buildMenuButton("Rekap Data", "assets/rekapdata.png", Colors.teal,  tableevaluasi(), ["Rekap Semua Data"]),
          ],
        ),
      ),
    );
  }
}
