import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/no_account_text.dart';
import '../../../components/social_card.dart';
import '../../../utils/size_config.dart';
import 'signin_forn.dart';

class Body extends StatelessWidget {
  const Body({super.key});

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
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Text(
                  "kwelcome".tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "kcontinue".tr,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                const SignIn(),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                SizedBox(height: getProportionateScreenHeight(40)),
                const NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
