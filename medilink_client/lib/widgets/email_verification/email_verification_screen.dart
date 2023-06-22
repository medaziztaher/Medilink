import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/default_button.dart';
import '../../firebase/api/authentififcation.dart';
import '../../utils/size_config.dart';
import 'email_verification_controller.dart';


class MailVerfication extends StatelessWidget {
  const MailVerfication({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MailVerficationController());
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
              child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              Icon(Icons.mark_email_unread_outlined,
                  color: Colors.black54, size: 180),
              SizedBox(height: SizeConfig.screenHeight * 0.01),
              Text("kemailverification".tr,
                  style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: SizeConfig.screenHeight * 0.01),
              Text("kemailverificationSubtitle".tr,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center),
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              SizedBox(
                width: 200,
                child: DefaultButton(
                  text: "kbutton1".tr,
                  press: () {
                    controller.manuallyCheckEmailVerificationStatus();
                  },
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              GestureDetector(
                onTap: () {
                  controller.sendVerificationEmail();
                },
                child: Text(
                  "kresendemailLink".tr,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              TextButton(
                  onPressed: () => Auth.instance.logout(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back),
                      SizedBox(width: SizeConfig.screenHeight * 0.01),
                      Text("tbackToLogin".tr.toLowerCase())
                    ],
                  ))
            ],
          ),
        ),
      ))),
    );
  }
}
