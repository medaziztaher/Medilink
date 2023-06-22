class Allergy {
  String? id;
  String? patient;
  String? type;
  String? name;
  String? yearOfDiscovery;
  String? followupStatus;
  bool? familyHistory;
  String? notes;

  Allergy({
    this.id,
    this.patient,
    this.type,
    this.name,
    this.yearOfDiscovery,
    this.followupStatus,
    this.familyHistory,
    this.notes,
  });

  factory Allergy.fromJson(Map<String, dynamic> json) {
    return Allergy(
      id: json['_id'] as String?,
      patient: json['patient'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      yearOfDiscovery: json['yearOfDiscovery'] as String?,
      followupStatus: json['followupStatus'] as String?,
      familyHistory: json['familyHistory'] as bool?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['_id'] = id;
    if (patient != null) data['patient'] = patient;
    if (type != null) data['type'] = type;
    if (name != null) data['name'] = name;
    if (yearOfDiscovery != null) data['yearOfDiscovery'] = yearOfDiscovery;
    if (followupStatus != null) data['followupStatus'] = followupStatus;
    if (familyHistory != null) data['familyHistory'] = familyHistory;
    if (notes != null) data['notes'] = notes;
    return data;
  }
}
