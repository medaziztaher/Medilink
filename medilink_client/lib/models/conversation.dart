import '../settings/path.dart';
import '../utils/constatnts.dart';

class Conversation {
  String? id;
  List<String>? members;
  String? picture;
  String? lastMessage;
  DateTime? createdAt;
  DateTime? updatedAt;

  Conversation({
    this.id,
    this.members,
    this.createdAt,
    this.updatedAt,
    this.lastMessage,
    this.picture,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    String? userPic =
        json['user'] != null ? json['user']['picture'] as String? : null;
    userPic = userPic != null ? "$profilePicPath/$userPic" : kProfile;
    List<String>? members;
    if (json['members'] != null) {
      members = [];
      json['members'].forEach((appId) {
        members!.add(appId as String);
      });
    }
    return Conversation(
      id: json['conversation']['_id'] as String?,
      members: members,
      createdAt: DateTime.parse(json['conversation']['createdAt'] as String),
      updatedAt: DateTime.parse(json['conversation']['updatedAt'] as String),
      picture: userPic,
      lastMessage: json['conversation']['lastMessage'] as String?,
    );
  }
}
