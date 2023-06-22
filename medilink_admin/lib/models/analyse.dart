
import '../services/path.dart';

class Analyse {
  String? id;
  String? patient;
  String? provider;
  String? name;
  DateTime? date;
  String? result;
  List<AnalyseFile>? files;
  String? notes;
  List<String>? sharedwith;

  Analyse(
      {this.id,
      this.patient,
      this.provider,
      this.name,
      this.date,
      this.result,
      this.files,
      this.notes,
      this.sharedwith});

  factory Analyse.fromJson(Map<String, dynamic> json) {
    List<AnalyseFile>? files = json['files'] != null
        ? (json['files'] as List<dynamic>).map((item) {
            String type = item['type'] as String;
            String id = item['id'] as String;
            String url = "$analysesPath/${item['url']}";
            return AnalyseFile(type: type, id: id, url: url);
          }).toList()
        : [];
    List<String>? sharedwith;
    if (json['sharedwith'] != null) {
      sharedwith = [];
      json['sharedwith'].forEach((appId) {
        sharedwith!.add(appId);
      });
    }

    return Analyse(
        id: json['_id'] as String?,
        patient: json['patient'] as String?,
        provider: json['provider'] as String?,
        name: json['name'] as String?,
        date: json['date'] != null ? DateTime.parse(json['date']) : null,
        result: json['result'] as String?,
        files: files,
        notes: json['notes'] as String?,
        sharedwith: sharedwith);
  }
}

class AnalyseFile {
  String? type;
  String? id;
  String? url;

  AnalyseFile({
    this.type,
    this.id,
    this.url,
  });
}
