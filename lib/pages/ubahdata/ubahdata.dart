import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/tahun_ajaran.dart';
import 'package:gkm_mobile/pages/data_mahasiswa/mahasiswa_asing.dart';
import 'package:gkm_mobile/pages/data_mahasiswa/seleksi_mahasiswa_baru.dart';
import 'package:gkm_mobile/pages/data_dosen/dosen_industri_praktisi.dart';
import 'package:gkm_mobile/pages/data_dosen/dosen_pembimbing_ta.dart';
import 'package:gkm_mobile/pages/data_dosen/dosen_tetap_pt.dart';
import 'package:gkm_mobile/pages/data_dosen/dosen_tidak_tetap.dart';
import 'package:gkm_mobile/pages/data_dosen/ewmp_dosen.dart';
import 'package:gkm_mobile/pages/kerjasama_tridharma/pendidikan.dart';
import 'package:gkm_mobile/pages/kerjasama_tridharma/penelitian.dart';
import 'package:gkm_mobile/pages/kerjasama_tridharma/pengabdian_masyarakat.dart';
import 'package:gkm_mobile/pages/kinerja_dosen/luaran_penelitian_lain/buku_chapter_dosen.dart';
import 'package:gkm_mobile/pages/kinerja_dosen/luaran_penelitian_lain/hki_hak_cipta.dart';
import 'package:gkm_mobile/pages/kinerja_dosen/luaran_penelitian_lain/hki_paten.dart';
import 'package:gkm_mobile/pages/kinerja_dosen/luaran_penelitian_lain/teknologi_karya.dart';
import 'package:gkm_mobile/pages/kinerja_dosen/produk_teradopsi_dosen.dart';
import 'package:gkm_mobile/pages/kinerja_lulusan/evaluasi/kepuasan.dart';
import 'package:gkm_mobile/pages/kinerja_lulusan/evaluasi/kesesuaian.dart';
import 'package:gkm_mobile/pages/kinerja_lulusan/evaluasi/tempatkerja.dart';
import 'package:gkm_mobile/pages/kinerja_lulusan/evaluasi/waktutunggu.dart';
import 'package:gkm_mobile/pages/kinerja_lulusan/ipk_lulusan.dart';
import 'package:gkm_mobile/pages/kinerja_lulusan/masastudi.dart';
import 'package:gkm_mobile/pages/kinerja_lulusan/prestasi_mahasiswa/akademik.dart';
import 'package:gkm_mobile/pages/kinerja_lulusan/prestasi_mahasiswa/nonakademik.dart';
import 'package:gkm_mobile/pages/kualitas_pembelajaran/integrasi_penelitian.dart';
import 'package:gkm_mobile/pages/penelitian_dtps/dtps_penelitian_mahasiswa.dart';
import 'package:gkm_mobile/pages/penelitian_dtps/dtps_rujukan_tesis.dart';
import 'package:gkm_mobile/pages/kinerja_dosen/pengakuan_rekognisi_dosen.dart';
import 'package:gkm_mobile/pages/kinerja_dosen/pkm_dtps.dart';
import 'package:gkm_mobile/pages/kinerja_dosen/publikasi_ilmiah_dosen.dart';
import 'package:gkm_mobile/pages/kinerja_dosen/sitasi_karya_dosen.dart';
import 'package:gkm_mobile/pages/kualitas_pembelajaran/kepuasan_mahasiswa.dart';
import 'package:gkm_mobile/pages/tabelevaluasi/tabelevaluasi.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gkm_mobile/pages/kinerja_dosen/penelitian_dtps.dart';

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
        page = const Placeholder();
        break;
      case "Publikasi":
        page = const Placeholder();
        break;
      case "Sertifikasi":
        page = const Placeholder();
        break;
      case "Rekap Semua Data":
        page = tabelevaluasi();
        break;
      // Kinerja Dosen Start
      case "Pengakuan/Rekognisi Dosen":
        page = PengakuanRekognisiDosen(
          tahunAjaran: widget.tahunAjaran,
        );
        break;
      case "Penelitian DTPS":
        page = PenelitianDtps(
          tahunAjaran: widget.tahunAjaran,
        );
        break;
      case "PkM DTPS":
        page = PkmDtps(
          tahunAjaran: widget.tahunAjaran,
        );
      case "Publikasi & Pagelaran Ilmiah":
        page = PublikasiIlmiahDosen(tahunAjaran: widget.tahunAjaran);
        break;
      case "Sitasi Karya Ilmiah":
        page = SitasiKaryaDosen(
          tahunAjaran: widget.tahunAjaran,
        );
        break;
      case "Produk/Jasa Teradopsi":
        page = ProdukTeradopsiDosen(tahunAjaran: widget.tahunAjaran);
        break;
      case "Luaran Penelitian Lain - HKI (Paten)":
        page = HkiPaten(tahunAjaran: widget.tahunAjaran);
        break;
      case "Luaran Penelitian Lain - HKI (Hak Cipta)":
        page = HkiHakCipta(tahunAjaran: widget.tahunAjaran);
        break;
      case "Luaran Penelitian Lain - Teknologi & Karya":
        page = TeknologiKarya(tahunAjaran: widget.tahunAjaran);
        break;
      case "Luaran Penelitian Lain - Buku & Chapter":
        page = BukuChapterDosen(tahunAjaran: widget.tahunAjaran);
        break;
      // Kinerja Dosen End
      case "Kepuasan Mahasiswa":
        page = KinerjaKepuasanScreen(tahunAjaran: widget.tahunAjaran);
        break;
      //kinerja lulusan
      case "Evaluasi Kepuasan Pengguna":
        page = EvalKepuasan(tahunAjaran: widget.tahunAjaran);
        break;
        case "Evaluasi Kesesuaian Kerja":
        page = Kesesuaian(tahunAjaran: widget.tahunAjaran);
        break;
        case "Evaluasi Tempat Kerja":
        page = TempatKerja(tahunAjaran: widget.tahunAjaran);
        break;
        case "Evaluasi Waktu Tunggu":
        page = WaktuTunggu(tahunAjaran: widget.tahunAjaran);
        break;
        case "Prestasi Akademik Mahasiswa":
        page = PrestasiAkademik(tahunAjaran: widget.tahunAjaran);
        break;
        case "Prestasi Non Akademik Mahasiswa":
        page = PrestasiNonAkademik(tahunAjaran: widget.tahunAjaran);
        break;
        case "Ipk Lulusan":
        page = IpkLulusan(tahunAjaran: widget.tahunAjaran);
        break;
        case "Masa Studi Lulusan":
        page = MasaStudiLulusan(tahunAjaran: widget.tahunAjaran);
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page!),
    );
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
                        color: const Color.fromARGB(255, 255, 255, 255),
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
                        "Luaran Penelitian Lain - HKI (Paten)",
                        "Luaran Penelitian Lain - HKI (Hak Cipta)",
                        "Luaran Penelitian Lain - Teknologi & Karya",
                        "Luaran Penelitian Lain - Buku & Chapter",
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
                      Colors.grey.shade300,
                      ["PkM DTPS Mahasiswa"]),
                  buildMenu("Kinerja Lulusan", "assets/images/ilustrasi2.png",
                      Colors.grey.shade300, Colors.teal, [
                    "IPK Lulusan",
                    "Prestasi Akademik Mahasiswa",
                    "Prestasi Non Akademik Mahasiswa",
                    "Evaluasi Kepuasan Pengguna",
                    "Evaluasi Kesesuaian Kerja",
                    "Evaluasi Waktu Tunggu",
                    "Evaluasi Tempat Kerja",
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
