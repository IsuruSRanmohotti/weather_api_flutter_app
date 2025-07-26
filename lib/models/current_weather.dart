class CurrentWeather {
  String name;
  double temp;
  Condition condition;

  CurrentWeather({
    required this.name,
    required this.temp,
    required this.condition,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      name: json['location']['name'],
      temp: json['current']['temp_c'],
      condition: Condition.fromJson(json['current']['condition']),
    );
  }
}

class Condition {
  String text;
  String icon;

  Condition({required this.icon, required this.text});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(icon: 'https:${json['icon']}', text: json['text']);
  }
}
