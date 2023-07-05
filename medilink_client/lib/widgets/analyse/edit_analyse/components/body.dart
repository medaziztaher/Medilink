import 'package:flutter/material.dart';
import 'package:medilink_client/models/labresult.dart';

import '../../../../utils/size_config.dart';
import 'form.dart';

class Body extends StatelessWidget {
  const Body({super.key, required this.analyse, required this.userId});
  final Labresult analyse;
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
                EditAnalyseForm(analyse: analyse,userId:userId),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
