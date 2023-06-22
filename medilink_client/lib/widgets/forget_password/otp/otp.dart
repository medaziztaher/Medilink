import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

import '../../../components/default_button.dart';
import '../../../utils/constatnts.dart';
import '../../../utils/size_config.dart';


class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                Text(
                  "kOtpTitle".tr,
                  style: headingStyle,
                ),
                Text(
                  "kOtpsubTitle".tr,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                Text("tOtpMessage".tr),
                buildTimer(),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                OtpTextField(
                  numberOfFields: 6,
                  fillColor: Colors.black.withOpacity(0.1),
                  filled: true,
                  onSubmit: (code) {
                    print('OTP is $code');
                  },
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                DefaultButton(
                  text: "kbutton1".tr,
                  press: () {},
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.07),
                GestureDetector(
                  onTap: () {
                    
                  },
                  child: const Text(
                    "Resend OTP Code",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}

Row buildTimer() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("This code will expired in "),
      TweenAnimationBuilder(
        tween: Tween(begin: 60.0, end: 0.0),
        duration: const Duration(seconds: 60),
        builder: (_, dynamic value, child) => Text(
          "00:${value.toInt()}",
          style: const TextStyle(color: kPrimaryColor),
        ),
      ),
    ],
  );
}
