import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/Cubits/get_current_weather_cubit/get_weather_cubit.dart';
import 'package:myapp/Cubits/get_current_weather_cubit/get_weather_states.dart';
import 'package:myapp/Pages/Home_Page.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetWeatherCubit(),
      child: Builder(
        builder: (context) => BlocBuilder<GetWeatherCubit, WeatherState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Weather App',
              theme: ThemeData(
                appBarTheme: AppBarTheme(
                  color: getThemeColor(BlocProvider.of<GetWeatherCubit>(context)
                      .weatherModel
                      ?.condition),
                ),
              ),
              home: const HomePage(),
            );
          },
        ),
      ),
    );
  }
}


MaterialColor getThemeColor(String? weatherCondition) {
  // Convert to lowercase for case-insensitive comparison
  if (weatherCondition == null) {
    return Colors.blue;
  }
  final condition = weatherCondition.toLowerCase();

  // Clear/Sunny conditions
  if (condition.contains('sunny') || condition.contains('clear')) {
    return Colors.orange; // Bright yellow/orange for sunny days
  }

  // Cloudy variations
  else if (condition.contains('cloud') || condition.contains('overcast')) {
    return Colors.blueGrey; // Grey-blue for cloudy weather
  }

  // Fog and mist conditions
  else if (condition.contains('fog') || condition.contains('mist')) {
    return Colors.grey; // Grey for low visibility conditions
  }

  // Rain conditions
  else if (condition.contains('rain') ||
      condition.contains('drizzle') ||
      condition.contains('shower')) {
    return Colors.indigo; // Deep blue for rain
  }

  // Snow and ice conditions
  else if (condition.contains('snow') ||
      condition.contains('blizzard') ||
      condition.contains('ice pellet')) {
    return Colors.cyan; // Cyan/light blue for cold/snow
  }

  // Thunder conditions
  else if (condition.contains('thunder')) {
    return Colors.deepPurple; // Purple for storms/thunder
  }

  // Sleet and mixed conditions
  else if (condition.contains('sleet') || condition.contains('freezing')) {
    return Colors.teal; // Teal for mixed precipitation
  }

  // Default fallback color
  else {
    return Colors.blue;
  }
}
