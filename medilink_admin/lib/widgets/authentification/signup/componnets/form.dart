import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/default_button.dart';
import '../../../../utils/form_error.dart';
import '../../../../utils/size_config.dart';
import '../signup_controller.dart';



class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupController>(
      init: SignupController(),
      builder: (controller) {
        return Form(
          key: controller.formKeySignUp,
          child: Column(
            children: [
              
              buildEmailFormField(controller),
              SizedBox(height: getProportionateScreenHeight(15)),
              buildPasswordFormField(controller),
              SizedBox(height: getProportionateScreenHeight(15)),
              buildConfirmPassword(controller),
              SizedBox(height: getProportionateScreenHeight(15)),
               buildFirstNameFormField(controller),
                    SizedBox(height: getProportionateScreenHeight(15)),
                    buildLastNameFormField(controller),
                    FormError(errors: controller.errors),
              SizedBox(height: getProportionateScreenHeight(30)),
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

TextFormField buildEmailFormField(SignupController controller) {
  return TextFormField(
    textDirection: TextDirection.ltr,
    keyboardType: TextInputType.emailAddress,
    onSaved: (newValue) => controller.emailController.text = newValue!,
    onChanged: (value) => controller.onChangedEmail(value),
    validator: (value) => controller.validateEmail(value),
    controller: controller.emailController,
    decoration: InputDecoration(
      labelText: "kemail".tr,
      hintText: "kemailhint".tr,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: Icon(Icons.email),
    ),
  );
}

TextFormField buildPasswordFormField(SignupController controller) {
  return TextFormField(
    obscureText: true,
    onSaved: (newValue) => controller.passwordController.text = newValue!,
    onChanged: (value) => controller.onChangedPassword(value),
    validator: (value) => controller.validatePassword(value),
    controller: controller.passwordController,
    decoration:  InputDecoration(
      labelText: "kpassword".tr,
      hintText: "kpasswordhint".tr,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: Icon(Icons.lock),
    ),
  );
}



TextFormField buildFirstNameFormField(SignupController controller) {
  return TextFormField(
    onSaved: (newValue) => controller.firstnameController.text = newValue!,
    onChanged: (value) => controller.onChangedfirstname(value),
    validator: (value) => controller.validateFirstName(value),
    controller: controller.firstnameController,
    decoration:  InputDecoration(
      labelText: "kfirstname".tr,
      hintText: "kfirstnamehint".tr,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: Icon(Icons.person),
    ),
  );
}

TextFormField buildLastNameFormField(SignupController controller) {
  return TextFormField(
    onSaved: (newValue) => controller.lastnameController.text = newValue!,
    onChanged: (value) => controller.onChangedlastname(value),
    validator: (value) => controller.validateLastName(value),
    controller: controller.lastnameController,
    decoration: InputDecoration(
      labelText: "klastname".tr,
      hintText: "klastnamehint".tr,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: Icon(Icons.person),
    ),
  );
}

TextFormField buildConfirmPassword(SignupController controller) {
  return TextFormField(
    obscureText: true,
    onSaved: (newValue) => controller.confirmpassword,
    onChanged: (value) => controller.onChangedConfirmPassword(value),
    validator: (value) => controller.validateconfirmPassword(value),
    decoration: InputDecoration(
      labelText: "kconfirmpassword".tr,
      hintText: "kconfirmPassNullError".tr,
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: Icon(Icons.lock),
    ),
  );
}


