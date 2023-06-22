
class Review {
   String? id;
   String? healthcareProvider;
  double? rating;
  String? review;

  Review({
    this.id,
    this.healthcareProvider,
    this.rating,
    this.review,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id']  as String?,
      healthcareProvider: json['healthcareProvider']  as String?,
      rating: json['rating']?.toDouble(),
      review: json['review'] as String?,
    );
  }
}
