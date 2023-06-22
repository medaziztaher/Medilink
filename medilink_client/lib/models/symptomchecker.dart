
class SymptomCheck {
  String? id;
  String? patient;
  List<String>? symptoms;
  DateTime? date;
  String? severity;
  String? notes;

  SymptomCheck({
    this.id,
    this.patient,
    this.symptoms,
    this.date,
    this.severity,
    this.notes,
  });

  factory SymptomCheck.fromJson(Map<String, dynamic> json) {
    return SymptomCheck(
      id: json['_id'] as String?,
      patient: json['patient'] as String?,
      symptoms:List<String>.from(json['symptoms']),
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      severity: json['severity'] as String?,
      notes: json['notes'] as String?,
    );
  }
}
