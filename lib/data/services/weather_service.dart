import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'ISI_API_KEY_OPENWEATHERMAP_KAMU';
  final String city = 'Bandar Lampung';

  Future<double> fetchRainData() async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['rain'] != null && data['rain']['1h'] != null) {
          return (data['rain']['1h'] as num).toDouble();
        }

        return 0.0;
      } else {
        throw Exception('Gagal memuat data cuaca');
      }
    } catch (e) {
      print("Error API: $e");
      return 0.0;
    }
  }
}