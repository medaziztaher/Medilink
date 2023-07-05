import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_admin/widgets/home/metrics/metrics_screen.dart';
import 'package:medilink_admin/widgets/home/pending_providers/pending_providers.dart';
import 'package:medilink_admin/widgets/home/users/users.dart';

import 'specialty/speciality_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Users(),
            SizedBox(
              height: 50,
            ),
            PendingProviders(),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () => Get.to(() => AddSpeciality()),
              child: Text("Check Speciality"),
            ),
            ElevatedButton(
              onPressed: () => Get.to(() => AddMetrics()),
              child: Text("Check Metrics"),
            ),
          ],
        ),
      )),
    );
  }
}
