import 'package:flutter/material.dart';

class RainInfoCard extends StatelessWidget {
  final double rain;
  final String lastUpdate;

  const RainInfoCard({
    super.key,
    required this.rain,
    required this.lastUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1326),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1326).withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF0D5E9E).withOpacity(0.45),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.water_drop,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Curah Hujan Saat Ini",
                  style: TextStyle(
                    color: Color(0xFFAAB0C0),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  "${rain.toStringAsFixed(1)} mm/jam",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  "Pembaruan terakhir $lastUpdate",
                  style: const TextStyle(
                    color: Color(0xFF8D93A6),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}