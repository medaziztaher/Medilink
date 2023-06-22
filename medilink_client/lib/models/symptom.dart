

class Symptom {
  String? id;
  String? nom;
  DateTime? date;

  Symptom({
    this.id,
    this.nom,
    this.date,
  });

  factory Symptom.fromJson(Map<String, dynamic> json) {
    return Symptom(
      id: json['_id'] as String?,
      nom: json['nom'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
}
