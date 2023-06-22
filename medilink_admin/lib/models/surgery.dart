
import '../services/path.dart';

class Surgerie {
  String? id;
  String? patient;
  String? provider;
  String? type;
  DateTime? date;
  String? description;
  String? complications;
  List<String>? sharedwith;
  List<SurgeryFile>? files;

  Surgerie(
      {this.id,
      this.patient,
      this.provider,
      this.type,
      this.date,
      this.description,
      this.complications,
      this.files,
      this.sharedwith});

  factory Surgerie.fromJson(Map<String, dynamic> json) {
    List<SurgeryFile> files = json['files'] != null
        ? (json['files'] as List<dynamic>)
            .map((item) => SurgeryFile(
                type: item['type'] as String?,
                id: item['id'] as String?,
                url: "$surgeriePath/${item['url']}"))
            .toList()
        : [];
    List<String>? sharedwith;
    if (json['sharedwith'] != null) {
      sharedwith = [];
      json['sharedwith'].forEach((appId) {
        sharedwith!.add(appId);
      });
    }

    return Surgerie(
        id: json['_id'] as String?,
        patient: json['patient'] as String?,
        provider: json['provider'] as String?,
        type: json['type'] as String?,
        date: json['date'] != null ? DateTime.parse(json['date']) : null,
        description: json['description'] as String?,
        complications: json['complications'] as String?,
        sharedwith: sharedwith,
        files: files);
  }
}

class SurgeryFile {
  String? type;
  String? id;
  String? url;

  SurgeryFile({
    this.type,
    this.id,
    this.url,
  });
}
