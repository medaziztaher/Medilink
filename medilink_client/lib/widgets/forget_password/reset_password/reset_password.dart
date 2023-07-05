import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/widgets/forget_password/reset_password/reset_pass_controller.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../utils/size_config.dart';

class ResetPassScreen extends StatelessWidget {
  const ResetPassScreen({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                Text(
                  "Enter new password".tr,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                Text("tOtpMessage".tr),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                GetBuilder<ResetPassController>(
                    init: ResetPassController(email: email),
                    builder: (controller) {
                      return Form(
                          key: controller.formKeyResetPass,
                          child: Column(children: [
                            buildPasswordFormField(controller),
                            SizedBox(height: getProportionateScreenHeight(20)),
                            buildConfirmPassword(controller),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            FormError(errors: controller.errors),
                            SizedBox(height: SizeConfig.screenHeight * 0.13),
                            Obx(() {
                              if (controller.isLoading.value == false) {
                                return DefaultButton(
                                  text: "kbutton1".tr,
                                  press: () async {
                                    controller.submitForm();
                                  },
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                          ]));
                    }),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

TextFormField buildPasswordFormField(ResetPassController controller) {
  return TextFormField(
    obscureText: true,
    onSaved: (newValue) => controller.passwordController.text = newValue!,
    onChanged: (value) => controller.onChangedPassword(value),
    validator: (value) => controller.validatePassword(value),
    controller: controller.passwordController,
    decoration: InputDecoration(
      labelText: "kpassword".tr,
      hintText: "kpasswordhint".tr,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: Icon(Icons.lock),
    ),
  );
}

TextFormField buildConfirmPassword(ResetPassController controller) {
  return TextFormField(
    obscureText: true,
    onSaved: (newValue) => controller.confirmpassword,
    onChanged: (value) => controller.onChangedConfirmPassword(value),
    validator: (value) => controller.validateconfirmPassword(value),
    decoration: InputDecoration(
      labelText: "kconfirmpassword".tr,
      hintText: "kconfirmPassNullError".tr,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: Icon(Icons.lock),
    ),
  );
}
