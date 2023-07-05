import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:medilink_client/utils/size_config.dart';
import 'package:medilink_client/widgets/home/doctor/doctor_screen.dart';
import 'package:medilink_client/widgets/home/homeController.dart';
import 'package:medilink_client/widgets/home/patient/patient_home_screen.dart';
import 'package:medilink_client/widgets/home/provider/provider_home_screen.dart';

import '../../components/bottom_navbar.dart';
import '../../components/drawer.dart';
import '../../utils/enum.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if (snapshot.data == ConnectivityResult.none) {
            return Scaffold(
              body: Center(
                child: AlertDialog(
                  title: Text('No Internet Connection'),
                  content: Text('Please check your internet connection.'),
                ),
              ),
            );
          } else {
            return GetBuilder<HomeData>(
                init: HomeData(),
                builder: (controller) {
                  return Scaffold(
                      drawer: Obx(() {
                        if (controller.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return CustomDrawer(user: controller.user);
                      }),
                      body: Obx(() {
                        if (controller.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (controller.user.role == 'Patient') {
                          return PatientHomeScreen(user: controller.user);
                        } else if (controller.user.type == 'Doctor') {
                          return DoctorHomeScreen(user: controller.user);
                        } else {
                          return ProviderHomeScreen(user: controller.user);
                        }
                      }),
                      bottomNavigationBar: const CustomBottomNavBar(
                          selectedMenu: MenuState.home));
                });
          }
        });
  }
}
