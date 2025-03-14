import 'package:flutter/material.dart';
import 'package:gkm_mobile/pages/dashboard/frontend/rekapdata.dart';

class tableevaluasi extends StatelessWidget {
  final List<Map<String, dynamic>> rekapData = [
    {
      "judul": "Pengakuan / Rekognisi Dosen",
      "progress": 0.2,
      "status": "Kurang peningkatan"
    },
    {
      "judul": "Penelitian DPTS",
      "progress": 0.3,
      "status": "Kurang peningkatan"
    },
    {
      "judul": "Kerjasama Tridharma",
      "progress": 0.5,
      "status": "Perlu sedikit peningkatan"
    },
    {
      "judul": "Luaran Penelitian yang dihasilkan MHS",
      "progress": 0.7,
      "status": "Perlu peningkatan"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tabel Evaluasi")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tabel Evaluasi",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: rekapData.length,
                itemBuilder: (context, index) {
                  var item = rekapData[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["judul"],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: item["progress"],
                            backgroundColor: Colors.grey[300],
                            color: Colors.green,
                            minHeight: 8,
                          ),
                          SizedBox(height: 8),
                          Text(
                            item["status"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                            context,
                              MaterialPageRoute(builder: (context) => rekapdata()),
                             );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(
                "Lihat detail semua tabel",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
