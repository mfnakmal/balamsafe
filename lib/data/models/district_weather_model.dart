class DistrictWeatherModel {
  final int? id;
  final String district;
  final double rain;
  final String lastUpdate;
  final double latitude;
  final double longitude;

  DistrictWeatherModel({
    this.id,
    required this.district,
    required this.rain,
    required this.lastUpdate,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'district': district,
      'rain': rain,
      'last_update': lastUpdate,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory DistrictWeatherModel.fromMap(Map<String, dynamic> map) {
    return DistrictWeatherModel(
      id: map['id'],
      district: map['district'],
      rain: (map['rain'] as num).toDouble(),
      lastUpdate: map['last_update'],
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }
}