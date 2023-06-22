

import '../services/path.dart';

class Labresult {
   String? id;
   String? patient;
   String? provider;
  String? test;
  String? result;
  DateTime? date;
  String? reason;
  List<LabresultFile>? files;
  List<String>?sharedwith;

  Labresult({
    this.id,
    this.patient,
    this.provider,
    this.test,
    this.result,
    this.date,
    this.reason,
    this.files,
    this.sharedwith
  });

  factory Labresult.fromJson(Map<String, dynamic> json) {
    List<LabresultFile>files=json['files'] != null
        ? (json['files'] as List<dynamic>).map((item) {
            String id = item['id'] as String;
            String url = "$labPath/${item['url']}";
            return LabresultFile(id: id, url: url);
          }).toList()
        : [];
        List<String>? sharedwith;
    if (json['sharedwith'] != null) {
      sharedwith = [];
      json['sharedwith'].forEach((appId) {
        sharedwith!.add(appId);
      });
    }
    
    return Labresult(
      id: json['_id'] as String?,
      patient: json['patient']  as String?,
      provider: json['provider']  as String?,
      test: json['test'] as String?,
      result: json['result'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      reason: json['reason'] as String?,
      files: files,
      sharedwith: sharedwith
    );
  }
}

class LabresultFile {
  String? id;
  String? url;

  LabresultFile({
    this.id,
    this.url,
  });
}
