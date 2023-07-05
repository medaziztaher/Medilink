import 'package:intl/intl.dart';

class Appointment {
  String? id;
  String? patient;
  String? provider;
  String? date;
  String? time;
  String? reason;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Appointment({
    this.id,
    this.patient,
    this.provider,
    this.date,
    this.time,
    this.reason,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    String? formattedDate;
    if (json['date'] != null) {
      DateTime date = DateTime.parse(json['date']);
      formattedDate = DateFormat('yyyy-MM-dd').format(date);
    }
    return Appointment(
      id: json['_id'] as String?,
      patient: json['patient'] as String?,
      provider: json['provider'] as String?,
      date: formattedDate,
      time: json['time'] as String?,
      reason: json['reason'] as String?,
      status: json['status'] as String?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['_id'] = id;
    if (patient != null) data['patient'] = patient;
    if (provider != null) data['provider'] = provider;
    if (date != null) data['date'] = date;
    if (time != null) data['time'] = time;
    if (reason != null) data['reason'] = reason;
    if (status != null) data['status'] = status;
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();
    return data;
  }
}
