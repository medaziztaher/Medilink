import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:medilink_client/utils/size_config.dart';

import '../api/user.dart';
import '../models/user.dart';
import '../utils/global.dart';
import '../widgets/user/user_screen.dart';

class UserCard extends StatefulWidget {
  const UserCard({required this.user});
  final User user;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool isLoading = false;
  String? userRole;
  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    userRole = globalRole;
    if (userRole == null) {
      try {
        userRole = await queryUserRole();
      } catch (e) {
        print('Error retrieving user role: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    userRole = userRole;
    print("userRole :$userRole");
    print("user Type : ${widget.user.type}");
    print("user Role : ${widget.user.role}");
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: getProportionateScreenWidth(200),
                child: Image(
                  image: CachedNetworkImageProvider(widget.user.picture ?? ''),
                  fit: BoxFit.fill,
                ),
              ),
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.user.type == 'Doctor'
                            ? "Dr ${widget.user.name}"
                            : "${widget.user.name}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      widget.user.role == 'HealthcareProvider'
                          ? widget.user.type == 'Doctor'
                              ? Text(
                                  "${widget.user.speciality}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              : Text(
                                  "${widget.user.type}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                          : const Spacer(),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const <Widget>[
                          /*Icon(
                            Icons.star_border,
                            color: Colors.yellow,
                            size: 16,
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Text('4.5'),
                          Spacer(
                            flex: 1,
                          ),
                          Text('Reviews'),
                          Spacer(
                            flex: 1,
                          ),
                          Text('(20)'),*/
                          Spacer(
                            flex: 7,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Get.to(() => UserScreen(userId: widget.user.id!));
        },
      ),
    );
  }
}
