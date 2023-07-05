import 'package:intl/intl.dart';

class Disease {
  String? id;
  String? patient;
  String? speciality;
  bool? genetic;
  bool? chronicDisease;
  String? detectedIn;
  String? curedIn;
  String? notes;

  Disease({
    this.id,
    this.patient,
    this.speciality,
    this.genetic,
    this.chronicDisease,
    this.detectedIn,
    this.curedIn,
    this.notes,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    String? formattedDate;
    if (json['detectedIn'] != null) {
      DateTime date = DateTime.parse(json['detectedIn']);
      formattedDate = DateFormat('yyyy-MM-dd').format(date);
    }
    String? formattedDate1;
    if (json['curedIn'] != null) {
      DateTime date = DateTime.parse(json['curedIn']);
      formattedDate1 = DateFormat('yyyy-MM-dd').format(date);
    }
    return Disease(
      id: json['_id'] as String?,
      patient: json['patient'] as String?,
      speciality: json['speciality'] as String?,
      genetic: json['genetic'] as bool?,
      chronicDisease: json['chronicDisease'] as bool?,
      detectedIn: formattedDate,
      curedIn: formattedDate1,
      notes: json['notes'] as String?,
    );
  }
}
