import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../utils/size_config.dart';
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
              buildRoleFormField(controller),
              SizedBox(height: getProportionateScreenHeight(20)),
              buildEmailFormField(controller),
              SizedBox(height: getProportionateScreenHeight(15)),
              buildPasswordFormField(controller),
              SizedBox(height: getProportionateScreenHeight(15)),
              buildConfirmPassword(controller),
              SizedBox(height: getProportionateScreenHeight(15)),
              Visibility(
                visible: controller.role == 'Patient' ? true : false,
                child: Column(
                  children: [
                    buildFirstNameFormField(controller),
                    SizedBox(height: getProportionateScreenHeight(15)),
                    buildLastNameFormField(controller),
                  ],
                ),
              ),
              Visibility(
                visible: controller.role == 'HealthcareProvider' ? true : false,
                child: Column(
                  children: [
                    buildTypeFormField(controller),
                    SizedBox(height: getProportionateScreenHeight(15)),
                    Visibility(
                        visible: controller.type == 'Doctor' ? true : false,
                        child: Column(children: [
                          buildFirstNameFormField(controller),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          buildLastNameFormField(controller),
                        ])),
                    Visibility(
                        visible: controller.type != 'Doctor' ? true : false,
                        child: Column(children: [
                          buildNameFormField(controller),
                        ]))
                  ],
                ),
              ),
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
    decoration: InputDecoration(
      labelText: "kpassword".tr,
      hintText: "kpasswordhint".tr,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: Icon(Icons.lock),
    ),
  );
}

TextFormField buildNameFormField(SignupController controller) {
  return TextFormField(
    onSaved: (newValue) => controller.nameController.text = newValue!,
    onChanged: (value) => controller.onChangedname(value),
    validator: (value) => controller.validateName(value),
    controller: controller.nameController,
    decoration: InputDecoration(
      labelText: "kname".tr,
      hintText: "knamehint".tr,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: Icon(Icons.person),
    ),
  );
}

TextFormField buildFirstNameFormField(SignupController controller) {
  return TextFormField(
    onSaved: (newValue) => controller.firstnameController.text = newValue!,
    onChanged: (value) => controller.onChangedfirstname(value),
    validator: (value) => controller.validateFirstName(value),
    controller: controller.firstnameController,
    decoration: InputDecoration(
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

DropdownButtonFormField<String> buildTypeFormField(
    SignupController controller) {
  final List<String> typeValues = [
    'Doctor',
    'Center d\'imagerie Medicale',
    'Laboratoire',
  ];

  assert(typeValues.toSet().length == typeValues.length);

  String? defaultValue = typeValues.first;

  if (!typeValues.contains(defaultValue)) {
    defaultValue = null;
  }

  return DropdownButtonFormField<String>(
    value: defaultValue,
    onChanged: (value) => controller.onChangedType(value),
    validator: (value) => controller.validateType(value),
    items: typeValues
        .map((type) => DropdownMenuItem(
              value: type,
              child: Text(type),
            ))
        .toList(),
    decoration: InputDecoration(
      labelText: "ktype".tr,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}

Row buildRoleFormField(SignupController controller) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: RadioListTile<String>(
          title: Text(
            'kpatient'.tr,
            style: TextStyle(fontSize: getProportionateScreenWidth(11)),
          ),
          value: 'Patient',
          groupValue: controller.role,
          onChanged: (value) => controller.onChangedRole(value),
        ),
      ),
      Expanded(
        flex: 3,
        child: RadioListTile<String>(
          title: Text(
            'kprovider'.tr,
            style: TextStyle(fontSize: getProportionateScreenWidth(11)),
          ),
          value: 'HealthcareProvider',
          groupValue: controller.role,
          onChanged: (value) => controller.onChangedRole(value),
        ),
      ),
    ],
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
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: Icon(Icons.lock),
    ),
  );
}
