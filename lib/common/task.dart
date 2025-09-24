// lib/models/task.dart
class Task {
  String title;
  bool isCompleted;
  DateTime? createdAt;

  Task({
    required this.title,
    this.isCompleted = false,
    this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}