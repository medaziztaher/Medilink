import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../models/user.dart';
import '../../allergys/user_allergy/user_allergy_screen.dart';
import '../../analyse/user_analyse/user_analyse_screen.dart';
import '../../diseases/user_disease/user_disease_screen.dart';
import '../../emergency_contact/get_emergegncy_contact/get_emergency_contact_screen.dart';
import '../../healthMetrics/components/all_user_metrics.dart';
import '../../prescriptions/user_presc/user_presc_screen.dart';
import '../../radiographie/user_radio/user_radio_screen.dart';
import '../../surgerys/user_surgerie/user_surgerie_screen.dart';
import 'add_medical_files.dart';
import 'dossiermedicale_menu.dart';

class Body extends StatelessWidget {
  const Body({super.key, required this.user, required this.userId});
  final User user;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfileMenu(
            text: "Metrics",
            icon: "assets/icons/metric.svg",
            press: () => Get.to(() => UserMetrics(user: user)),
          ),
          ProfileMenu(
            text: "Allergies",
            icon: "assets/icons/allergie.svg",
            press: () => Get.to(() => UserAllergeyScreen(user: user)),
          ),
          ProfileMenu(
            text: "Diseases",
            icon: "assets/icons/disease.svg",
            press: () => Get.to(() => UserDiseaseScreen(
                  user: user,
                )),
          ),
          ProfileMenu(
            text: "Prescrptions",
            icon: "assets/icons/ordonance.svg",
            press: () => Get.to(() => UserPrescScreen(
                  user: user,
                )),
          ),
          ProfileMenu(
            text: "Radiographies",
            icon: "assets/icons/radigraphie.svg",
            press: () => Get.to(() => UserRadioScreen(user: user)),
          ),
          ProfileMenu(
            text: "Analyses",
            icon: "assets/icons/analyses.svg",
            press: () => Get.to(() => UserAnalyseScreen(user: user)),
          ),
          ProfileMenu(
            text: "Surgeries",
            icon: "assets/icons/surgerie.svg",
            press: () => Get.to(() => UserSurgeriesScreen(user: user)),
          ),
          ProfileMenu(
            text: "Emergency Contacts",
            icon: "assets/icons/téléchargement.svg",
            press: () => Get.to(() => UserEmergencyContact(user: user)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: Color(0xFFF5F6F9),
              ),
              onPressed: () =>
                  Get.to(() => AddMedicalFiles(user: user, userId: userId)),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/7354347.svg",
                    width: 40,
                  ),
                  SizedBox(width: 20),
                  Expanded(child: Text("Add Medical Files")),
                  Icon(Icons.add_circle_outline),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
