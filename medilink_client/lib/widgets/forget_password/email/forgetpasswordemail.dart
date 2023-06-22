import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/default_button.dart';
import '../../../utils/constatnts.dart';
import '../../../utils/size_config.dart';
import '../otp/otp.dart';


class ForgetpasswordMailscreen extends StatelessWidget {
  const ForgetpasswordMailscreen({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Center(
                  child: Image.asset(
                kForgetPassImage,
                height: SizeConfig.screenHeight * 0.30,
              )),
              Text(
                "Forget",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(40),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.01),
              Text("data", style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Form(
                  child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text("kemail".tr),
                      hintText: "kemailhint".tr,
                      prefixIcon: Icon(Icons.mail_outline_rounded)
                    ),
                  )
                ],
              )),
              SizedBox(height: SizeConfig.screenHeight * 0.06),
              SizedBox(
                width: SizeConfig.screenWidth * 0.55,
                height: SizeConfig.screenWidth * 0.16,
                child: DefaultButton(
                  text: "kbutton1".tr,
                  press: () {
                    Get.to(()=>OTPScreen());
                  },
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
