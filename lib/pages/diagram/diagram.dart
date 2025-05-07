import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gkm_mobile/pages/datamahasiswa/seleksimahasiswa.dart';
import 'package:google_fonts/google_fonts.dart';

class GrafikMahasiswa extends StatefulWidget {
  const GrafikMahasiswa({super.key});

  @override
  _GrafikMahasiswaState createState() => _GrafikMahasiswaState();
}

class _GrafikMahasiswaState extends State<GrafikMahasiswa> with SingleTickerProviderStateMixin {
  String selectedCategory = "Daya Tampung";
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Durasi animasi
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Grafik Data Mahasiswa",
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Semester Genap 2023/2024",
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Pie Chart dengan Animasi Berputar
              SizedBox(
                height: 280,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 360), // Putaran dari 0 ke 360 derajat
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value * (3.1415926535 / 180), // Konversi ke radian
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 3,
                          centerSpaceRadius: 70,
                          sections: _getPieSections(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Legend
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                children: [
                  _buildLegend("Daya Tampung", const Color(0xFFAFF4C6)),
                  _buildLegend("Pendaftar", const Color(0xFFFFE188)),
                  _buildLegend("Lulus Seleksi", const Color(0xFF01C99C)),
                  _buildLegend("Maba Reguler", const Color(0xFFFF9696)),
                  _buildLegend("Mahasiswa Aktif", const Color(0xFF34A1E6)),
                ],
              ),
              const SizedBox(height: 20),

              // Dropdown (Digeser ke kanan sedikit)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0), // Geser ke kanan
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    items: ["Daya Tampung", "Pendaftar", "Lulus Seleksi", "Maba Reguler", "Mahasiswa Aktif"]
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: GoogleFonts.poppins(fontSize: 14)),
                    ))
                        .toList(),
                    onChanged: (value) => setState(() => selectedCategory = value!),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bar Chart dengan Animasi Muncul dari Bawah
              SizedBox(
                height: 200,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return BarChart(
                      BarChartData(
                        gridData: FlGridData(show: false), // Hilangkan garis grid
                        borderData: FlBorderData(show: false), // Hilangkan border hitam
                        barGroups: _getAnimatedBars(_animationController.value), // Animasi naik
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Hilangkan angka kiri
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 1:
                                    return Text('TS 1', style: GoogleFonts.poppins(fontSize: 12));
                                  case 2:
                                    return Text('TS 2', style: GoogleFonts.poppins(fontSize: 12));
                                  case 3:
                                    return Text('TS 3', style: GoogleFonts.poppins(fontSize: 12));
                                  case 4:
                                    return Text('TS 4', style: GoogleFonts.poppins(fontSize: 12));
                                  default:
                                    return const Text('');
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Button lebih turun tanpa overflow
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF009688),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
    onPressed: () {
      // Navigasi ke halaman MahasiswaStatistikPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SeleksiMahasiswaBaruScreen(), // Halaman tujuan
        ),
      );
    },
    child: Text('Lihat Detail Table'),
  ),
)


            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk mendapatkan bagian dari Pie Chart
  List<PieChartSectionData> _getPieSections() {
    return [
      PieChartSectionData(color: const Color(0xFFAFF4C6), value: 25, title: "25%", titleStyle: _textStyle()),
      PieChartSectionData(color: const Color(0xFFFFE188), value: 20, title: "20%", titleStyle: _textStyle()),
      PieChartSectionData(color: const Color(0xFF01C99C), value: 15, title: "15%", titleStyle: _textStyle()),
      PieChartSectionData(color: const Color(0xFFFF9696), value: 20, title: "20%", titleStyle: _textStyle()),
      PieChartSectionData(color: const Color(0xFF34A1E6), value: 20, title: "20%", titleStyle: _textStyle()),
    ];
  }

  // Fungsi untuk mendapatkan bar chart dengan animasi naik
  List<BarChartGroupData> _getAnimatedBars(double animationValue) {
    return [
      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 40 * animationValue, color: const Color(0xFF009688), width: 25)]),
      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 200 * animationValue, color: const Color(0xFF009688), width: 25)]),
      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 150 * animationValue, color: const Color(0xFF009688), width: 25)]),
      BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 80 * animationValue, color: const Color(0xFF009688), width: 25)]),
    ];
  }

  TextStyle _textStyle() {
    return GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
  }

  Widget _buildLegend(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(title, style: GoogleFonts.poppins(fontSize: 14)),
      ],
    );
  }
}
