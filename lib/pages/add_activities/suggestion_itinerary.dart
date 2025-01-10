import 'package:flutter/material.dart';
import 'package:iterasi1/model/itinerary.dart';
import 'package:iterasi1/pages/add_days/add_days.dart';
import 'package:iterasi1/resource/custom_colors.dart';

class SuggestionItinerary extends StatefulWidget
 {
  final List<Itinerary> itineraries;
  const SuggestionItinerary({super.key, required this.itineraries});

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
        child:  Text(
          widget.itineraries[0].days.toString(),
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
