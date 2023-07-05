

import 'package:intl/intl.dart';

class Prescription {
  String? id;
  String? patient;
  String? provider;
  String? medication;
  String? dosage;
  String? frequency;
  String? startDate;
  String? endDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  Prescription({
    this.id,
    this.patient,
    this.provider,
    this.medication,
    this.dosage,
    this.frequency,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    String? formattedDate;
    if (json['dateDébut'] != null) {
      DateTime date = DateTime.parse(json['dateDébut']);
      formattedDate = DateFormat('yyyy-MM-dd').format(date);
    }
    String? formattedDate1;
    if (json['dateFin'] != null) {
      DateTime date = DateTime.parse(json['dateFin']);
      formattedDate1 = DateFormat('yyyy-MM-dd').format(date);
    }
    return Prescription(
      id: json['_id'] as String?,
      patient: json['patient'] as String?,
      provider: json['provider']  as String?,
      medication: json['médicament'] as String?,
      dosage: json['dosage'] as String?,
      frequency: json['fréquence'] as String?,
      startDate: formattedDate,
      endDate: formattedDate1,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
