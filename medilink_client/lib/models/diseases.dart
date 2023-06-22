

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
    return Disease(
      id: json['_id'] as String?,
      patient: json['patient'] as String?,
      speciality: json['speciality'] as String?,
      genetic: json['genetic'] as bool?,
      chronicDisease: json['chronicDisease'] as bool?,
      detectedIn: json['detectedIn'] as String?,
      curedIn: json['curedIn'] as String?,
      notes: json['notes'] as String?,
    );
  }
}
