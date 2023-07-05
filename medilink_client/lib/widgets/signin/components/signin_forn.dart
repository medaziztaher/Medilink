import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../utils/constatnts.dart';
import '../../../utils/size_config.dart';
import '../../forget_password/options/model.dart';
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
                  Text("krememberme".tr),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Forgetpasswordscreen.buildshowModelBottomSheet(context);
                    },
                    child: Text(
                      "kforgetpassword".tr,
                      style:
                          const TextStyle(decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
              FormError(errors: controller.errors),
              SizedBox(height: getProportionateScreenHeight(10)),
              Obx(() {
                if (controller.isLoading.value == false) {
                  return DefaultButton(
                    text: "kbutton1".tr,
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
      labelText: "kemail".tr,
      hintText: "kemailhint".tr,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: const Icon(Icons.email),
    ),
  );
}

TextFormField buildPasswordFormField(SignInController controller) {
  bool isPasswordVisible = !controller.passToggle.value;

  return TextFormField(
    obscureText: isPasswordVisible,
    onSaved: (newValue) => controller.passwordController.text = newValue!,
    onChanged: (value) {
      controller.onChangedPassword(value);
    },
    validator: (value) {
      return controller.validatePassword(value);
    },
    controller: controller.passwordController,
    decoration: InputDecoration(
      labelText: "kpassword".tr,
      hintText: "kpasswordhint".tr,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: IconButton(
        icon: Icon(
          isPasswordVisible ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: () {
          controller.togglePasswordVisibility();
        },
      ),
    ),
  );
}
