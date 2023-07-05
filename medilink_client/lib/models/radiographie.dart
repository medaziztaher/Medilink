import 'package:intl/intl.dart';

import '../settings/path.dart';

class Radiographie {
  String? id;
  String? patient;
  String? provider;
  String? type;
  String? description;
  String? date;
  String? reason;
  List<String>? files;

  Radiographie({
    this.id,
    this.patient,
    this.provider,
    this.type,
    this.description,
    this.date,
    this.reason,
    this.files,
  });

  factory Radiographie.fromJson(Map<String, dynamic> json) {
    List<String>? files = json['result'] != null
        ? (json['result'] as List<dynamic>).map((item) {
            String url = "$radiographiePath/${item['url']}";
            return url;
          }).toList()
        : [];
    String? formattedDate;
    if (json['date'] != null) {
      DateTime date = DateTime.parse(json['date']);
      formattedDate = DateFormat('yyyy-MM-dd').format(date);
    }
    return Radiographie(
      id: json['_id'] as String?,
      patient: json['patient'] as String?,
      provider: json['provider'] as String?,
      type: json['type'] as String?,
      description: json['description'] as String?,
      date: formattedDate,
      reason: json['reason'] as String?,
      files: files,
    );
  }
}
