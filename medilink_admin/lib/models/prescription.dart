
class Prescription {
   String? id;
   String? patient;
   String? provider;
  String? medication;
  String? dosage;
  String? frequency;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? reminderTime;
  List<String>?sharedwith;

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
    this.reminderTime,
    this.sharedwith
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    List<String>? sharedwith;
    if (json['sharedwith'] != null) {
      sharedwith = [];
      json['sharedwith'].forEach((appId) {
        sharedwith!.add(appId);
      });
    }
    return Prescription(
      id: json['_id']  as String?,
      patient: json['patient']  as String?,
      provider: json['provider']  as String?,
      medication: json['médicament'] as String?,
      dosage: json['dosage'] as String?,
      frequency: json['fréquence'] as String?,
      startDate: json['dateDébut'] != null ? DateTime.parse(json['dateDébut']) : null,
      endDate: json['dateFin'] != null ? DateTime.parse(json['dateFin']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      sharedwith: sharedwith,
      reminderTime: json['reminderTime'] != null ? DateTime.parse(json['reminderTime']) : null,
    );
  }
}
