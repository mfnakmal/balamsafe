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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.tips_and_updates,
                  color: Color(0xFF2E7D32),
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  "Rekomendasi Tindakan",
                  style: TextStyle(
                    color: Color(0xFF171B26),
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          Text(
            recommendation,
            style: const TextStyle(
              color: Color(0xFF5F6573),
              fontSize: 13.5,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}