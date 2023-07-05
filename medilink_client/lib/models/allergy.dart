import 'package:intl/intl.dart';

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
    String? formattedDate;
    if (json['yearOfDiscovery'] != null) {
      DateTime date = DateTime.parse(json['yearOfDiscovery']);
      formattedDate = DateFormat('yyyy-MM-dd').format(date);
    }
    return Allergy(
      id: json['_id'] as String?,
      patient: json['patient'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      yearOfDiscovery: formattedDate,
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
    if (yearOfDiscovery != null) {
      DateTime date = DateTime.parse(yearOfDiscovery!);
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      data['yearOfDiscovery'] = formattedDate;
    }
    if (followupStatus != null) data['followupStatus'] = followupStatus;
    if (familyHistory != null) data['familyHistory'] = familyHistory;
    if (notes != null) data['notes'] = notes;
    return data;
  }
}
