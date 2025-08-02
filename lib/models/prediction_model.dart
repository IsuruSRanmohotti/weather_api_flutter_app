class PredictionModel {
  String name;
  String country;

  PredictionModel({required this.name, required this.country});

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(name: json['name'], country: json['country']);
  }
}
