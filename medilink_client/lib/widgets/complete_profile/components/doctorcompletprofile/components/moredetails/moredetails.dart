import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/widgets/complete_profile/components/doctorcompletprofile/components/availibility/availibilityForm.dart';
import 'package:medilink_client/widgets/complete_profile/components/doctorcompletprofile/components/education/educationForm.dart';
import 'package:medilink_client/widgets/complete_profile/components/doctorcompletprofile/components/experience/experienceForm.dart';
import 'package:medilink_client/widgets/signin/signin_screen.dart';

import '../../../../../../components/default_button.dart';

class MoreDetails extends StatelessWidget {
  const MoreDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("More Deatails"),
          actions: [
            TextButton(
              child: Text(
                "Skip",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Get.to(() => SignInScreen());
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ExperienceForm(),
              EducationForm(),
              AvailabiltyForm(),
              DefaultButton(
                text: "Continue",
                press: () {
                  Get.to(() => SignInScreen());
                },
              ),
            ],
          ),
        ));
  }
}
