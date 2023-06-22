import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/widgets/home/home_screen.dart';

import '../../../components/default_button.dart';
import '../../../utils/constatnts.dart';
import '../../../utils/size_config.dart';
import '../../search/search_screen.dart';

class Body extends StatelessWidget {
  const Body({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Center(
            child: Image.asset(
          kSuccess,
          height: SizeConfig.screenHeight * 0.25,
        )),
        SizedBox(height: SizeConfig.screenHeight * 0.06),
        Text(
          "Login Success",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(20),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: SizeConfig.screenWidth * 0.4,
          child: DefaultButton(
            text: "Back to home",
            press: () {
              Get.to(() => HomeScreen());
            },
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
