import 'package:weather_app/models/condition_model.dart';

class HourlyWeather {
  Condition condition;
  double temp;
  DateTime time;

  HourlyWeather({
    required this.condition,
    required this.temp,
    required this.time,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      condition: Condition.fromJson(json['condition']),
      temp: json['temp_c'],
      time: DateTime.fromMillisecondsSinceEpoch((json['time_epoch'] * 1000)),
    );
  }
}
