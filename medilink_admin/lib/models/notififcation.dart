class Notification {
  String? id;
  String? userId;
  String? message;
  DateTime? date;

  Notification({
    this.id,
    this.userId,
    this.message,
    this.date,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      message: json['message'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
}