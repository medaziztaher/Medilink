import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/utils/size_config.dart';
import 'package:medilink_client/widgets/dossier_medicale/dossier_screen.dart';

import '../../../../api/user.dart';
import '../../../../components/default_button.dart';
import '../../../../models/user.dart';
import '../../../../settings/networkhandler.dart';
import '../../../../settings/path.dart';
import '../../../../settings/realtime.dart';
import '../../../../settings/realtimelogic.dart';
import '../../../../utils/constatnts.dart';
import '../../../../utils/global.dart';
import '../../../chat/components/individual/indiviual_screen.dart';
import '../../../healthMetrics/components/all_user_metrics.dart';
import '../../../home/home_screen.dart';
import '../../../labresult/labresult_screen.dart';
import '../../../radiographie/radiographie_screen.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  bool isFollowed = false;
  bool isUnfollowed = false;
  NetworkHandler networkHandler = NetworkHandler();
  String? message;
  final SocketMethods _socket = SocketMethods();
  final socket = SocketClient.instance.socket!;
  late Future<String?> type;

  @override
  void initState() {
    super.initState();
    type = getContectedUsertype();
    _checkUser();
    _setupSocketListeners();
  }

  Future<void> _checkUser() async {
    final response =
        await networkHandler.get("$userCheckpath/${widget.user.id}");
    setState(() {
      message = response['message'];
    });
    if (response['message'] == 'Ok') {
      setState(() {
        isFollowed = true;
      });
    } else {
      setState(() {
        isFollowed = false;
      });
    }
    if (response['message'] == "notfollowed") {
      setState(() {
        isUnfollowed = true;
      });
    } else {
      setState(() {
        isUnfollowed = false;
      });
    }
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

  Future<String?> getContectedUsertype() async {
    try {
      if (globalType != null) {
        return globalType!;
      } else {
        return await queryHealthcareProvdierType();
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return isUnfollowed == false
        ? Container(
            color: Colors.blue,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: widget.user.picture != null
                                    ? CachedNetworkImageProvider(
                                        widget.user.picture!)
                                    : AssetImage(kProfile) as ImageProvider,
                              ),
                              SizedBox(height: 15),
                              Text(
                                "${widget.user.name}",
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                widget.user.email!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 15),
                              ButtonSection(
                                userId: widget.user.id!,
                                message: message,
                                onApprove: () async {
                                  String? senderId = await queryUserID();
                                  print('Follow clicked. SenderId: $senderId');
                                  _socket.approveRequest(
                                      senderId!, widget.user.id!);
                                },
                                onDecline: () async {
                                  String? senderId = await queryUserID();
                                  print(
                                      'Unfollow clicked. SenderId: $senderId');
                                  _socket.rejectRequest(
                                      senderId!, widget.user.id!);
                                  Get.back();
                                },
                                onUnfollow: () async {
                                  String? senderId = await queryUserID();
                                  print(
                                      'Unfollow clicked. SenderId: $senderId');
                                  _socket.unfollowUser(
                                      senderId!, widget.user.id!);
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenWidth(20)),
                  isFollowed
                      ? Container(
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
                              children: [
                                ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Address:'),
                                      SizedBox(
                                          width:
                                              getProportionateScreenWidth(5)),
                                      Text(widget.user.address!),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: getProportionateScreenWidth(10)),
                                ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Phone Number:'),
                                      SizedBox(
                                          width:
                                              getProportionateScreenWidth(5)),
                                      Text(widget.user.phoneNumber!),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: getProportionateScreenWidth(10)),
                                ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Gender:'),
                                      SizedBox(
                                          width:
                                              getProportionateScreenWidth(5)),
                                      Text(widget.user.gender!),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: getProportionateScreenWidth(10)),
                                ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Birthdate:'),
                                      SizedBox(
                                          width:
                                              getProportionateScreenWidth(5)),
                                      Text(widget.user.dateofbirth!),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: getProportionateScreenWidth(10)),
                                if (type == 'Laboratoire')
                                  ListTile(
                                    title: GestureDetector(
                                      onTap: () => Get.to(() => LabresultScreen(
                                          userId: widget.user.id!)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Add Lab Results'),
                                          Icon(Icons.arrow_forward_ios),
                                        ],
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                    height: getProportionateScreenWidth(10)),
                                if (type == 'Center d\'imagerie Medicale')
                                  ListTile(
                                    title: GestureDetector(
                                      onTap: () => Get.to(() =>
                                          RadioghraphieScreen(
                                              userId: widget.user.id!)),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Add Radiographie'),
                                            Icon(Icons.arrow_forward_ios),
                                          ]),
                                    ),
                                  ),
                                SizedBox(
                                    height: getProportionateScreenWidth(10)),
                                
                                  ListTile(
                                      title: GestureDetector(
                                    onTap: () => Get.to(() => UserMetrics(
                                          user: widget.user,
                                        )),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Patient Metrics'),
                                        Icon(Icons.arrow_forward_ios)
                                      ],
                                    ),
                                  )),
                                  SizedBox(
                                      height: getProportionateScreenWidth(10)),
                                  ListTile(
                                      title: GestureDetector(
                                    onTap: () => Get.to(() =>
                                        DossierMedicale(user: widget.user)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Dossier Medicale'),
                                        Icon(Icons.folder)
                                      ],
                                    ),
                                  ))
                                ]
                              
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          )
        : SafeArea(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.1),
                Center(
                    child: Image.asset(
                  kAccessdenied,
                  height: SizeConfig.screenHeight * 0.25,
                )),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                const Spacer(),
                SizedBox(
                  width: SizeConfig.screenWidth * 0.4,
                  child: DefaultButton(
                    text: "Back to home",
                    press: () {
                      Get.to(() => HomeScreen());
                    },
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
  }
}

class ButtonSection extends StatelessWidget {
  const ButtonSection({
    required this.message,
    required this.onApprove,
    required this.onDecline,
    required this.onUnfollow,
    required this.userId,
  });

  final String? message;
  final VoidCallback onApprove;
  final VoidCallback onDecline;
  final VoidCallback onUnfollow;
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
                          'Are you sure you want\n to unfollow this patient'),
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
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 151, 198, 226),
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
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 151, 198, 226),
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
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: onApprove,
              child: const Text('Approve'),
            ),
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: onDecline,
              child: const Text('Decline'),
            ),
          ),
        ],
      );
    }
  }
}
