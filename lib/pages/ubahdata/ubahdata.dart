import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/pages/data_mahasiswa/mahasiswa_asing.dart';
import 'package:gkm_mobile/pages/data_mahasiswa/seleksi_mahasiswa_baru.dart';
import 'package:gkm_mobile/pages/datadosen/dosen_industri_praktisi.dart';
import 'package:gkm_mobile/pages/datadosen/dosen_pembimbing_ta.dart';
import 'package:gkm_mobile/pages/datadosen/dosen_tetap_pt.dart';
import 'package:gkm_mobile/pages/datadosen/dosen_tidak_tetap.dart';
import 'package:gkm_mobile/pages/datadosen/ewmp_dosen.dart';
import 'package:gkm_mobile/pages/diagram/diagram.dart';
import 'package:gkm_mobile/pages/kerjasama_tridharma/pendidikan.dart';
import 'package:gkm_mobile/pages/kerjasama_tridharma/penelitian.dart';
import 'package:gkm_mobile/pages/kerjasama_tridharma/pengabdian_masyarakat.dart';
import 'package:gkm_mobile/pages/kualitas_pembelajaran/integrasi_penelitian.dart';
import 'package:gkm_mobile/pages/penelitian_dtps/dtps_penelitian_mahasiswa.dart';
import 'package:gkm_mobile/pages/penelitian_dtps/dtps_rujukan_tesis.dart';
import 'package:gkm_mobile/pages/tabelevaluasi/tabelevaluasi.dart';
import 'package:google_fonts/google_fonts.dart';

class UbahData extends StatefulWidget {
  final TahunAjaran tahunAjaran;
  const UbahData({Key? key, required this.tahunAjaran}) : super(key: key);
  @override
  UbahDataPageState createState() => UbahDataPageState();
}

class UbahDataPageState extends State<UbahData> with TickerProviderStateMixin {
  String? expandedMenu;

  void toggleMenu(String title) {
    setState(() {
      expandedMenu = (expandedMenu == title) ? null : title;
    });
  }

