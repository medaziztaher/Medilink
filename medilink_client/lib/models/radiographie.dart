

import '../settings/path.dart';

class Radiographie {
  String? id;
  String? patient;
  String? provider;
  String? type;
  String? description;
  DateTime? date;
  String? reason;
  List<RadiographieResult>? results;

  Radiographie({
    this.id,
    this.patient,
    this.provider,
    this.type,
    this.description,
    this.date,
    this.reason,
    this.results,
  });

  factory Radiographie.fromJson(Map<String, dynamic> json) {
    List<RadiographieResult>files=json['files'] != null
        ? (json['files'] as List<dynamic>).map((item) {
            String id = item['id'] as String;
            String url = "$radiographiePath/${item['url']}";
            return RadiographieResult(id: id, url: url);
          }).toList()
        : [];
    return Radiographie(
      id: json['_id'] as String?,
      patient: json['patient'] as String?,
      provider: json['provider']  as String?,
      type: json['type'] as String?,
      description: json['description'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      reason: json['reason'] as String?,
      results: files,
    );
  }
}

class RadiographieResult {
  String? id;
  String? url;

  RadiographieResult({this.id, this.url});
}
