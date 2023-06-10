class TodoModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime date;

  TodoModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.date,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
    };
  }
}