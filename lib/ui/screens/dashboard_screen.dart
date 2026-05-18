import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../data/database/database_helper.dart';
import '../../data/models/district_weather_model.dart';
import '../../data/models/notification_log_model.dart';
import '../../data/services/notification_service.dart';
import '../screens/notification_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/info_grid_card.dart';
import '../widgets/modern_status_card.dart';
import '../widgets/monitoring_card.dart';
import '../widgets/rain_info_card.dart';
import '../widgets/recommendation_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Random _random = Random();

  List<DistrictWeatherModel> _data = [];
  String? _selectedDistrict;
  bool _isLoading = true;

  static const double _sidePadding = 16;

  String get _currentTime {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  String get _currentDateTime {
    final now = DateTime.now();
    final date =
        "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
    final time =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    return "$date $time";
  }

  DistrictWeatherModel? get _selectedData {
    if (_data.isEmpty) return null;

    return _data.firstWhere(
      (item) => item.district == _selectedDistrict,
      orElse: () => _data.first,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadDatabaseData();
  }

  Future<void> _loadDatabaseData() async {
    final result = await DatabaseHelper.instance.getAllDistrictWeather();

    if (!mounted) return;

    setState(() {
      _data = result;
      _selectedDistrict ??= result.isNotEmpty ? result.first.district : null;
      _isLoading = false;
    });
  }

  double _randomRain() {
    final options = [
      1.0 + _random.nextDouble() * 3.9,
      5.0 + _random.nextDouble() * 10.0,
      15.1 + _random.nextDouble() * 13.0,
    ];

    return double.parse(
      options[_random.nextInt(options.length)].toStringAsFixed(1),
    );
  }

  Future<void> _refreshData() async {
    if (_data.isEmpty) return;

    final updatedData = <DistrictWeatherModel>[];

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

      if (updatedItem.rain > 15) {
        final title = "Peringatan Bahaya Banjir";
        final message =
            "Curah hujan di ${updatedItem.district} mencapai ${updatedItem.rain.toStringAsFixed(1)} mm/jam. Segera waspada!";

        await NotificationService.instance.showFloodWarning(
          title: title,
          body: message,
        );

        await DatabaseHelper.instance.insertNotificationLog(
          NotificationLogModel(
            title: title,
            message: message,
            level: "Bahaya",
            createdAt: _currentDateTime,
          ),
        );
      }

      updatedData.add(updatedItem);
    }

    if (!mounted) return;

    setState(() {
      _data = updatedData;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data berhasil diperbarui"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 23),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1565D8), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Builder(
          builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _circleButton(
                      icon: Icons.menu_rounded,
                      onTap: () => Scaffold.of(context).openDrawer(),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "BalamSafe",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _circleButton(
                      icon: Icons.notifications_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  "Peringatan Dini Banjir",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Bandar Lampung • Update otomatis tiap 1 jam",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.88),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDistrictSelector() {
    return Container(
      margin: const EdgeInsets.fromLTRB(_sidePadding, 12, _sidePadding, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedDistrict,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: _data.map((item) {
            return DropdownMenuItem(
              value: item.district,
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 21,
                    color: Color(0xFF202637),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.district,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF202637),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedDistrict = value);
          },
        ),
      ),
    );
  }

  Widget _buildMapPreview(DistrictWeatherModel data) {
    final point = LatLng(data.latitude, data.longitude);

    return Container(
      height: 165,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: point,
                initialZoom: 12.7,
                minZoom: 10,
                maxZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: "com.example.balamsafe",
                ),
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: point,
                      radius: 600,
                      useRadiusInMeter: true,
                      color: const Color(0xFF2E7D32).withOpacity(0.20),
                      borderColor: const Color(0xFF2E7D32),
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: point,
                      width: 48,
                      height: 48,
                      child: const Icon(
                        Icons.location_on,
                        color: Color(0xFF2E7D32),
                        size: 44,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 12,
              top: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.map_rounded,
                      color: Color(0xFF2E7D32),
                      size: 18,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      data.district,
                      style: const TextStyle(
                        color: Color(0xFF171B26),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _sidePadding),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF202637),
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFFF5F7FB),
      body: Column(
        children: [
          _buildHeader(),
          const Expanded(
            child: Center(
              child: Text(
                "Data database belum tersedia",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _selectedData;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F7FB),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (data == null) {
      return _buildEmptyState();
    }

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFFF5F7FB),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildHeader(),
              _buildDistrictSelector(),
              const SizedBox(height: 12),

              ModernStatusCard(
                district: data.district,
                rain: data.rain,
              ),

              const SizedBox(height: 12),

              RainInfoCard(
                rain: data.rain,
                lastUpdate: data.lastUpdate,
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _sidePadding),
                child: Row(
                  children: [
                    Expanded(
                      child: InfoGridCard(
                        icon: Icons.apartment_rounded,
                        iconColor: const Color(0xFF2196F3),
                        iconBg: const Color(0xFFE3F2FD),
                        label: "Wilayah",
                        value: data.district,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InfoGridCard(
                        icon: Icons.access_time_filled_rounded,
                        iconColor: const Color(0xFFFF9800),
                        iconBg: const Color(0xFFFFF3E0),
                        label: "Update",
                        value: data.lastUpdate,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: _sidePadding),
                child: MonitoringCard(),
              ),

              const SizedBox(height: 18),

              _sectionTitle("Peta Lokasi"),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _sidePadding),
                child: _buildMapPreview(data),
              ),

              const SizedBox(height: 18),

              _sectionTitle("Rekomendasi"),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _sidePadding),
                child: RecommendationCard(rain: data.rain),
              ),

              const SizedBox(height: 92),
            ],
          ),

          Positioned(
            right: 16,
            bottom: 18,
            child: ElevatedButton.icon(
              onPressed: _refreshData,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text("Refresh"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565D8),
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: const Color(0xFF1565D8).withOpacity(0.35),
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}