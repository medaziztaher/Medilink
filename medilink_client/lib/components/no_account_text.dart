import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constatnts.dart';
import '../utils/size_config.dart';
import '../widgets/signup/signup_screen.dart';

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
            Get.to(SignUpScreen());
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
