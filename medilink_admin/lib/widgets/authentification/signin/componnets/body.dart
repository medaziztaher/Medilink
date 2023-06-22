import 'package:flutter/material.dart';

import '../../../../utils/no_account_text.dart';
import '../../../../utils/size_config.dart';
import 'form.dart';


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
                  "Welcome",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "continue",
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
