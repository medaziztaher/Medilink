import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/utils/size_config.dart';

import '../../../api/user.dart';
import '../../../models/user.dart';
import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';
import '../../../settings/realtime.dart';
import '../../../utils/global.dart';

import 'individual/indiviual_screen.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isLoading = false;
  List<dynamic> conversations = [];
  NetworkHandler networkHandler = NetworkHandler();
  List<User> users = [];
  String? userRole;
  final socket = SocketClient.instance.socket!;

  Future<void> getConversations() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await networkHandler.get(conversationsPath);
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        conversations = data;
      } else {
        final message = response['message'];
        Get.snackbar("Error", message);
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
    socket.on('arrivalNotifications', (data) {
      if (mounted) {
        _initializeUser();
      }
    });
  }

  Future<void> getFollowers() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (userRole == "Patient") {
        final response = await networkHandler.get(careProviderspath);
        print(response);
        if (response['status'] == true) {
          final data = response['data'] as List<dynamic>;
          final newUsers =
              data.map((item) => User.fromJson(item)).toList(growable: false);
          users = newUsers;
        } else {
          var message = response['message'];
          Get.snackbar("Error", message);
        }
      } else {
        final response = await networkHandler.get(patientsPath);
        if (response['status'] == true) {
          final data = response['data'] as List<dynamic>;
          final newUsers =
              data.map((item) => User.fromJson(item)).toList(growable: false);
          users = newUsers;
        } else {
          var message = response['message'];
          Get.snackbar("Error", message);
        }
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _initializeUser() async {
    userRole = globalRole;
    if (userRole == null) {
      userRole = await queryUserRole();
    }
    getFollowers();
    getConversations();
    _setupSocketListeners();
  }

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Contacts : ",
                      style:
                          TextStyle(fontSize: getProportionateScreenWidth(20)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: getProportionateScreenWidth(15),
              ),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : users.isEmpty
                      ? Center(
                          child: userRole == 'Patient'
                              ? Text('No Healthcare Providers ')
                              : Text("No patients"))
                      : Container(
                          width: double.infinity,
                          height: getProportionateScreenWidth(120),
                          child: ListView.builder(
                            padding: EdgeInsets.only(left: 10),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                      () => IndividualScreen(userId: user.id!));
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 35.0,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          user.picture!,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(user.name!),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Last Conversations : ",
                  style: TextStyle(fontSize: getProportionateScreenWidth(20)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: getProportionateScreenWidth(15),
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : users.isEmpty
                  ? Center(child: Text('No conversations'))
                  : Expanded(
                      child: ListView.builder(
                      itemCount: conversations.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> conversation =
                            conversations[index] as Map<String, dynamic>;
                        final String profilePic =
                            conversation['picture'] as String;
                        final String pictureUrl = "$profilePicPath/$profilePic";
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(pictureUrl),
                          ),
                          title:
                              Text('${conversation['name'] ?? 'No messages'}'),
                          subtitle: Text(
                              '${conversation['lastMessage'] ?? 'No messages'}'),
                          onTap: () {
                            print(conversation['id']);
                            Get.off(() =>
                                IndividualScreen(userId: conversation['id']));
                          },
                        );
                      },
                    ))
        ],
      ),
    );
  }
}
