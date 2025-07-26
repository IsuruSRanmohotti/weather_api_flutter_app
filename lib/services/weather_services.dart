import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:weather_app/models/current_weather.dart';

class WeatherServices {
  String apiKey = 'key=8043c300b3df461ea25135010251207';

  Future<CurrentWeather?> getCurrentWeather(String query) async {
    final endpoint =
        'http://api.weatherapi.com/v1/current.json?$apiKey&q=$query';

    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      CurrentWeather currentWeather = CurrentWeather.fromJson(body);
      return currentWeather;
    } else {
      Logger().e(response.statusCode);
      return null;
    }
  }

  Future<void> getAutoCompleteResult(String text) async {
    final endpoint = 'http://api.weatherapi.com/v1/search.json?$apiKey&q=$text';

    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(response.body);
      Logger().e(result);
    }else{
      
    }
  }
}
