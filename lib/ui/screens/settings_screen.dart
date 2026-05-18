import 'package:flutter/material.dart';

import '../../data/database/database_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _dangerNotification = true;
  bool _soundAndVibration = true;
  String _updateInterval = "1 jam";
  String _mapRadius = "650 meter";

  final List<String> _intervalOptions = [
    "30 menit",
    "1 jam",
    "2 jam",
    "3 jam",
  ];

  final List<String> _radiusOptions = [
    "500 meter",
    "650 meter",
    "1 km",
    "2 km",
  ];

  Future<void> _resetDummyData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reset Data?"),
          content: const Text(
            "Data curah hujan akan dikembalikan ke data awal. Riwayat notifikasi tidak akan dihapus.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Reset"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    // Butuh method reset di DatabaseHelper.
    // Kalau belum ada, lihat kode tambahan di bawah.
    await DatabaseHelper.instance.resetDistrictWeather();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data wilayah berhasil direset"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 26),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1565D8), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pengaturan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Atur pengalaman penggunaan BalamSafe",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF111827),
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 7),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(icon, color: iconColor, size: 27),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 16.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          trailing,
        ],
      ),
    );
  }

  Widget _buildDropdownSetting({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return _buildSettingCard(
      icon: icon,
      iconColor: iconColor,
      iconBg: iconBg,
      title: title,
      subtitle: subtitle,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            borderRadius: BorderRadius.circular(18),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      margin: const EdgeInsets.fromLTRB(22, 8, 22, 26),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF5FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD7E8FF)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_rounded, color: Color(0xFF1565D8)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Pengaturan ini masih disimpan sementara di memori aplikasi. Nanti bisa dikembangkan agar tersimpan permanen di SQLite.",
              style: TextStyle(
                color: Color(0xFF374151),
                fontSize: 13.5,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 7),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(icon, color: color, size: 27),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 13.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(),

          _buildSectionTitle("Notifikasi"),

          _buildSettingCard(
            icon: Icons.notifications_active_rounded,
            iconColor: const Color(0xFF1565D8),
            iconBg: const Color(0xFFE3F2FD),
            title: "Peringatan Bahaya",
            subtitle: "Kirim notifikasi saat wilayah masuk level Bahaya.",
            trailing: Switch(
              value: _dangerNotification,
              activeColor: const Color(0xFF1565D8),
              onChanged: (value) {
                setState(() {
                  _dangerNotification = value;
                });
              },
            ),
          ),

          _buildSettingCard(
            icon: Icons.volume_up_rounded,
            iconColor: const Color(0xFFF59E0B),
            iconBg: const Color(0xFFFFF4DD),
            title: "Suara & Getar",
            subtitle: "Aktifkan suara dan getaran untuk peringatan.",
            trailing: Switch(
              value: _soundAndVibration,
              activeColor: const Color(0xFF1565D8),
              onChanged: (value) {
                setState(() {
                  _soundAndVibration = value;
                });
              },
            ),
          ),

          _buildSectionTitle("Pemantauan"),

          _buildDropdownSetting(
            icon: Icons.update_rounded,
            iconColor: const Color(0xFF00A896),
            iconBg: const Color(0xFFE0F7F4),
            title: "Interval Update",
            subtitle: "Seberapa sering data cuaca diperbarui.",
            value: _updateInterval,
            items: _intervalOptions,
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _updateInterval = value;
              });
            },
          ),

          _buildDropdownSetting(
            icon: Icons.radar_rounded,
            iconColor: const Color(0xFF7C3AED),
            iconBg: const Color(0xFFEDE9FE),
            title: "Radius Peta",
            subtitle: "Luas area pemantauan pada peta wilayah.",
            value: _mapRadius,
            items: _radiusOptions,
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _mapRadius = value;
              });
            },
          ),

          _buildSectionTitle("Data Aplikasi"),

          _buildActionButton(
            icon: Icons.restart_alt_rounded,
            title: "Reset Data Wilayah",
            subtitle: "Kembalikan data curah hujan ke kondisi awal.",
            color: const Color(0xFFEF4444),
            onTap: _resetDummyData,
          ),

          _buildActionButton(
            icon: Icons.storage_rounded,
            title: "Penyimpanan Lokal",
            subtitle: "Data wilayah dan riwayat notifikasi tersimpan di SQLite.",
            color: const Color(0xFF1565D8),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Database aktif: balamsafe.db"),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),

          _buildInfoBox(),
        ],
      ),
    );
  }
}