import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/widgets/allergys/user_alergys/user_alergys.dart';
import 'package:medilink_client/widgets/diseases/user_diseases/user_disease.dart';
import 'package:medilink_client/widgets/home/doctor/doctor_screen.dart';
import 'package:medilink_client/widgets/user/componnets/doctor/doctor_screen.dart';
import '../../../models/metric.dart';
import '../../../models/user.dart';
import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';
import '../../../utils/constatnts.dart';
import '../../allergys/allergy.dart';
import '../../diseases/diseases_screen.dart';
import '../../healthMetrics/components/all_user_metrics.dart';
import '../../healthMetrics/health_metric_screen.dart';
import '../../labresult/components/user_lab_results/user_lab_results.dart';
import '../../prescriptions/prescriptions_screen.dart';
import '../../prescriptions/user_prescriptions/user_prescriptions.dart';
import '../../radiographie/radiographie_screen.dart';
import '../../radiographie/user_radiographie/user_radiographie.dart';
import '../../surgerys/surgerys_screen.dart';
import '../../surgerys/user_surgerys/user_surgerys.dart';
import '../../user/user_screen.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  bool isLoading = false;
  NetworkHandler networkHandler = NetworkHandler();

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Welcome ${widget.user.firstname}",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: widget.user.picture != null
                        ? CachedNetworkImageProvider(widget.user.picture!)
                        : const AssetImage(kProfile) as ImageProvider,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Add new metric value ",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
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
            ElevatedButton(
                onPressed: () => Get.to(() => UserMetrics(
                      user: widget.user,
                    )),
                child: Text("Metrics")),
            ElevatedButton(
                onPressed: () => Get.to(() => UserLabs(
                      user: widget.user,
                    )),
                child: Text("Labs")),
            ElevatedButton(
                onPressed: () => Get.to(() => UserAllergeys(
                      user: widget.user,
                    )),
                child: Text("Allergys")),
            ElevatedButton(
                onPressed: () => Get.to(() => UserDiseases(
                      user: widget.user,
                    )),
                child: Text("Disease")),
            ElevatedButton(
                onPressed: () => Get.to(() => UserRadios(
                      user: widget.user,
                    )),
                child: Text("Radios")),
            ElevatedButton(
                onPressed: () => Get.to(() => RadioghraphieScreen(
                      userId: widget.user.id!,
                    )),
                child: Text("Add radio")),
            ElevatedButton(
                onPressed: () => Get.to(() => DiseasesScreen(
                      userId: widget.user.id!,
                    )),
                child: Text("Add disease")),
            ElevatedButton(
                onPressed: () => Get.to(() => AllergysScreen(
                      userId: widget.user.id!,
                    )),
                child: Text("Add Allergys")),
            ElevatedButton(
                onPressed: () => Get.to(() => Prescriptions(
                      user: widget.user,
                    )),
                child: Text("Add Prescription")),
            ElevatedButton(
                onPressed: () => Get.to(() => UserPrescriptions(
                      user: widget.user,
                    )),
                child: Text("Prescriptions")),
            ElevatedButton(
                onPressed: () => Get.to(() => UserSurgerys(
                      user: widget.user,
                    )),
                child: Text("Surgerys")),
            ElevatedButton(
                onPressed: () => Get.to(() => SurgeryScreen(
                      userId: widget.user.id!,
                    )),
                child: Text("Prescriptions")),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "User Doctors",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
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
                              Text(
                                user.speciality ?? "",
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.star, color: Colors.amber),
                                  Text(
                                    "4.9",
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
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
