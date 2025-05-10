import 'dart:developer';

class WeatherDataModel {
  final String cityName;
  final String? image;
  final double maxTemp;
  final double minTemp;
  final double currentTemp;
  final String condition;
  final DateTime lastUpdated;

  const WeatherDataModel(
      {required this.currentTemp,
      required this.condition,
      required this.maxTemp,
      required this.minTemp,
      required this.lastUpdated,
      required this.cityName,
      this.image});

  factory WeatherDataModel.fromJson(json) {

    return WeatherDataModel(
        currentTemp: json["current"]["temp_c"],
        condition: json["current"]["condition"]["text"],
        maxTemp: json["forecast"]["forecastday"][0]["day"]["maxtemp_c"],
        minTemp: json["forecast"]["forecastday"][0]["day"]["mintemp_c"],
        lastUpdated: DateTime.parse(json["current"]["last_updated"]),
        cityName: json["location"]["name"],
        image: json["current"]["condition"]["icon"]);
  }
}
