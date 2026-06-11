import 'package:flutter/material.dart';

class MonitoringCard extends StatelessWidget {
  const MonitoringCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.sensors,
            color: Color(0xFF00A896),
            size: 24,
          ),

          SizedBox(width: 11),

          Expanded(
            child: Text(
              "Monitoring aktif, siap terhubung ke API real-time",
              style: TextStyle(
                color: Color(0xFF202637),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}