import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/widgets/emergency_contact/emergency_contact_controller.dart';

import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../utils/size_config.dart';

class EmergencyContactForm extends StatelessWidget {
  const EmergencyContactForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmergencyContactController>(
        init: EmergencyContactController(),
        builder: (controller) {
          return Form(
              key: controller.formKeyEmCo,
              child: Column(children: [
                Column(
                  children: [
                    buildnameFormField(controller),
                    SizedBox(height: getProportionateScreenHeight(15)),
                    buildrealtionFormField(controller),
                    SizedBox(height: getProportionateScreenHeight(15)),
                    buildPhoneNumberFormField(controller),
                    SizedBox(height: getProportionateScreenHeight(15)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(() {
                          if (controller.isLoading.value == false) {
                            return GestureDetector(
                              onTap: () {
                                controller.addEmergencyContact();
                              },
                              child: const Text(
                                "add another emergency contact",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenWidth(15)),
                FormError(errors: controller.errors),
                SizedBox(height: getProportionateScreenWidth(40)),
                Obx(() {
                  if (controller.isLoading.value == false) {
                    return DefaultButton(
                      text: "kbutton1".tr,
                      press: () async {
                        controller.next();
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
              ]));
        });
  }
}

TextFormField buildPhoneNumberFormField(EmergencyContactController controller) {
  return TextFormField(
    keyboardType: TextInputType.phone,
    onSaved: (newValue) => controller.phoneNumberController.text = newValue!,
    onChanged: (value) => controller.onChangedphonenumber(value),
    validator: (value) => controller.validatephoneNumber(value),
    controller: controller.phoneNumberController,
    decoration: InputDecoration(
      labelText: "kphonenumber".tr,
      hintText: "kphonenumberhint".tr,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: Icon(Icons.phone_android),
    ),
  );
}

TextFormField buildnameFormField(EmergencyContactController controller) {
  return TextFormField(
    onSaved: (newValue) => controller.nameController.text = newValue!,
    onChanged: (value) => controller.onChangedname(value),
    validator: (value) => controller.validateName(value),
    controller: controller.nameController,
    decoration: InputDecoration(
      labelText: "Name".tr,
      hintText: "Please enter emergency contact name ".tr,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}

TextFormField buildrealtionFormField(EmergencyContactController controller) {
  return TextFormField(
    onSaved: (newValue) => controller.relationshipController.text = newValue!,
    onChanged: (value) => controller.onChangedrelation(value),
    validator: (value) => controller.validateRelation(value),
    controller: controller.relationshipController,
    decoration: InputDecoration(
      labelText: "Relationship".tr,
      hintText: "Please enter relationship ".tr,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}
