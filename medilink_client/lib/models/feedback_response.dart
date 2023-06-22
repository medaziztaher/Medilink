

class FeedbackResponse {
  String? id;
  String? feedback;
  String? response;

  FeedbackResponse({
    this.id,
    this.feedback,
    this.response,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      id: json['_id'] as String?,
      feedback: json['feedback'] as String?,
      response: json['response'] as String?,
    );
  }
}
