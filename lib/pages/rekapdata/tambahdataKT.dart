import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormKerjasamaTridharma extends StatelessWidget {
  final TextEditingController totalController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  FormKerjasamaTridharma({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tambah Data",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 2),
            Text(
              "Rekap Data/Kerjasama Tridharma",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tambah Data Baru",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF009688),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Silakan tambahkan catatan barumu\ndimana GKM !",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 32),

            Text(
              "Total",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: totalController,
              decoration: InputDecoration(
                hintText: "Buat Catatan Jumlah Total",
                hintStyle: const TextStyle(color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              "Keterangan",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: keteranganController,
              decoration: InputDecoration(
                hintText: "Buat Catatan Keterangan",
                hintStyle: const TextStyle(color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // aksi ketika tombol ditekan
                  Navigator.pop(context); // contoh: kembali ke halaman sebelumnya
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B98F),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Tambahkan",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
