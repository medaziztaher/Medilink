

class Article {
   String? id;
  String? title;
  String? content;
  String? author;
  DateTime? publishedAt;

  Article({
    this.id,
    this.title,
    this.content,
    this.author,
    this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      author: json['author'] as String?,
      publishedAt: json['publishedAt'] != null ? DateTime.parse(json['publishedAt']) : null,
    );
  }
}
