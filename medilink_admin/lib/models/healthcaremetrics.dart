
class HealthMetric {
   String? id;
   String? patient;
  String? metricName;
  String? value;
  DateTime? date;

  HealthMetric({
    this.id,
    this.patient,
    this.metricName,
    this.value,
    this.date,
  });

  factory HealthMetric.fromJson(Map<String, dynamic> json) {
    return HealthMetric(
      id: json['_id'] as String?,
      patient: json['patient']  as String?,
      metricName: json['metricName'] as String?,
      value: json['value'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
}
