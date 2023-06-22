
class EmergencyContact {
   String? id;
   String? patient;
  String? name;
  String? phoneNumber;
  String? relationship;

  EmergencyContact({
    this.id,
    this.patient,
    this.name,
    this.phoneNumber,
    this.relationship,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['_id']  as String?,
      patient: json['patient'] as String?,
      name: json['name'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      relationship: json['relationship'] as String?,
    );
  }
}
