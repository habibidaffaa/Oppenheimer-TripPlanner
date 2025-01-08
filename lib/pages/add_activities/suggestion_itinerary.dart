import 'package:flutter/material.dart';
import 'package:iterasi1/pages/add_days/add_days.dart';
import 'package:iterasi1/resource/custom_colors.dart';

class SuggestionItinerary extends StatefulWidget {
  const SuggestionItinerary({super.key});

  @override
  _SuggestionItineraryState createState() => _SuggestionItineraryState();
}

class _SuggestionItineraryState extends State<SuggestionItinerary>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.primary,
        title: const Text(
          "Rekomendasi Itinerary",
          style: TextStyle(
            fontFamily: 'poppins_bold',
            fontSize: 20,
            color: CustomColor.surface,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: CustomColor.surface,
            child: TabBar(
              controller: _tabController,
              indicatorColor: CustomColor.buttonColor,
              indicatorWeight: 3,
              labelColor: CustomColor.buttonColor,
              unselectedLabelColor: Colors.black,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: "Rekomendasi 1"),
                Tab(text: "Rekomendasi 2"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildItineraryContent(),
                _buildItineraryContent(), // Ganti konten jika diperlukan
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColor.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddDays(),
                  ),
                );
              },
              child: const Text(
                "Pilih",
                style: TextStyle(
                  fontFamily: 'poppins_bold',
                  fontSize: 20,
                  color: CustomColor.surface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: CustomColor.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          "Hari 1: Minggu, 1 Desember 2024\n"
          "04:00 – Berangkat dari Politeknik Elektronika Negeri Surabaya\n"
          "  • Estimasi perjalanan: 3–4 jam\n"
          "  • Rute: Tol Surabaya–Gempol, menuju Tosari, Pasuruan.\n\n"
          "08:00 – Tiba di Tosari dan Sarapan\n"
          "  • Sarapan di warung lokal.\n\n"
          "09:00 – Perjalanan ke Penanjakan 1\n"
          "  • Lanjutkan dengan jeep menuju Penanjakan 1, spot terbaik untuk pemandangan Bromo.\n"
          "  • Estimasi tiba: 1,5 jam.\n\n"
          "11:00 – Mengunjungi Kawah Bromo\n"
          "  • Lanjutkan perjalanan menuju Kawah Bromo, berjalan kaki atau menunggang kuda.\n\n"
          "13:00 – Makan siang di area Bromo\n"
          "  • Istirahat dan nikmati makan siang di warung lokal.\n\n"
          "14:00 – Mengunjungi Pasir Berbisik dan Bukit Teletubbies\n"
          "  • Estimasi waktu: 2–3 jam.\n\n"
          "17:00 – Check-in di penginapan di Cemoro Lawang\n"
          "  • Saran penginapan: Hotel dengan pemandangan Bromo.\n"
          "  • Istirahat dan makan malam.",
          style: TextStyle(
            fontSize: 16,
            // fontFamily: 'poppins_bold',
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
