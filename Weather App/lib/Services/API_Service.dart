import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:myapp/Models/Weather_data_model.dart';

class ApiRequest {
  Dio dio = Dio();
  final String baseUrl = "https://api.weatherapi.com/v1";
  final String apiKey = "38804cbdc28c48108a554119252102";
  Future<WeatherDataModel> getJson({required String country}) async {
    try {
      final Response response =
          await dio.get("$baseUrl/forecast.json?key=$apiKey&q=$country&days=1");
      final WeatherDataModel weatherData =
          WeatherDataModel.fromJson(response.data);
      return weatherData;
    } on DioException catch (e) {
      final String errorMessage = e.response?.data['error']['message'] ??
          'Oops! Something went wrong.Try again later!';
      throw Exception(errorMessage);
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load weather data: $e');
    }
  }
}
