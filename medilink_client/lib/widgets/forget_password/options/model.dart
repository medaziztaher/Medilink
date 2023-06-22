import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/size_config.dart';
import '../email/forgetpasswordemail.dart';
import 'forgetpasswordbtn.dart';


class Forgetpasswordscreen {
  static Future<dynamic> buildshowModelBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        builder: (context) => Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "kForgetpasswordTitle".tr,
                    style: const TextTheme(
                      titleLarge: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 30),
                    ).titleLarge,
                  ),
                  Text("kForgetPasswordSubTitle".tr,
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 30),
                  ForgetPasswordbtn(
                    icon: Icons.mail_outline_rounded,
                    title: "kemail".tr,
                    subtitle: "kResetViaEmail".tr,
                    onTap: () {
                      Get.to(()=>ForgetpasswordMailscreen());
                    },
                  ),
                  const SizedBox(height: 20),
                  ForgetPasswordbtn(
                    icon: Icons.mobile_friendly_rounded,
                    title: "kphonenumber".tr,
                    subtitle: "kResetViaPhone".tr,
                    onTap: () {},
                  ),
                ],
              ),
            ));
  }
}
