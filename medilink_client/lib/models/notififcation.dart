import 'package:intl/intl.dart';

class Notification {
  String? id;
  String? userId;
  String? message;
  String? date;

  Notification({
    this.id,
    this.userId,
    this.message,
    this.date,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    String? formattedDate;
    if (json['date'] != null) {
      DateTime date = DateTime.parse(json['date']);
      formattedDate = DateFormat('yyyy-MM-dd').format(date);
    }
    return Notification(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      message: json['message'] as String?,
      date: formattedDate,
    );
  }
}
