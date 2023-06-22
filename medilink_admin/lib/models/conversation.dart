
class Conversation {
  String? id;
  List<String>? members;
  String? lastMessage;
  DateTime? createdAt;
  DateTime? updatedAt;

  Conversation({
    this.id,
    this.members,
    this.lastMessage,
    this.createdAt,
    this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['_id'] as String?,
      members: (json['members'] as List<dynamic>?)?.map((item) => item.toString()).toList(),
      lastMessage: json['lastMessage'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
