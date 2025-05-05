import 'package:flutter/material.dart';
import 'package:gkm_mobile/pages/diagram/diagram.dart';
import 'package:gkm_mobile/pages/rekapdata/rekapdata.dart';
import 'package:gkm_mobile/pages/submenukerjasamatridharma/pendidikan.dart';
import 'package:gkm_mobile/pages/tabelevaluasi/tabelevaluasi.dart';
import 'package:google_fonts/google_fonts.dart';

class UbahData extends StatefulWidget {
  @override
  _UbahDataPageState createState() => _UbahDataPageState();
}

class _UbahDataPageState extends State<UbahData> with TickerProviderStateMixin {
  String? expandedMenu;

  void toggleMenu(String title) {
    setState(() {
      expandedMenu = (expandedMenu == title) ? null : title;
    });
  }

  void navigateToPage(String submenu) {
    Widget? page;

    switch (submenu) {
      case "Pendidikan":
        page = pendidikan();
        break;
      case "Seleksi Mahasiswa":
        page = GrafikMahasiswa();
        break;
      case "Akademik":
        page = Placeholder(); // Ganti dengan halaman yang sesuai
        break;
      case "Non-Akademik":
        page = Placeholder(); // Ganti dengan halaman yang sesuai
        break;
      case "Rekap Semua Data":
        page = tabelevaluasi();
        break;
      default:
        return;
    }

    if (page != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page!),
      );
    }
  }

  Widget buildMenu(String title, String imagePath, Color menuColor,
      Color submenuColor, List<String> submenus) {
    bool isExpanded = expandedMenu == title;

    Color textColor = (menuColor.value == const Color(0xFF009688).value)
        ? Colors.white
        : const Color(0xFF009688);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => toggleMenu(title),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: menuColor,
                borderRadius: isExpanded
                    ? const BorderRadius.vertical(top: Radius.circular(16))
                    : BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Image.asset(imagePath, width: 50, height: 50),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: textColor,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Container(
              decoration: BoxDecoration(
                color: submenuColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Column(
                children: submenus.map((submenu) {
                  // Warna teks submenu berdasarkan submenuColor
                  Color submenuTextColor = (submenuColor == const Color(0xFF009688))
                      ? Colors.white
                      : const Color(0xFF009688);

                  if (submenu == "Prestasi Mahasiswa") {
                    return Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(
                          submenu,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: submenuTextColor,
                          ),
                        ),
                        children: [
                          ListTile(
                            title: Text(
                              "Akademik",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w200,
                                color: submenuTextColor,
                              ),
                            ),
                            onTap: () => navigateToPage("Akademik"),
                          ),
                          ListTile(
                            title: Text(
                              "Non-Akademik",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w200,
                                color: submenuTextColor,
                              ),
                            ),
                            onTap: () => navigateToPage("Non-Akademik"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return InkWell(
                      onTap: () => navigateToPage(submenu),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          submenu,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: submenuTextColor,
                          ),
                        ),
                      ),
                    );
                  }
                }).toList(),
              ),
            )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 10),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ubah data",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Semester genap 2023 / 2024",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildMenu("Kerjasama Tridharma", "assets/images/ilustrasi1.png",
                      Colors.teal, Colors.grey.shade300, ["Pendidikan", "Penelitian", "Pengabdian Masyarakat"]),
                  buildMenu("Data Mahasiswa", "assets/images/ilustrasi2.png",
                      Colors.grey.shade300, const Color(0xFF009688), ["Seleksi Mahasiswa", "Mahasiswa Asing"]),
                  buildMenu("Data Dosen", "assets/images/ilustrasi3.png",
                      Colors.teal, Colors.grey.shade300, ["Dosen Tetap PT", "Pembimbing TA", "EWMP Dosen", "Dosen Tidak Tetap", "Dosen Industri/Praktisi"]),
                  buildMenu("Kinerja Dosen", "assets/images/ilustrasi4.png",
                      Colors.grey.shade300, const Color(0xFF009688), ["Pengakuan/Rekognisi Dosen", "Penelitian DTPS", "Pkm DTPS", "Publikasi & Pagelaran Ilmiah", "Sitasi Karya Ilmiah", "Produk/Jasa Teradopsi", "Luaran Penelitian Lain"]),
                  buildMenu("Kualitas Pembelajaran", "assets/images/ilustrasi3.png",
                      Colors.teal, Colors.grey.shade300, ["Kurikulum & Pembelajaran", "Integrasi Penelitian", "Kepuasan Mahasiswa"]),
                  buildMenu("Kinerja Lulusan", "assets/images/ilustrasi4.png",
                      Colors.grey.shade300, const Color(0xFF009688), ["IPK Lulusan", "Prestasi Mahasiswa", "Masa Studi Lulusan", "Evaluasi Lulusan", "Sitasi Karya Ilmiah", "Produk/Jasa Teradopsi", "Luaran Penelitian Lain"]),
                  buildMenu("Luaran Karya Mahasiswa", "assets/images/ilustrasi3.png",
                      Colors.teal, Colors.grey.shade300, ["Publikasi Mahasiswa", "Sitasi Karya Mahasiswa", "Produk/Jasa Mahasiswa", "Luaran Mahasiswa Lainnya"]),
                  buildMenu("Rekap Data", "assets/images/ilustrasi4.png",
                      Colors.grey.shade300, const Color(0xFF009688), ["Rekap Semua Data"]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
