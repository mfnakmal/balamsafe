import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/district_weather_model.dart';
import '../models/notification_log_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('balamsafe.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE district_weather (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        district TEXT NOT NULL,
        rain REAL NOT NULL,
        last_update TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notification_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        level TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await _seedDistrictWeather(db);
  }

  Future<void> resetDistrictWeather() async {
  final db = await database;

  await db.delete('district_weather');
  await _seedDistrictWeather(db);
}

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    await db.delete('district_weather');
    await _seedDistrictWeather(db);
  }

  Future<void> _seedDistrictWeather(Database db) async {
    final data = [
      DistrictWeatherModel(
        district: "Bumi Waras",
        rain: 4.6,
        lastUpdate: "00:00",
        latitude: -5.4448,
        longitude: 105.2864,
      ),
      DistrictWeatherModel(
        district: "Enggal",
        rain: 3.8,
        lastUpdate: "00:00",
        latitude: -5.4217,
        longitude: 105.2596,
      ),
      DistrictWeatherModel(
        district: "Kedamaian",
        rain: 6.7,
        lastUpdate: "00:00",
        latitude: -5.4165,
        longitude: 105.2857,
      ),
      DistrictWeatherModel(
        district: "Kedaton",
        rain: 7.8,
        lastUpdate: "00:00",
        latitude: -5.3827,
        longitude: 105.2574,
      ),
      DistrictWeatherModel(
        district: "Kemiling",
        rain: 3.2,
        lastUpdate: "00:00",
        latitude: -5.3970,
        longitude: 105.1870,
      ),
      DistrictWeatherModel(
        district: "Labuhan Ratu",
        rain: 5.9,
        lastUpdate: "00:00",
        latitude: -5.3679,
        longitude: 105.2525,
      ),
      DistrictWeatherModel(
        district: "Langkapura",
        rain: 4.1,
        lastUpdate: "00:00",
        latitude: -5.3828,
        longitude: 105.2120,
      ),
      DistrictWeatherModel(
        district: "Panjang",
        rain: 10.4,
        lastUpdate: "00:00",
        latitude: -5.4720,
        longitude: 105.3210,
      ),
      DistrictWeatherModel(
        district: "Rajabasa",
        rain: 3.9,
        lastUpdate: "00:00",
        latitude: -5.3650,
        longitude: 105.2300,
      ),
      DistrictWeatherModel(
        district: "Sukabumi",
        rain: 8.6,
        lastUpdate: "00:00",
        latitude: -5.4082,
        longitude: 105.3191,
      ),
      DistrictWeatherModel(
        district: "Sukarame",
        rain: 9.5,
        lastUpdate: "00:00",
        latitude: -5.3820,
        longitude: 105.3000,
      ),
      DistrictWeatherModel(
        district: "Tanjung Karang Barat",
        rain: 5.2,
        lastUpdate: "00:00",
        latitude: -5.4100,
        longitude: 105.2380,
      ),
      DistrictWeatherModel(
        district: "Tanjung Karang Pusat",
        rain: 6.4,
        lastUpdate: "00:00",
        latitude: -5.4164,
        longitude: 105.2580,
      ),
      DistrictWeatherModel(
        district: "Tanjung Karang Timur",
        rain: 7.1,
        lastUpdate: "00:00",
        latitude: -5.4148,
        longitude: 105.2765,
      ),
      DistrictWeatherModel(
        district: "Tanjung Senang",
        rain: 4.8,
        lastUpdate: "00:00",
        latitude: -5.3590,
        longitude: 105.2920,
      ),
      DistrictWeatherModel(
        district: "Teluk Betung Barat",
        rain: 11.2,
        lastUpdate: "00:00",
        latitude: -5.4390,
        longitude: 105.2180,
      ),
      DistrictWeatherModel(
        district: "Teluk Betung Selatan",
        rain: 14.1,
        lastUpdate: "00:00",
        latitude: -5.4475,
        longitude: 105.2515,
      ),
      DistrictWeatherModel(
        district: "Teluk Betung Timur",
        rain: 16.9,
        lastUpdate: "00:00",
        latitude: -5.4550,
        longitude: 105.2870,
      ),
      DistrictWeatherModel(
        district: "Teluk Betung Utara",
        rain: 12.8,
        lastUpdate: "00:00",
        latitude: -5.4280,
        longitude: 105.2590,
      ),
      DistrictWeatherModel(
        district: "Way Halim",
        rain: 12.3,
        lastUpdate: "00:00",
        latitude: -5.3851,
        longitude: 105.2711,
      ),
    ];

    for (final item in data) {
      await db.insert('district_weather', item.toMap());
    }
  }

  Future<List<DistrictWeatherModel>> getAllDistrictWeather() async {
    final db = await database;

    final result = await db.query(
      'district_weather',
      orderBy: 'district ASC',
    );

    return result.map((map) => DistrictWeatherModel.fromMap(map)).toList();
  }

  Future<void> updateDistrictWeather(DistrictWeatherModel item) async {
    final db = await database;

    await db.update(
      'district_weather',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> insertNotificationLog(NotificationLogModel log) async {
    final db = await database;
    await db.insert('notification_logs', log.toMap());
  }

  Future<List<NotificationLogModel>> getNotificationLogs() async {
    final db = await database;

    final result = await db.query(
      'notification_logs',
      orderBy: 'id DESC',
    );

    return result.map((map) => NotificationLogModel.fromMap(map)).toList();
  }

  Future<void> clearNotificationLogs() async {
    final db = await database;
    await db.delete('notification_logs');
  }
}