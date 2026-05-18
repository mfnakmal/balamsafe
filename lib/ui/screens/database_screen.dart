import 'package:flutter/material.dart';
import 'dart:math';

import '../../data/database/database_helper.dart';
import '../../data/models/district_weather_model.dart';

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({super.key});

  @override
  State<DatabaseScreen> createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {

  final Random _random = Random();

String get _currentTime {
  final now = DateTime.now();
  final hour = now.hour.toString().padLeft(2, '0');
  final minute = now.minute.toString().padLeft(2, '0');
  return "$hour:$minute";
}

double _randomRain() {
  final options = [
    1.0 + _random.nextDouble() * 3.9,  // Aman
    5.0 + _random.nextDouble() * 10.0, // Waspada
    15.1 + _random.nextDouble() * 13.0 // Bahaya
  ];

  return double.parse(
    options[_random.nextInt(options.length)].toStringAsFixed(1),
  );
}

Future<void> _refreshDummyData() async {
  for (final item in _data) {
    final updatedItem = DistrictWeatherModel(
      id: item.id,
      district: item.district,
      rain: _randomRain(),
      lastUpdate: _currentTime,
      latitude: item.latitude,
      longitude: item.longitude,
    );

    await DatabaseHelper.instance.updateDistrictWeather(updatedItem);
  }

  await _loadDatabase();

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Data wilayah berhasil diperbarui"),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

  List<DistrictWeatherModel> _data = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  Future<void> _loadDatabase() async {
    final result = await DatabaseHelper.instance.getAllDistrictWeather();

    if (!mounted) return;

    setState(() {
      _data = result;
      _loading = false;
    });
  }

  String _level(double rain) {
    if (rain < 5) return "Aman";
    if (rain <= 15) return "Waspada";
    return "Bahaya";
  }

  String _description(double rain) {
    if (rain < 5) return "Kondisi relatif aman";
    if (rain <= 15) return "Perlu pemantauan berkala";
    return "Risiko tinggi, segera waspada";
  }

  Color _levelColor(double rain) {
    if (rain < 5) return const Color(0xFF22C55E);
    if (rain <= 15) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  Color _levelBgColor(double rain) {
    if (rain < 5) return const Color(0xFFE8F8EE);
    if (rain <= 15) return const Color(0xFFFFF4DD);
    return const Color(0xFFFFE8E8);
  }

  IconData _levelIcon(double rain) {
    if (rain < 5) return Icons.check_circle;
    if (rain <= 15) return Icons.warning_amber_rounded;
    return Icons.dangerous_rounded;
  }

  int get _safeCount => _data.where((e) => e.rain < 5).length;
  int get _warningCount => _data.where((e) => e.rain >= 5 && e.rain <= 15).length;
  int get _dangerCount => _data.where((e) => e.rain > 15).length;

  Widget _buildSummaryCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 21,
              backgroundColor: color.withOpacity(0.13),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistrictCard(DistrictWeatherModel item) {
    final color = _levelColor(item.rain);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: _levelBgColor(item.rain),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              _levelIcon(item.rain),
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.district,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _description(item.rain),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildMiniBadge(
                      icon: Icons.water_drop,
                      text: "${item.rain.toStringAsFixed(1)} mm/jam",
                      color: color,
                    ),
                    _buildMiniBadge(
                      icon: Icons.access_time,
                      text: item.lastUpdate,
                      color: const Color(0xFF2563EB),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              _level(item.rain),
              style: TextStyle(
                color: color,
                fontSize: 12.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBadge({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatabaseInfo() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF5FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD7E8FF)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.storage_rounded, color: Color(0xFF1565D8)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Data wilayah disimpan menggunakan SQLite. Aplikasi membaca dan memperbarui data dari database lokal BalamSafe.",
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: Color(0xFF374151),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FB),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Pantauan Wilayah",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xFF111827),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _refreshDummyData,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshDummyData,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
                children: [
                  const Text(
                    "Pantauan Kecamatan",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Ringkasan kondisi curah hujan tiap wilayah Bandar Lampung.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF6B7280),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildSummaryCard(
                        title: "Aman",
                        count: _safeCount,
                        color: const Color(0xFF22C55E),
                        icon: Icons.check_circle,
                      ),
                      const SizedBox(width: 12),
                      _buildSummaryCard(
                        title: "Waspada",
                        count: _warningCount,
                        color: const Color(0xFFF59E0B),
                        icon: Icons.warning_amber_rounded,
                      ),
                      const SizedBox(width: 12),
                      _buildSummaryCard(
                        title: "Bahaya",
                        count: _dangerCount,
                        color: const Color(0xFFEF4444),
                        icon: Icons.dangerous_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildDatabaseInfo(),
                  const SizedBox(height: 24),
                  const Text(
                    "Daftar Wilayah",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ..._data.map(_buildDistrictCard),
                ],
              ),
            ),
    );
  }
}