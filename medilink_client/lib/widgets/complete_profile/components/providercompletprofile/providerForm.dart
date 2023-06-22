import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/default_button.dart';
import '../../../../components/form_error.dart';
import '../../../../utils/constatnts.dart';
import '../../../../utils/size_config.dart';
import '../../complete_profile_controller.dart';
import '../building_images.dart';
import '../profile_img.dart';

class ProviderForm extends StatelessWidget {
  const ProviderForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
            width: double.infinity,
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: SingleChildScrollView(
                    child: Column(children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  Text("kcomplet".tr, style: headingStyle),
                  BuildingImages(),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  GetBuilder<CompleteProfileController>(
                      init: CompleteProfileController(),
                      builder: (controller) {
                        return Form(
                            key: controller.formKeyCompleteProfile,
                            child: Column(children: [
                              SizedBox(
                                  height: getProportionateScreenHeight(15)),
                              buildAddressFormField(controller),
                              SizedBox(
                                  height: getProportionateScreenHeight(15)),
                              buildPhoneNumberFormField(controller),
                              SizedBox(
                                  height: getProportionateScreenHeight(15)),
                              buildVerificationFormField(controller),
                              SizedBox(
                                  height: getProportionateScreenHeight(15)),
                              FormError(errors: controller.errors),
                              SizedBox(
                                  height: getProportionateScreenHeight(40)),
                              DefaultButton(
                                text: "kContinue".tr,
                                press: () => controller.completeProfile(),
                              )
                            ]));
                      }),
                  Text(
                    "kconditions".tr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ])))));
  }

  TextFormField buildAddressFormField(CompleteProfileController controller) {
    return TextFormField(
      onSaved: (newValue) => controller.adressController.text = newValue!,
      controller: controller.adressController,
      decoration: InputDecoration(
        labelText: "kaddress".tr,
        hintText: "kaddresshint".tr,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.location_pin),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField(
      CompleteProfileController controller) {
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
}

TextFormField buildVerificationFormField(CompleteProfileController controller) {
  return TextFormField(
    onSaved: (newValue) => controller.veriffiactionControler.text = newValue!,
    controller: controller.veriffiactionControler,
    decoration: InputDecoration(
      labelText: "Medicale license verification".tr,
      hintText: "Please enter your medicale license code ".tr,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: Icon(Icons.key_outlined),
    ),
  );
}
