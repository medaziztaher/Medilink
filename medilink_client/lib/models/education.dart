

import '../settings/path.dart';

class Education {
  String? id;
  String? provider;
  String? degree;
  String? institution;
  String? startYear;
  String? endYear;
  List<EducationFile>? files;

  Education({
    this.id,
    this.provider,
    this.degree,
    this.institution,
    this.startYear,
    this.endYear,
    this.files,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
     List<EducationFile>? files = json['file'] != null
        ? (json['file'] as List<dynamic>).map((item) {
            String type = item['type'] as String;
            String id = item['id'] as String;
            String url = "$education_verififcationPath/${item['url']}";
            return EducationFile(type: type, id: id, url: url);
          }).toList()
        : [];
    
    
    return Education(
      id: json['_id'] as String?,
      provider: json['provider']  as String?,
      degree: json['degree'] as String?,
      institution: json['institution'] as String?,
      startYear: json['startYear'] as String?,
      endYear: json['endYear'] as String?,
      files: files,
    );
  }
}

class EducationFile {
  String? type;
  String? id;
  String? url;

  EducationFile({
    this.type,
    this.id,
    this.url,
  });
}
