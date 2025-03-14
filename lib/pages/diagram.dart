import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gkm_mobile/pages/dashboard/frontend/datamahasiswa.dart';

class GrafikMahasiswa extends StatelessWidget {
  const GrafikMahasiswa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grafik Data Mahasiswa"),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Grafik Data Mahasiswa",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text("Semester genap 2023 / 2024"),
            const SizedBox(height: 20),

            // Pie Chart
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.green,
                      value: 40,
                      title: "Daya Tampung",
                      radius: 40,
                    ),
                    PieChartSectionData(
                      color: Colors.blue,
                      value: 30,
                      title: "Lulus Seleksi",
                      radius: 40,
                    ),
                    PieChartSectionData(
                      color: Colors.red,
                      value: 20,
                      title: "Maba Reguler",
                      radius: 40,
                    ),
                    PieChartSectionData(
                      color: Colors.yellow,
                      value: 10,
                      title: "Mahasiswa Aktif",
                      radius: 40,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Dropdown Menu (Filter)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Daya tampung",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            // Bar Chart
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(toY: 40, color: Colors.green, width: 16),
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(toY: 200, color: Colors.green, width: 16),
                    ]),
                    BarChartGroupData(x: 3, barRods: [
                      BarChartRodData(toY: 150, color: Colors.green, width: 16),
                    ]),
                    BarChartGroupData(x: 4, barRods: [
                      BarChartRodData(toY: 100, color: Colors.green, width: 16),
                    ]),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 1:
                              return const Text('TS 1');
                            case 2:
                              return const Text('TS 2');
                            case 3:
                              return const Text('TS 3');
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Tombol untuk melihat detail tabel
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade900,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () {
                 Navigator.push(
                            context,
                              MaterialPageRoute(builder: (context) => datamahasiswa()),
                             );
              },
              child: const Text(
                "Lihat detail tabel",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
