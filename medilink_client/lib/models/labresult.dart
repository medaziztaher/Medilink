import 'package:intl/intl.dart';

import '../settings/path.dart';

class Labresult {
  String? id;
  String? patient;
  String? provider;
  String? test;
  String? result;
  String? date;
  String? reason;
  List<String>? files; 

  Labresult({
    this.id,
    this.patient,
    this.provider,
    this.test,
    this.result,
    this.date,
    this.reason,
    this.files,
  });

  factory Labresult.fromJson(Map<String, dynamic> json) {
    List<String> files = json['files'] != null
        ? (json['files'] as List<dynamic>).map((item) {
            String url = "$labPath/${item['url']}";
            return url;
          }).toList()
        : [];

    String? formattedDate;
    if (json['date'] != null) {
      DateTime date = DateTime.parse(json['date']);
      formattedDate = DateFormat('yyyy-MM-dd').format(date);
    }
    return Labresult(
      id: json['_id'] as String?,
      patient: json['patient'] as String?,
      provider: json['provider'] as String?,
      test: json['test'] as String?,
      result: json['result'] as String?,
      date: formattedDate,
      reason: json['reason'] as String?,
      files: files,
    );
  }
}