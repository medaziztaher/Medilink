
class Availability {
   String? id;
   String? provider;
  String? day;
  String? start;
  String? end;

  Availability({
    this.id,
    this.provider,
    this.day,
    this.start,
    this.end,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      id: json['_id'] as String?,
      provider: json['provider'] as String?,
      day: json['day'] as String?,
      start: json['start'] as String?,
      end: json['end'] as String?,
    );
  }
}
