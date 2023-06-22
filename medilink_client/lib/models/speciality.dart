

class Speciality {
  String? id;
  String? nom;
  DateTime? date;

  Speciality({
    this.id,
    this.nom,
    this.date,
  });

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(
      id: json['_id'] as String?,
      nom: json['nom'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
}
