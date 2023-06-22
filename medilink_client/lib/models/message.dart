class Message {
  String? id;
  String? conversationID;
  String? senderId;
  String? receiverId;
  String? content;
  DateTime? date;

  Message({
    this.id,
    this.conversationID,
    this.senderId,
    this.receiverId,
    this.content,
    this.date,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'] as String?,
      conversationID: json['conversationId'] as String?,
      senderId: json['sender'] as String?,
      receiverId: json['receiver'] as String?,
      content: json['content'] as String?,
      date: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
    );
  }
}
