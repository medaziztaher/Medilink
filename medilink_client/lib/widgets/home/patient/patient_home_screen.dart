import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/utils/size_config.dart';

import '../../../models/metric.dart';
import '../../../models/user.dart';
import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';

import '../../../settings/realtime.dart';
import '../../healthMetrics/health_metric_screen.dart';

import '../../notifications/notification_screen.dart';
import '../../search/search_screen.dart';

import '../../user/user_screen.dart';
import 'components/appointments.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  bool isLoading = false;
  NetworkHandler networkHandler = NetworkHandler();
  final socket = SocketClient.instance.socket!;

  Future<List<Metric>> getAllMetric() async {
    try {
      final response = await networkHandler.get(metricsPath);

      final data = response['data'] as List<dynamic>;
      final newMetrics =
          data.map((item) => Metric.fromJson(item)).toList(growable: false);
      return newMetrics;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final response = await networkHandler.get(careProviderspath);
      if (response['status'] == true) {
        List<dynamic> data = response['data'];
        List<User> newUsers = data.map((item) => User.fromJson(item)).toList();
        return newUsers;
      } else {
        throw Exception('Failed to fetch healthcare providers');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  void _setupSocketListeners() {
    socket.on('followRequestError', (data) {});
    socket.on('followRequest', (data) {
      if (mounted) {
        _initializeUser();
      }
    });
    socket.on('followRequestReceived', (data) {
      if (mounted) {
        _initializeUser();
      }
    });
    socket.on('followApprovedReceived', (data) {
      if (mounted) {
        _initializeUser();
      }
    });
    socket.on('followApproved', (data) {
      if (mounted) {
        _initializeUser();
      }
    });
    socket.on('requestCanceled', (data) {
      if (mounted) {
        _initializeUser();
      }
    });
    socket.on('followCanceled', (data) {
      if (mounted) {
        _initializeUser();
      }
    });
    socket.on('unfollowRequest', (data) {
      if (mounted) {
        _initializeUser();
      }
    });
    socket.on('unfollowSuccessPatient', (data) {
      if (mounted) {
        _initializeUser();
      }
    });
    socket.on('unfollowSuccessReceived', (data) {
      if (mounted) {
        _initializeUser();
      }
    });
    socket.on('unfollowSuccess', (data) {
      if (mounted) {
        _initializeUser();
      }
    });
    socket.on('rjectedRequest', (data) {
      if (mounted) {
        _initializeUser();
      }
    });
    socket.on('rejectRequest', (data) {
      if (mounted) {
        _initializeUser();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    getAllMetric();
    getAllUsers();
    _setupSocketListeners();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("Welcome, ${widget.user.firstname}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1)),
                      Padding(
                        padding: EdgeInsets.only(
                            left: getProportionateScreenWidth(20)),
                        child: Text(
                          "How are you feeling today?",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: ()=>Get.to(() => NotificationScreen(user: widget.user)),
                        icon: const Icon(Icons.notifications_none),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.to(() => SearchScreen());
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Appointments(),
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text("Add new metric value ",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w700, letterSpacing: 1)),
            ),
            FutureBuilder<List<Metric>>(
              future: getAllMetric(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final metrics = snapshot.data!;
                  return SizedBox(
                    height: 70,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: metrics.length,
                      itemBuilder: (context, index) {
                        final metric = metrics[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F6FA),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () => Get.to(() => MetricScreen(
                                    metric: metric.nom!,
                                  )),
                              child: Text(
                                metric.nom!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text("User Doctors",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w700, letterSpacing: 1)),
            ),
            FutureBuilder<List<User>>(
              future: getAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final users = snapshot.data!;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: users.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return InkWell(
                        onTap: () {
                          Get.to(UserScreen(userId: user.id!));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundImage:
                                    CachedNetworkImageProvider(user.picture!),
                              ),
                              Text(
                                user.name!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                              user.type == 'Doctor'
                                  ? Text(
                                      user.speciality ?? "",
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    )
                                  : Text(user.type ?? "",
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      )),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
