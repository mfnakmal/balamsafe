import 'package:flutter/material.dart';

import '../../data/database/database_helper.dart';
import '../../data/models/notification_log_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationLogModel> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final result = await DatabaseHelper.instance.getNotificationLogs();

    setState(() {
      _logs = result;
    });
  }

  Future<void> _clearLogs() async {
    await DatabaseHelper.instance.clearNotificationLogs();
    await _loadLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Notifikasi"),
        actions: [
          IconButton(
            onPressed: _clearLogs,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: _logs.isEmpty
          ? const Center(
              child: Text("Belum ada riwayat notifikasi"),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.notifications_active),
                    title: Text(log.title),
                    subtitle: Text(
                      "${log.message}\nLevel: ${log.level}\n${log.createdAt}",
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}