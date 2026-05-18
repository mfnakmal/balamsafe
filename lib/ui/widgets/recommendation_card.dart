import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  final double rain;

  const RecommendationCard({
    super.key,
    required this.rain,
  });

  String get recommendation {
    if (rain < 5) {
      return "Kondisi relatif aman. Aktivitas harian masih dapat berjalan normal, namun tetap pantau perubahan cuaca.";
    } else if (rain <= 15) {
      return "Tetap waspada. Hindari area rendah, pantau saluran air, dan siapkan barang penting jika hujan terus meningkat.";
    } else {
      return "Segera waspada banjir. Hindari bantaran sungai, amankan dokumen penting, dan ikuti arahan petugas setempat.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.tips_and_updates,
                  color: Color(0xFF2E7D32),
                  size: 30,
                ),
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Text(
                  "Rekomendasi Tindakan",
                  style: TextStyle(
                    color: Color(0xFF171B26),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            recommendation,
            style: const TextStyle(
              color: Color(0xFF5F6573),
              fontSize: 18,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}