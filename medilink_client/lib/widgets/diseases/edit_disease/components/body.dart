import 'package:flutter/material.dart';
import 'package:medilink_client/models/diseases.dart';

import '../../../../utils/size_config.dart';
import 'form.dart';

class Body extends StatelessWidget {
  const Body({super.key, required this.disease});
  final Disease disease;

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
                EditDiseaseForm(disease: disease),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
