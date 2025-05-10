import 'package:myapp/Models/Weather_data_model.dart';

class WeatherState {}

class WeatherLoadedState extends WeatherState {
  WeatherDataModel weatherModel;
  WeatherLoadedState(this.weatherModel);
}

class NoWeatherState extends WeatherState {}

class WeatherFailedState extends WeatherState {
  String errorMessage;
  WeatherFailedState(this.errorMessage);
}
