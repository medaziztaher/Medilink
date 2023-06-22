
class Rating {
   String? id;
   String? healthcareProvider;
   String? patient;
  double? rating;
  String? review;

  Rating({
    this.id,
    this.healthcareProvider,
    this.patient,
    this.rating,
    this.review,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['_id'] as String?,
      healthcareProvider: json['healthcareProvider']  as String?,
      patient:
          json['patient']  as String?,
      rating: json['rating']?.toDouble(),
      review: json['review'] as String?,
    );
  }
}
