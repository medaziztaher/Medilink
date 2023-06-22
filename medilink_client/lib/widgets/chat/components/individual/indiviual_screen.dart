import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:medilink_client/api/user.dart';
import 'package:medilink_client/models/message.dart';
import 'package:medilink_client/settings/path.dart';
import 'package:medilink_client/utils/constatnts.dart';
import 'package:medilink_client/utils/global.dart';
import '../../../../models/user.dart';
import '../../../../settings/realtime.dart';
import '../../../../settings/realtimelogic.dart';

class IndividualScreen extends StatefulWidget {
  final String userId;
  IndividualScreen({required this.userId});

  @override
  _IndividualScreenState createState() => _IndividualScreenState();
}

class _IndividualScreenState extends State<IndividualScreen> {
  bool isLoading = false;
  List<Message> messages = [];
  final socket = SocketClient.instance.socket!;
  final SocketMethods _socket = SocketMethods();
  TextEditingController _textEditingController = TextEditingController();
  String? receiverId;
  String? senderId;
  User? receiver;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> getreceiverData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await networkHandler.get("$userData/${widget.userId}");
      if (response['status'] == true) {
        setState(() {
          receiver = User.fromJson(response['data']);
        });
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }

  Future<void> _initializeUser() async {
    receiverId = widget.userId;
    senderId = globalUserId;
    if (senderId == null) {
      senderId = await queryUserID();
    }
    await getreceiverData();
    await fetchMessages();
    _setupSocketListeners();
  }

  Future<void> fetchMessages() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await networkHandler
          .get("$messagesPath/${widget.userId}/messagesUser");

      print("fetched Data: $response");
      if (response['status'] == true) {
        print("data: ${response['data']}");
        final data = response['data'] as List<dynamic>;
        setState(() {
          messages = data.map((json) => Message.fromJson(json)).toList();
        });
      } else if (response['status'] == false) {
        return;
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _setupSocketListeners() {
    socket.on('getMessage', (data) {
      if (mounted) {
        setState(() {
          print(data);
          final messageData = data['data'];
          final newMessage = Message.fromJson(messageData);
          messages.add(newMessage);
        });
      }
    });
  }

  void sendMessage(String message) async {
    setState(() {
      messages.add(Message(
          content: message, senderId: senderId, receiverId: receiverId));
    });

    await _socket.sendMessage(senderId!, receiverId!, message);

    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: receiver?.picture != null
                  ? CachedNetworkImageProvider(receiver!.picture!)
                  : const AssetImage(kProfile) as ImageProvider,
            ),
            SizedBox(width: 15),
            Center(child: Text(receiver?.name ?? "")),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final reversedIndex = messages.length - 1 - index;
                final message = messages[reversedIndex];
                final isSenderMessage = message.senderId == senderId;

                return ListTile(
                  title: Align(
                    alignment: isSenderMessage
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSenderMessage ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        message.content ?? '',
                        style: TextStyle(
                          color: isSenderMessage ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Type your message',
                    ),
                    onSubmitted: (value) {
                      sendMessage(value);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = _textEditingController.text;
                    sendMessage(message);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
