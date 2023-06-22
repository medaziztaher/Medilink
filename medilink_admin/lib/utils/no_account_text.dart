import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_admin/utils/size_config.dart';

import '../widgets/authentification/signup/signup_screen.dart';
import 'constatnts.dart';


class NoAccountText extends StatelessWidget {
  const NoAccountText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "knoacount".tr,
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => const SignUpScreen());
          },
          child: Text(
            "ksingup".tr,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(16),
              color: kPrimaryColor,
            ),
          ),
        )
      ],
    );
  }
}
