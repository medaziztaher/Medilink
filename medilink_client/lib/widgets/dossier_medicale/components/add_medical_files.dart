import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/widgets/allergys/add_allergy/add_allergy_screen.dart';
import 'package:medilink_client/widgets/analyse/add_analyse/add_analyse_screen.dart';
import 'package:medilink_client/widgets/diseases/add_disease/add_disease_screen.dart';
import 'package:medilink_client/widgets/prescriptions/add_presc/add_presc_screen.dart';
import 'package:medilink_client/widgets/radiographie/add_radio/add_radio_screen.dart';
import 'package:medilink_client/widgets/surgerys/add_surgerie/add_surgerie_screen.dart';

import '../../../models/user.dart';
import 'dossiermedicale_menu.dart';

class AddMedicalFiles extends StatelessWidget {
  const AddMedicalFiles({super.key, required this.user, required this.userId});
  final User user;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: userId == user.id
            ? Text("Add Medical Files")
            : Text("Add Medical Files to ${user.name}"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            if (userId == user.id) ...[
              ProfileMenu(
                text: "Add Allergies",
                icon: "assets/icons/allergie.svg",
                press: () => Get.to(() => AddAllergyScreen()),
              ),
              ProfileMenu(
                text: "Add Diseases",
                icon: "assets/icons/disease.svg",
                press: () => Get.to(() => AddDiseaseScreen()),
              ),
              ProfileMenu(
                text: "Add Radiographies",
                icon: "assets/icons/radigraphie.svg",
                press: () => Get.to(() => AddRadioScreen(user: user)),
              ),
              ProfileMenu(
                text: "Add Analyses",
                icon: "assets/icons/analyses.svg",
                press: () => Get.to(() => AddAnalyseScreen(user: user)),
              ),
            ],
            ProfileMenu(
              text: "Add Prescrptions",
              icon: "assets/icons/ordonance.svg",
              press: () => Get.to(() => AddPrescrptionScreen(
                    user: user,
                  )),
            ),
            ProfileMenu(
              text: "Add Surgeries",
              icon: "assets/icons/surgerie.svg",
              press: () => Get.to(() => AddSurgerirScreen(user: user)),
            ),
          ],
        ),
      ),
    );
  }
}
