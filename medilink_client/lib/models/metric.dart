

class Metric {
  String? id;
  String? nom;
  DateTime? date;

  Metric({
    this.id,
    this.nom,
    this.date,
  });

  factory Metric.fromJson(Map<String, dynamic> json) {
    return Metric(
      id: json['_id']as String?,
      nom: json['nom'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
}
