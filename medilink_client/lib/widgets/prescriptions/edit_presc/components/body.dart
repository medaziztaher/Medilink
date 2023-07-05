import 'package:flutter/material.dart';

import '../../../../models/prescription.dart';
import '../../../../models/user.dart';
import '../../../../utils/size_config.dart';
import 'form.dart';

class Body extends StatelessWidget {
  const Body({super.key, required this.prescription, required this.userId});
  final Prescription prescription;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                EditPrescForm(prescription: prescription, userId: userId),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
