import '../settings/path.dart';

class Surgerie {
  String? id;
  String? patient;
  String? provider;
  String? type;
  DateTime? date;
  String? description;
  String? complications;
  List<SurgeryFiles>? files;

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
    List<SurgeryFiles> files = json['files'] != null
        ? (json['files'] as List<dynamic>)
            .map((item) => SurgeryFiles(
                type: item['type'] as String?,
                id: item['id'] as String?,
                url: "$surgeriePath/${item['url']}"))
            .toList()
        : [];

    return Surgerie(
        id: json['_id'] as String?,
        patient: json['patient'] as String?,
        provider: json['provider'] as String?,
        type: json['type'] as String?,
        date: json['date'] != null ? DateTime.parse(json['date']) : null,
        description: json['description'] as String?,
        complications: json['complications'] as String?,
        files: files);
  }
}

class SurgeryFiles {
  String? type;
  String? id;
  String? url;

  SurgeryFiles({
    this.type,
    this.id,
    this.url,
  });
}
