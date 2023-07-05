import 'package:intl/intl.dart';

import '../settings/path.dart';

class Surgerie {
  String? id;
  String? patient;
  String? provider;
  String? type;
  String? date;
  String? description;
  String? complications;
  List<String>? files;

  Surgerie({
    this.id,
    this.patient,
    this.provider,
    this.type,
    this.date,
    this.description,
    this.complications,
    this.files,
  });

  factory Surgerie.fromJson(Map<String, dynamic> json) {
    List<String>? files = json['files'] != null
        ? (json['files'] as List<dynamic>).map((item) {
            String url = "$surgeriePath/${item['url']}";
            return url;
          }).toList()
        : [];
    String? formattedDate;
    if (json['date'] != null) {
      DateTime date = DateTime.parse(json['date']);
      formattedDate = DateFormat('yyyy-MM-dd').format(date);
    }
    return Surgerie(
        id: json['_id'] as String?,
        patient: json['patient'] as String?,
        provider: json['provider'] as String?,
        type: json['type'] as String?,
        date: formattedDate,
        description: json['description'] as String?,
        complications: json['complications'] as String?,
        files: files);
  }
}
