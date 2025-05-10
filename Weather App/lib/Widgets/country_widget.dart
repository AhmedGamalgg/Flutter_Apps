import 'package:flutter/material.dart';
import 'package:myapp/Models/Weather_data_model.dart';
import 'package:myapp/main.dart';

class CountryWidget extends StatelessWidget {
  CountryWidget({super.key, required this.weatherModel});
  final WeatherDataModel weatherModel;
  @override
  Widget build(BuildContext context) {
    // Get the base color from existing method
    MaterialColor baseColor = getThemeColor(weatherModel.condition);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          baseColor,
          baseColor[200]!,
          baseColor[50]!,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weatherModel.cityName,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
                "Updated at: ${weatherModel.lastUpdated.hour}:${weatherModel.lastUpdated.minute.toString().padLeft(2, '0')}"),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 45,
                children: [
                  Image.network("https:${weatherModel.image}",
                      width: 70, fit: BoxFit.fill),
                  Text(
                    "${weatherModel.currentTemp.round()}°C",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MaxTemp: ${weatherModel.maxTemp.round()}°C',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        'MinTemp: ${weatherModel.minTemp.round()}°C',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              '${weatherModel.condition}',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
