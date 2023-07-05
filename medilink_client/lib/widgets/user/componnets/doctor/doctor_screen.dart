import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:medilink_client/utils/global.dart';
import 'package:medilink_client/widgets/chat/components/individual/indiviual_screen.dart';

import '../../../../api/user.dart';
import '../../../../models/user.dart';
import '../../../../settings/networkhandler.dart';
import '../../../../settings/path.dart';
import '../../../../settings/realtime.dart';
import '../../../../settings/realtimelogic.dart';
import '../../../../utils/constatnts.dart';
import '../../../book_appointment/book_appointment.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({required this.user});
  final User user;

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  NetworkHandler networkHandler = NetworkHandler();
  String? userId;
  String? message;
  final SocketMethods _socket = SocketMethods();
  final socket = SocketClient.instance.socket!;
  String? logedinuserole;
  String? selectedDay;
  String? selectedTime;
  String? reason;

  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  List<String> timeSlots = [
    '07:00 am',
    '08:00 am',
    '09:00 am',
    '10:00 am',
    '11:00 am',
    '12:00 pm',
    '01:00 pm',
    '02:00 pm',
    '03:00 pm',
    '04:00 pm',
    '05:00 pm',
    '06:00 pm',
  ];

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    logedinuserole = globalRole;
    if (logedinuserole == null) {
      logedinuserole = await queryUserRole();
    }
    _checkUser();
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    socket.on('followRequestError', (data) {});
    socket.on('followRequest', (data) {
      if (mounted) {
        _checkUser();
      }
    });
    socket.on('followRequestReceived', (data) {
      if (mounted) {
        _checkUser();
      }
    });
    socket.on('followApprovedReceived', (data) {
      if (mounted) {
        _checkUser();
      }
    });
    socket.on('followApproved', (data) {
      if (mounted) {
        _checkUser();
      }
    });
    socket.on('requestCanceled', (data) {
      if (mounted) {
        _checkUser();
      }
    });
    socket.on('followCanceled', (data) {
      if (mounted) {
        _checkUser();
      }
    });
    socket.on('unfollowRequest', (data) {
      if (mounted) {
        _checkUser();
      }
    });
    socket.on('unfollowSuccessPatient', (data) {
      if (mounted) {
        _checkUser();
      }
    });
    socket.on('unfollowSuccessReceived', (data) {
      if (mounted) {
        _checkUser();
      }
    });
    socket.on('unfollowSuccess', (data) {
      if (mounted) {
        _checkUser();
      }
    });
    socket.on('rjectedRequest', (data) {
      if (mounted) {
        _checkUser();
      }
    });
    socket.on('rejectRequest', (data) {
      if (mounted) {
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
    return Container(
      color: Colors.blue,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Stack(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: widget.user.picture != null
                            ? CachedNetworkImageProvider(widget.user.picture!)
                            : const AssetImage(kProfile) as ImageProvider,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Dr. ${widget.user.name}",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.user.speciality ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      if (logedinuserole == "Patient") ...[
                        ButtonSection(
                          phoneNumber: widget.user.phoneNumber!,
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
                            print(
                                'Cancel request clicked. SenderId: $senderId');
                            _socket.cancelRequest(senderId!, widget.user.id!);
                          },
                        )
                      ]
                    ],
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            Container(
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
              child: SingleChildScrollView(
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
                    const SizedBox(height: 5),
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
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "see all",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                const BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 1.4,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const CircleAvatar(
                                      radius: 25,
                                      backgroundImage: AssetImage(kProfile),
                                    ),
                                    title: const Text(
                                      "Dr.Doctor Name",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: const Text("1 day ago"),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        const Text(
                                          "4.9",
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      "Many thanks to Dr. Dear .he is a great ",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
                        "adress line of the medical center",
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(15),
                      height: 130,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: logedinuserole == 'Patient'
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "consultation Price",
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text("${widget.user.appointmentprice}"),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  onTap: () {
                                    Get.to(() =>
                                        BookAppointment(provider: widget.user));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
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
                                )
                              ],
                            )
                          : Center(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
    required this.phoneNumber,
  });

  final String? message;
  final VoidCallback onFollow;
  final VoidCallback onUnfollow;
  final VoidCallback onCancelRequest;
  final String userId;
  final String phoneNumber;

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
            child: GestureDetector(
              onTap: () => FlutterPhoneDirectCaller.callNumber(phoneNumber),
              child: const Icon(
                Icons.call,
                color: Colors.white,
                size: 25,
              ),
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
