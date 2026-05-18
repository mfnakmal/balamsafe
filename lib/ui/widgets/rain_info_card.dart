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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1326),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF0D5E9E).withOpacity(0.45),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.water_drop, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Curah Hujan",
                  style: TextStyle(color: Color(0xFFAAB0C0), fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  "${rain.toStringAsFixed(1)} mm/jam",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "Update $lastUpdate",
                  style: const TextStyle(
                    color: Color(0xFF8D93A6),
                    fontSize: 12,
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