  void navigateToPage(String submenu) {
    Widget? page;

    switch (submenu) {
      // Kerjasama Tridarma
      case "Pendidikan":
        page = Pendidikan(tahunAjaran: widget.tahunAjaran);
        break;
      case "Penelitian":
        page = Penelitian(tahunAjaran: widget.tahunAjaran);
        break;
      case "Pengabdian Masyarakat":
        page = PengabdianMasyarakat(tahunAjaran: widget.tahunAjaran);
        break;
      // Data Mahasiswa
      case "Seleksi Mahasiswa":
        page = SeleksiMahasiswaBaru(tahunAjaran: widget.tahunAjaran);
        break;
      case "Mahasiswa Asing":
        page = MahasiswaAsing(tahunAjaran: widget.tahunAjaran);
        break;
      // Data Dosen
      case "Dosen Tetap PT":
        page = DosenTetapPt(tahunAjaran: widget.tahunAjaran);
        break;
      case "Dosen Industri/Praktisi":
        page = DosenIndustriPraktisi(tahunAjaran: widget.tahunAjaran);
        break;
      case "Dosen Pembimbing TA":
        page = DosenPembimbingTa(tahunAjaran: widget.tahunAjaran);
        break;
      case "EWMP Dosen":
        page = EwmpDosen(tahunAjaran: widget.tahunAjaran);
        break;
      case "Dosen Tidak Tetap":
        page = DosenTidakTetap(tahunAjaran: widget.tahunAjaran);
        break;
      // Penelitian DTPS
      case "Penelitian Mahasiswa":
        page = DtpsPenelitianMahasiswa(tahunAjaran: widget.tahunAjaran);
        break;
      case "Rujukan Tesis/Disertasi":
        page = DtpsRujukanTesis(tahunAjaran: widget.tahunAjaran);
        break;
        // Kualitas Pembelajaran
      case "Integrasi Penelitian":
        page = IntegrasiPenelitian(tahunAjaran: widget.tahunAjaran);
        break;
      case "Profil Dosen":
        page = Placeholder();
        break;
      case "Publikasi":
        page = Placeholder();
        break;
      case "Sertifikasi":
        page = Placeholder();
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
          // MENU UTAMA
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
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),

          // SUB MENU
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Container(
                    decoration: BoxDecoration(
                      color: submenuColor,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16)),
                    ),
                    child: Column(
                      children: submenus.map((submenu) {
                        return InkWell(
                          onTap: () => navigateToPage(submenu),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              submenu,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        );
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
          // CUSTOM APP BAR
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
                      "Ubah Data",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Semester ${(widget.tahunAjaran.semester == "ganjil" ? "Ganjil" : "Genap")} ${(widget.tahunAjaran.tahunAjaran)}",
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

          // BODY MENU
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  buildMenu(
                      "Kerjasama Tridarma",
                      "assets/images/ilustrasi1.png",
                      Colors.teal,
                      Colors.grey.shade300,
                      ["Pendidikan", "Penelitian", "Pengabdian Masyarakat"]),
                  buildMenu(
                      "Data Mahasiswa",
                      "assets/images/ilustrasi2.png",
                      Colors.grey.shade300,
                      Colors.teal, // Warna submenu diperbaiki
                      ["Seleksi Mahasiswa", "Mahasiswa Asing"]),
                  buildMenu("Data Dosen", "assets/images/ilustrasi3.png",
                      Colors.teal, Colors.grey.shade300, [
                    "Dosen Tetap PT",
                    "Dosen Pembimbing TA",
                    "EWMP Dosen",
                    "Dosen Tidak Tetap",
                    "Dosen Industri/Praktisi"
                  ]),
                  buildMenu(
                      "Kinerja Dosen",
                      "assets/images/ilustrasi4.png",
                      Colors.grey.shade300,
                      Colors.teal, // Warna submenu diperbaiki
                      [
                        "Pengakuan/Rekognisi Dosen",
                        "Penelitian DTPS",
                        "PkM DTPS",
                        "Publikasi & Pagelaran Ilmiah",
                        "Sitasi Karya Ilmiah",
                        "Produk/Jasa Teradopsi",
                        "Luaran Penelitian Lain"
                      ]),
                  buildMenu(
                      "Kualitas Pembelajaran",
                      "assets/images/ilustrasi2.png",
                      Colors.teal,
                      Colors.grey.shade300, [
                    "Kurikulum & Pembelajaran",
                    "Integrasi Penelitian",
                    "Kepuasan Mahasiswa"
                  ]),
                  buildMenu(
                      "Penelitian DTPS",
                      "assets/images/ilustrasi2.png",
                      Colors.grey.shade300,
                      Colors.teal,
                      ["Penelitian Mahasiswa", "Rujukan Tesis/Disertasi"]),
                  buildMenu(
                      "PkM DTPS Mahasiswa",
                      "assets/images/ilustrasi2.png",
                      Colors.teal,
                      Colors.grey.shade300, [
                    "PkM DTPS Mahasiswa"
                  ]),
                  buildMenu("Kinerja Lulusan", "assets/images/ilustrasi2.png",
                      Colors.grey.shade300, Colors.teal, [
                    "IPK Lulusan",
                    "Prestasi Mahasiswa",
                    "Masa Studi Lulusan",
                    "Evaluasi Lulusan"
                  ]),
                  buildMenu(
                      "Luaran Karya Mahasiswa",
                      "assets/images/ilustrasi2.png",
                      Colors.teal,
                      Colors.grey.shade300, [
                    "Publikasi Mahasiswa",
                    "Sitasi Karya Mahasiswa",
                    "Produk/Jasa Mahasiswa",
                    "Luaran Mahasiswa Lainnya"
                  ]),
                  buildMenu("Rekap Data", "assets/images/ilustrasi2.png",
                      Colors.grey.shade300, Colors.teal, ["Rekap Semua Data"]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
