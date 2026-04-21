class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String type;
  final DateTime date;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      date: DateTime.parse(json['date']),
    );
  }
}
