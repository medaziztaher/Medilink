

class Appointment {
   String? id;
   String? patient;
   String? provider;
  DateTime? date;
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
    return Appointment(
      id: json['_id'] as String?,
      patient: json['patient'] as String?,
      provider: json['provider'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      time: json['time'] as String?,
      reason: json['reason'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['_id'] = id;
    if (patient != null) data['patient'] = patient;
    if (provider != null) data['provider'] = provider;
    if (date != null) data['date'] = date!.toIso8601String();
    if (time != null) data['time'] = time;
    if (reason != null) data['reason'] = reason;
    if (status != null) data['status'] = status;
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();
    return data;
  }
}
