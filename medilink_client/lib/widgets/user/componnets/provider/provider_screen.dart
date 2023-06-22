import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/user.dart';
import '../../../../models/user.dart';
import '../../../../settings/networkhandler.dart';
import '../../../../settings/path.dart';
import '../../../../settings/realtime.dart';
import '../../../../settings/realtimelogic.dart';
import '../../../../utils/constatnts.dart';
import '../../../../utils/global.dart';
import '../../../chat/components/individual/indiviual_screen.dart';

class ProviderScreen extends StatefulWidget {
  const ProviderScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  NetworkHandler networkHandler = NetworkHandler();
  String? userId;
  String? message;
  final SocketMethods _socket = SocketMethods();
  final socket = SocketClient.instance.socket!;
  String? logedinuserole;

  @override
  void initState() {
    super.initState();
    setRole();
    _checkUser();
    _setupSocketListeners();
  }

  void setRole() async {
    final String? globrole = globalRole;
    String? role;
    if (globrole != null) {
      role = globrole;
    } else {
      role = await queryUserRole();
    }
    setState(() {
      logedinuserole = role;
    });
    print(logedinuserole);
  }

  void _setupSocketListeners() {
    socket.on('followRequestError', (data) {
      if (mounted) {
        Get.snackbar("followRequestError",
            "You already have a healthcare provider with the same specialty.");
      }
    });
    socket.on('followRequest', (data) {
      if (mounted) {
        Get.snackbar("followRequest", data);
        _checkUser();
      }
    });
    socket.on('followRequestReceived', (data) {
      if (mounted) {
        Get.snackbar("followRequestReceived", data);
        _checkUser();
      }
    });
    socket.on('followApprovedReceived', (data) {
      if (mounted) {
        Get.snackbar("followApprovedReceived", data);
        _checkUser();
      }
    });
    socket.on('followApproved', (data) {
      if (mounted) {
        Get.snackbar("followApproved", data);
        _checkUser();
      }
    });
    socket.on('requestCanceled', (data) {
      if (mounted) {
        Get.snackbar("requestCanceled", data);
        _checkUser();
      }
    });
    socket.on('followCanceled', (data) {
      if (mounted) {
        Get.snackbar("followCanceled", data);
        _checkUser();
      }
    });
    socket.on('unfollowRequest', (data) {
      if (mounted) {
        Get.snackbar("unFollowRequest", data);
        _checkUser();
      }
    });
    socket.on('unfollowSuccessPatient', (data) {
      if (mounted) {
        Get.snackbar("unFollowSuccess", data);
        _checkUser();
      }
    });
    socket.on('unfollowSuccessReceived', (data) {
      if (mounted) {
        Get.snackbar("unFollowSuccessReceived", data);
        _checkUser();
      }
    });
    socket.on('unfollowSuccess', (data) {
      if (mounted) {
        Get.snackbar("unFollowSuccess", data);
        _checkUser();
      }
    });
    socket.on('rjectedRequest', (data) {
      if (mounted) {
        Get.snackbar("rejectedRequest", data);
        _checkUser();
      }
    });
    socket.on('rejectRequest', (data) {
      if (mounted) {
        Get.snackbar("rejectRequest", data);
        _checkUser();
      }
    });
  }

  Future<void> _checkUser() async {
    final response =
        await networkHandler.get("$userCheckpath/${widget.user.id}");
    if (response['status'] == true) {
      setState(() {
        message = response['message'];
      });
    } else {
      setState(() {
        message = response['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
           padding: EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                Padding(
               padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Container(
                      height: 250,
                      child: widget.user.buildingpictures != null &&
                              widget.user.buildingpictures!.isNotEmpty
                          ? SizedBox(
                              height: 300,
                              width: double.infinity,
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  height: 400,
                                  aspectRatio: 16 / 9,
                                  viewportFraction: 0.8,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                                  scrollDirection: Axis.horizontal,
                                ),
                                items: widget.user.buildingpictures!
                                    .map((buildingPicture) {
                                  return Builder(builder: (BuildContext context) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin:
                                          const EdgeInsets.symmetric(horizontal: 1.0),
                                      child: CachedNetworkImage(
                                        imageUrl: buildingPicture.url,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                          child: Text('Error loading image.'),
                                        ),
                                        placeholder: (context, url) => Container(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    );
                                  });
                                }).toList(),
                              ),
                            )
                          : const Center(child: Text("No user data found.")),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "${widget.user.name}",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                    logedinuserole == "Patient"
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonSection(
                                userId: widget.user.id!,
                                message: message,
                                onFollow: () async {
                                  String? senderId = await queryUserID();
                                  print('Follow clicked. SenderId: $senderId');
                                  _socket.followUser(senderId!, widget.user.id!);
                                },
                                onUnfollow: () async {
                                  String? senderId = await queryUserID();
                                  print('Unfollow clicked. SenderId: $senderId');
                                  _socket.unfollowUser(senderId!, widget.user.id!);
                                },
                                onCancelRequest: () async {
                                  String? senderId = await queryUserID();
                                  print('Cancel request clicked. SenderId: $senderId');
                                  _socket.cancelRequest(senderId!, widget.user.id!);
                                },
                              ),
                          ],
                        )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 151, 198, 226),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 151, 198, 226),
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  onTap: () => Get.to(() =>
                                      IndividualScreen(userId: widget.user.id!)),
                                  child: const Icon(
                                    CupertinoIcons.chat_bubble_text_fill,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
                  ]),
          ),
        const SizedBox(height: 20),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 1.5,
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 20,
                left: 15,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    widget.user.description ?? "",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        "Reviews",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Icon(Icons.star, color: Colors.amber),
                      const Text(
                        "4.9",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "(124)",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Location",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0EEFA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      widget.user.address ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      "address line of the medical center",
                    ),
                  ),
                  SizedBox(height: 20),
                  Spacer(),
                  Center(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.only(right: 15),
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          /*boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],*/
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Book Appointment",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonSection extends StatelessWidget {
  const ButtonSection({
    required this.message,
    required this.onFollow,
    required this.onUnfollow,
    required this.onCancelRequest,
    required this.userId,
  });

  final String? message;
  final VoidCallback onFollow;
  final VoidCallback onUnfollow;
  final VoidCallback onCancelRequest;
  final String userId;

  @override
  Widget build(BuildContext context) {
    if (message == 'Ok') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 151, 198, 226)),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmation'),
                      content: const Text(
                          'Are you sure you want\n to unfollow this doctor'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onUnfollow();
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Unfollow'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 151, 198, 226),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.call,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 151, 198, 226),
              shape: BoxShape.circle,
            ),
            child: GestureDetector(
              onTap: () => Get.to(() => IndividualScreen(userId: userId)),
              child: const Icon(
                CupertinoIcons.chat_bubble_text_fill,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ],
      );
    } else if (message == 'Pending') {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirmation'),
                content: const Text(
                    'Are you sure you want\n to cancel the request?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onCancelRequest();
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                  ),
                ],
              );
            },
          );
        },
        child: const Text(
          'requested',
          style: TextStyle(color: Colors.red),
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: onFollow,
        child: const Text('Follow'),
      );
    }
  }
}
