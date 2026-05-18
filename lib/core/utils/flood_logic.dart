import 'package:flutter/material.dart';

class FloodLogic {
  static String getStatus(double rain) {
    if (rain < 5) return "Aman";
    if (rain <= 15) return "Waspada";
    return "Bahaya";
  }

  static String getDescription(double rain) {
    if (rain < 5) {
      return "Kondisi curah hujan rendah. Tetap pantau informasi cuaca.";
    } else if (rain <= 15) {
      return "Curah hujan sedang meningkat. Tetap waspada.";
    } else {
      return "Curah hujan tinggi. Waspadai potensi banjir di sekitar Anda.";
    }
  }

  static List<Color> getGradient(double rain) {
    if (rain < 5) {
      return const [Color(0xFF20C997), Color(0xFF2ED573)];
    } else if (rain <= 15) {
      return const [Color(0xFFFFA726), Color(0xFFFFC04D)];
    } else {
      return const [Color(0xFFFF5252), Color(0xFFFF7675)];
    }
  }

  static Color getStatusColor(double rain) {
    if (rain < 5) return const Color(0xFF20C997);
    if (rain <= 15) return const Color(0xFFFFA726);
    return const Color(0xFFFF5252);
  }
}