class Condition {
  String text;
  String icon;

  Condition({required this.icon, required this.text});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(icon: 'https:${json['icon']}', text: json['text']);
  }
}