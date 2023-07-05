import 'package:flutter/material.dart';
import 'package:medilink_client/models/allergy.dart';

import '../../../../utils/size_config.dart';
import 'edit_allergy_form.dart';

class Body extends StatelessWidget {
  const Body({super.key, required this.allergie});
  final Allergy allergie;

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
                EditAllergyForm(allergie: allergie),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
