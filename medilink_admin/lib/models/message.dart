
class Message {
   String? id;
   String? conversationID;
   String? sender;
   String? receiver;
  String? content;
  DateTime? createdAt;

  Message({
    this.id,
    this.conversationID,
    this.sender,
    this.receiver,
    this.content,
    this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id']  as String?,
      conversationID: json['conversationID']  as String?,
      sender: json['sender']  as String?,
      receiver: json['receiver'] as String?,
      content: json['content'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
