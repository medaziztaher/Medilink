

import '../settings/path.dart';

class Experience {
  String? id;
  String? provider;
  String? position;
  String? institution;
  int? startYear;
  int? endYear;
  List<ExperienceFile>? files;

  Experience({
    this.id,
    this.provider,
    this.position,
    this.institution,
    this.startYear,
    this.endYear,
    this.files,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    List<ExperienceFile> files = json['file'] != null
        ? (json['file'] as List<dynamic>).map((item) {
            String type = item['type'] as String;
            String id = item['id'] as String;
            String url = "$experience_verififcationPath/${item['url']}";
            return ExperienceFile(type: type, id: id, url: url);
          }).toList()
        : [];
    return Experience(
        id: json['_id'] as String?,
        provider:
            json['provider']  as String?,
        position: json['position'] as String?,
        institution: json['institution'] as String?,
        startYear: json['startYear'] as int?,
        endYear: json['endYear'] as int?,
        files: files);
  }
}

class ExperienceFile {
  String? type;
  String? id;
  String? url;

  ExperienceFile({
    this.type,
    this.id,
    this.url,
  });
}
