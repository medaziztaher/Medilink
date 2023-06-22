import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/api/user.dart';
import 'package:medilink_client/widgets/chat/components/individual/indiviual_screen.dart';

import '../../../settings/path.dart';

class Conversations extends StatefulWidget {
  const Conversations({Key? key}) : super(key: key);

  @override
  State<Conversations> createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {
  bool isLoading = false;
  List<dynamic> conversations = [];

  @override
  void initState() {
    super.initState();
    fetchConversations().then((data) {
      setState(() {
        conversations = data;
      });
    });
  }

  Future<List<dynamic>> fetchConversations() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await networkHandler.get(conversationsPath);
      print("Response : $response");
      return response;
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch conversations');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> conversation =
                    conversations[index] as Map<String, dynamic>;
                final String profilePic = conversation['picture'] as String;
                final String pictureUrl = "$profilePicPath/$profilePic";
                return ListTile(
                  leading: CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(pictureUrl),
                  ),
                  title: Text('${conversation['name'] ?? 'No messages'}'),
                  subtitle:
                      Text('${conversation['lastMessage'] ?? 'No messages'}'),
                  onTap: () {
                    print(conversation['id']);
                    Get.off(() => IndividualScreen(userId: conversation['id']));
                  },
                );
              },
            ),
    );
  }
}
