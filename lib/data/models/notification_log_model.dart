class NotificationLogModel {
  final int? id;
  final String title;
  final String message;
  final String level;
  final String createdAt;

  NotificationLogModel({
    this.id,
    required this.title,
    required this.message,
    required this.level,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'level': level,
      'created_at': createdAt,
    };
  }

  factory NotificationLogModel.fromMap(Map<String, dynamic> map) {
    return NotificationLogModel(
      id: map['id'],
      title: map['title'],
      message: map['message'],
      level: map['level'],
      createdAt: map['created_at'],
    );
  }
}