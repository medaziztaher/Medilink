

import '../settings/path.dart';

class Feedback {
  String? id;
  String? user;
  int? rating;
  String? comment;
  DateTime? date;
  List<FeedbackFile>? files;
  String? response;

  Feedback({
    this.id,
    this.user,
    this.rating,
    this.comment,
    this.date,
    this.files,
    this.response,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    List<FeedbackFile> files = json['files'] != null
        ? (json['files'] as List<dynamic>).map((item) {
            String id = item['_id'] as String;
            String url = "$feedbacksPath/${item['url']}";
            ;
            return FeedbackFile(id: id, url: url);
          }).toList()
        : [];

    return Feedback(
      id: json['_id'] as String?,
      user: json['user'] as String?,
      rating: json['rating'] as int?,
      comment: json['comment'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      files: files,
      response:
          json['response'] as String?,
    );
  }
}

class FeedbackFile {
  String? id;
  String? url;

  FeedbackFile({
    this.id,
    this.url,
  });
}
