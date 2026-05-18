import 'package:flutter/material.dart';

import 'data/services/notification_service.dart';
import 'ui/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.instance.init();

  runApp(const BalamSafeApp());
}

class BalamSafeApp extends StatelessWidget {
  const BalamSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BalamSafe",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Roboto",
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}