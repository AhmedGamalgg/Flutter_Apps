import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/Cubits/get_current_weather_cubit/get_weather_states.dart';
import 'package:myapp/Models/Weather_data_model.dart';
import 'package:myapp/Services/API_Service.dart';

class GetWeatherCubit extends Cubit<WeatherState> {
  GetWeatherCubit() : super(NoWeatherState());
  //if the tree of variables is complicated where the model will be used we use this:
   WeatherDataModel? weatherModel;
  getWeather({required String cityName}) async {
    try {
      weatherModel =
          await ApiRequest().getJson(country: cityName);
      emit(WeatherLoadedState(weatherModel!));
    } catch (e) {
      emit(WeatherFailedState(e.toString()));
    }
  }
}
