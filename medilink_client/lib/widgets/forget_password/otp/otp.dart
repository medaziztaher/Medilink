import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../utils/constatnts.dart';
import '../../../utils/size_config.dart';
import 'otp_controller.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key, required this.email});
  final String email;

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
                  style: TextStyle(
                      fontSize: getProportionateScreenWidth(40),
                      color: Colors.black),
                ),
                Text(
                  "kOtpsubTitle".tr,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                Text("tOtpMessage".tr),
                buildTimer(),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                GetBuilder<OTPController>(
                    init: OTPController(email: email),
                    builder: (controller) {
                      return Form(
                        key: controller.formKeyOTP,
                        child: Column(
                          children: [
                            TextField(
                              controller: controller.otpController,
                              keyboardType: TextInputType.text,
                              maxLength: 6,
                              onChanged: (String code) {
                                if (code.length == 6) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Verification Code"),
                                        content: Text('Code entered is $code'),
                                        actions: [
                                          TextButton(
                                            child: Text('Submit'),
                                            onPressed: () {
                                              controller.submit();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Get.back();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: 'Enter OTP',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF512DA8),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF512DA8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: SizeConfig.screenHeight * 0.06),
                            FormError(errors: controller.errors),
                            SizedBox(height: SizeConfig.screenHeight * 0.07),
                            Obx(() {
                              if (controller.isLoading.value == false) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.resendOTP();
                                  },
                                  child: const Text(
                                    "Resend OTP Code",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                          ],
                        ),
                      );
                    }),
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
