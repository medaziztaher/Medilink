import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/widgets/chat/components/individual/indiviual_screen.dart';

import '../../../api/user.dart';
import '../../../models/user.dart';
import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';
import '../../../utils/global.dart';

class Followers extends StatefulWidget {
  const Followers({Key? key}) : super(key: key);

  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  bool isLoading = false;
  NetworkHandler networkHandler = NetworkHandler();
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    getusers();
  }

  Future<void> getusers() async {
    setState(() {
      isLoading = true;
    });
    final String? role = globalRole;
    String? userRole;
    if (role != null) {
      userRole = role;
    } else {
      userRole = await queryUserRole();
    }
    print("userRole $userRole");
    if (userRole == "Patient") {
      try {
        final response = await networkHandler.get(careProviderspath);

        if (response['status'] == true) {
          final data = response['data'] as List<dynamic>;

          final newUsers = data.map((item) => User.fromJson(item)).toList();
          setState(() {
            users = newUsers;
          });
        } else {
          throw Exception('Failed to fetch healthcare providers');
        }
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      try {
        final response = await networkHandler.get(patientsPath);
        print(response);
        if (response['status'] == true) {
        
          final data = response['data'] as List<dynamic>;
          final newUsers = data.map((item) => User.fromJson(item)).toList();
          setState(() {
            users = newUsers;
          });
        } else {
          throw Exception('Failed to fetch healthcare providers');
        }
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: EdgeInsets.only(left: 10),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => IndividualScreen(userId: user.id!));
                },
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35.0,
                        backgroundImage: CachedNetworkImageProvider(
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
          );
  }
}
