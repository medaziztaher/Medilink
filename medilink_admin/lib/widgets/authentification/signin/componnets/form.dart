import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constatnts.dart';
import '../../../../utils/default_button.dart';
import '../../../../utils/form_error.dart';
import '../../../../utils/size_config.dart';
import '../signin_controller.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInController>(
      init: SignInController(),
      builder: (controller) {
        return Form(
          key: controller.formKeySignIn,
          child: Column(
            children: [
              buildEmailFormField(controller),
              SizedBox(height: getProportionateScreenHeight(20)),
              buildPasswordFormField(controller),
              SizedBox(height: getProportionateScreenHeight(20)),
              Row(
                children: [
                  Checkbox(
                    value: controller.isRememberMe.value,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      controller.toggleRememberMe();
                    },
                  ),
                  Text("Remember Me"),
                  const Spacer(),
                ],
              ),
              FormError(errors: controller.errors),
              SizedBox(height: getProportionateScreenHeight(10)),
              Obx(() {
                if (controller.isLoading.value == false) {
                  return DefaultButton(
                    text: "continue",
                    press: () async {
                      controller.submitForm();
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
            ],
          ),
        );
      },
    );
  }
}

TextFormField buildEmailFormField(SignInController controller) {
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
      labelText: "Email",
      hintText: "Entre votre email",
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: const Icon(Icons.email),
    ),
  );
}

TextFormField buildPasswordFormField(SignInController controller) {
  return TextFormField(
    obscureText: !controller.passToggle.value,
    onSaved: (newValue) => controller.passwordController.text = newValue!,
    onChanged: (value) {
      controller.onChangedPassword(value);
    },
    validator: (value) {
      return controller.validatePassword(value);
    },
    controller: controller.passwordController,
    decoration: InputDecoration(
      labelText: "Password".tr,
      hintText: "enter votre password".tr,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: const Icon(Icons.vpn_key),
    ),
  );
}
