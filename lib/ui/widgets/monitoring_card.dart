import 'package:flutter/material.dart';

class MonitoringCard extends StatelessWidget {
  const MonitoringCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.sensors, color: Color(0xFF00A896), size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Monitoring aktif, siap terhubung ke API real-time",
              style: TextStyle(
                color: Color(0xFF202637),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}