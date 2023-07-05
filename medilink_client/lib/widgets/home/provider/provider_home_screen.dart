import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/api/user.dart';
import 'package:medilink_client/models/appointment.dart';
import 'package:medilink_client/widgets/user/user_screen.dart';

import '../../../components/appointment_card.dart';
import '../../../models/user.dart';
import '../../../settings/path.dart';
import '../../../settings/realtime.dart';
import '../../../utils/size_config.dart';
import '../../notifications/notification_screen.dart';
import '../../search/search_screen.dart';

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _ProviderHomeScreenState createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  bool isLoading = false;
  List<User> users = [];
  List<User> patients = [];
  List<Appointment> appointments = [];
  final socket = SocketClient.instance.socket!;

  Future<void> getPendingPatients() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await networkHandler.get("$providerPath/pending-patients");
      print(response['status']);
      var status = response['status'];
      if (status == true) {
        final data = response['data'] as List<dynamic>;
        final newUsers =
            data.map((item) => User.fromJson(item)).toList(growable: false);
        users = newUsers;
      } else {
        var message = response['message'];
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

  Future<void> getAppointments() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await networkHandler.get("$appointmentPath/appointments");
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        final appointment = data
            .map((item) => Appointment.fromJson(item))
            .toList(growable: false);
        setState(() {
          appointments = appointment;
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getPatients() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await networkHandler.get("$providerPath/patients");
      print(response['status']);
      var status = response['status'];
      if (status == true) {
        final data = response['data'] as List<dynamic>;
        final patient =
            data.map((item) => User.fromJson(item)).toList(growable: false);
        patients = patient;
      } else {
        var message = response['message'];
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

  Future<void> _initializeUser() async {
    getPendingPatients();
    getAppointments();
    getPatients();
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
                      Text('Welcome, ${widget.user.firstname}',
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
                          'Nice to see you',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
            SizedBox(height: getProportionateScreenHeight(30)),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text('Pending Patients',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w700, letterSpacing: 1)),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : users.isEmpty
                    ? Center(child: Text('No pending patients'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return GestureDetector(
                            onTap: () =>
                                Get.to(() => UserScreen(userId: user.id!)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    CachedNetworkImageProvider(user.picture!),
                              ),
                              title: Text(user.name!),
                            ),
                          );
                        },
                      ),
            SizedBox(height: getProportionateScreenHeight(30)),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text('Upcoming Appointments',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w700, letterSpacing: 1)),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : appointments.isEmpty
                    ? Center(child: Text('No upcoming appointments'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];
                          return AppointmentCard(appointment: appointment);
                        },
                      ),
            SizedBox(height: getProportionateScreenHeight(30)),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text('Patients',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w700, letterSpacing: 1)),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : patients.isEmpty
                    ? Center(child: Text('No patients'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          final patient = patients[index];
                          return GestureDetector(
                            onTap: () =>
                                Get.to(() => UserScreen(userId: patient.id!)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    patient.picture!),
                              ),
                              title: Text(
                                patient.name!,
                              ),
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
