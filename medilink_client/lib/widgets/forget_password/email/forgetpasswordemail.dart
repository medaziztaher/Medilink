import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../utils/constatnts.dart';
import '../../../utils/size_config.dart';
import '../otp/otp.dart';
import 'forgetpasswordemailcontroller.dart';

class ForgetpasswordMailscreen extends StatelessWidget {
  const ForgetpasswordMailscreen({Key? key}) : super(key: key);

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
              GetBuilder<ForgetPassEmail>(
                  init: ForgetPassEmail(),
                  builder: (controller) {
                    return Form(
                        key: controller.formKeySignIn,
                        child: Column(
                          children: [
                            buildEmailFormField(controller),
                            SizedBox(height: SizeConfig.screenHeight * 0.06),
                            FormError(errors: controller.errors),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.55,
                              height: SizeConfig.screenWidth * 0.16,
                              child: Obx(() {
                                if (controller.isLoading.value == false) {
                                  return DefaultButton(
                                    text: "kbutton1".tr,
                                    press: () async {
                                      controller.onSubmit();
                                    },
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              }),
                            ),
                          ],
                        ));
                  }),
            ],
          ),
        ),
      )),
    );
  }
}

TextFormField buildEmailFormField(ForgetPassEmail controller) {
  return TextFormField(
    keyboardType: TextInputType.emailAddress,
    onSaved: (newValue) => controller.emailController.text = newValue!,
    onChanged: (value) {
      controller.onChangedEmail(value);
    },
    validator: (value) {
      return controller.validateEmail(value);
    },
    controller: controller.emailController,
    decoration: InputDecoration(
      labelText: "kemail".tr,
      hintText: "kemailhint".tr,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: const Icon(Icons.email),
    ),
  );
}
