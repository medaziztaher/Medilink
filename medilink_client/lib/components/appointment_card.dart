import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/models/appointment.dart';
import 'package:medilink_client/settings/path.dart';
import 'package:medilink_client/utils/constatnts.dart';

import '../api/user.dart';
import '../models/user.dart';
import '../utils/global.dart';

class AppointmentCard extends StatefulWidget {
  const AppointmentCard({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  final Appointment appointment;

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  bool isLoading = false;
  User user = User();
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
    getUser();
  }

  Future<void> getUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response;
      if (userRole == 'Patient') {
        response = await networkHandler
            .get("$userData/${widget.appointment.provider}");
        if (response['status'] == true) {
          setState(() {
            user = User.fromJson(response['data']);
          });
        } else {
          throw Exception("Something went wrong");
        }
      } else {
        response =
            await networkHandler.get("$userData/${widget.appointment.patient}");
        if (response['status'] == true) {
          setState(() {
            user = User.fromJson(response['data']);
          });
        } else {
          throw Exception("Something went wrong");
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

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  ListTile(
                    title: userRole == 'Patient' && user.type == 'Doctor'
                        ? Text(
                            "Dr. ${user.name}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : userRole == 'Patient' && user.type != 'Doctor'
                            ? Text("${user.name}")
                            : Text("${user.firstname}"),
                    subtitle: userRole == 'Patient' && user.type == 'Doctor'
                        ? Text("${user.speciality}")
                        : userRole == 'Patient' && user.type != 'Doctor'
                            ? Text("${user.type}")
                            : Text("${user.lastname}"),
                    trailing: CircleAvatar(
                      radius: 25,
                      backgroundImage: user.picture != null
                          ? CachedNetworkImageProvider(user.picture!)
                          : const AssetImage(kProfile) as ImageProvider,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      // color: Colors.black,
                      thickness: 1,
                      height: 20,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "${widget.appointment.date}",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_filled,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "${widget.appointment.time}",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: widget.appointment.status == 'Cancelled'
                                  ? Colors.red
                                  : Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "${widget.appointment.status}",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  if (widget.appointment.status == 'Scheduled') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () async {
                            try {
                              var response = await networkHandler.get(
                                  "$appointmentPath/${widget.appointment.id}/cancelled");
                              if (response['status'] == true) {
                                final message = response['message'];
                                Get.snackbar("Appointment Deleted", message);
                              } else {
                                final message = response['error'];
                                Get.snackbar(
                                    "Error Deleting Appointment", message);
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Container(
                            width: 150,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Color(0xFFF4F6FA),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: 150,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Reschedule",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 10),
                ],
              ),
            )));
  }
}
