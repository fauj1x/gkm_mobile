import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gkm_mobile/pages/rekapdata/rekapdata.dart';

class tabelevaluasi extends StatelessWidget {
  final List<Map<String, dynamic>> rekapData = [
    {
      "judul": "Kerjasama Tridharma",
      "progress": 0.2,
      "status": "Kurang peningkatan",
      "score": 40
    },
    {
      "judul": "Data Mahasiswa",
      "progress": 0.3,
      "status": "Kurang peningkatan",
      "score": 50
    },
    {
      "judul": "Data Dosen",
      "progress": 0.5,
      "status": "Perlu sedikit peningkatan",
      "score": 65
    },
    {
      "judul": "Kinerja Dosen",
      "progress": 0.7,
      "status": "Perlu peningkatan",
      "score": 80
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rekap Data & Evaluasi",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tabel Evaluasi",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: rekapData.length,
                itemBuilder: (context, index) {
                  var item = rekapData[index];

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item["judul"],
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Skor: ${item["score"]}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Rounded Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: item["progress"],
                              backgroundColor: Colors.grey[300],
                              color: _getProgressColor(item["progress"]),
                              minHeight: 12,
                            ),
                          ),

                          const SizedBox(height: 10),
                          Text(
                            item["status"],
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w200,
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // Full-Rounded Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => rekapdata()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009688),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Full-Rounded
                  ),
                ),
                child: Text(
                  "Lihat Detail Semua Tabel",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menentukan warna progress bar berdasarkan nilai
  Color _getProgressColor(double progress) {
    if (progress <= 0.3) return Colors.red;
    if (progress <= 0.5) return Colors.orange;
    if (progress <= 0.7) return Colors.yellow;
    return const Color(0xFF00B98F);
  }
}
