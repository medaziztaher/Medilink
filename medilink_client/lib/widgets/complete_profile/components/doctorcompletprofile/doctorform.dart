import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/models/speciality.dart';

import '../../../../components/default_button.dart';
import '../../../../components/form_error.dart';
import '../../../../utils/constatnts.dart';
import '../../../../utils/size_config.dart';
import '../../complete_profile_controller.dart';
import '../profile_img.dart';

class DoctorForm extends StatelessWidget {
  const DoctorForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Text("complete".tr, style: headingStyle),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                ProfilePic(),
                GetBuilder<CompleteProfileController>(
                  init: CompleteProfileController(),
                  builder: (controller) {
                    return Form(
                      key: controller.formKeyCompleteProfile,
                      child: Column(
                        children: [
                          buildGenderFormField(controller),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          buildAddressFormField(controller),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          buildPhoneNumberFormField(controller),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          buildspecializationFormField(controller),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          buildVerificationFormField(controller),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          builddescriptionFormField(controller),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          FormError(errors: controller.errors),
                          SizedBox(height: getProportionateScreenHeight(40)),
                          /*GestureDetector(
                            onTap: () {
                              Get.to(MoreDetails());
                            },
                            child: Text(
                              "more details",
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(20),
                                color: kPrimaryColor,
                              ),
                            ),
                          ),*/
                          DefaultButton(
                            text: "Continue",
                            press: () {
                              controller.completeProfile();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Text(
                  "conditions".tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
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

  Row buildGenderFormField(CompleteProfileController controller) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<String>(
            title: Text('kmale'.tr),
            value: 'Male',
            groupValue: controller.gender,
            onChanged: (value) => controller.onChangedGender(value),
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            title: Text('kfemale'.tr),
            value: 'Female',
            groupValue: controller.gender,
            onChanged: (value) => controller.onChangedGender(value),
          ),
        ),
      ],
    );
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

  TextFormField buildVerificationFormField(
      CompleteProfileController controller) {
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
/*
  TextFormField buildspecializationFormField(
      CompleteProfileController controller) {
    return TextFormField(
      onSaved: (newValue) =>
          controller.specializationController.text = newValue!,
      onChanged: (value) => controller.onChangedspecialization(value),
      validator: (value) => controller.validatespecialization(value),
      controller: controller.specializationController,
      decoration: InputDecoration(
        labelText: "kspecialization".tr,
        hintText: "Enter your speciality",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.medical_services_rounded),
      ),
    );
  }*/

  TextFormField builddescriptionFormField(
      CompleteProfileController controller) {
    return TextFormField(
      onSaved: (newValue) => controller.descriptionController.text = newValue!,
      onChanged: (value) => controller.onChangeddescription(value),
      validator: (value) => controller.validatedescription(value),
      controller: controller.descriptionController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: "kAbout".tr,
        hintText: "kAbouthint".tr,
        helperText: "khint".tr,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}

DropdownButtonFormField<String?> buildspecializationFormField(
  CompleteProfileController controller,
) {
  final List<Speciality>? specialities = controller.specialites;

  assert(specialities?.toSet().length == specialities?.length);

  Speciality? defaultValue = specialities?.first;

  if (specialities != null && !specialities.contains(defaultValue)) {
    defaultValue = null;
  }

  return DropdownButtonFormField<String?>(
    value: defaultValue?.nom,
    onChanged: (value) => controller.onChangeSpecialite(value),
    items: [
      DropdownMenuItem<String?>(
        value: null,
        child: Text('None'),
      ),
      if (specialities != null)
        ...specialities.map(
          (speciality) => DropdownMenuItem<String?>(
            value: speciality.nom,
            child: Text(speciality.nom ?? ''),
          ),
        ),
    ],
    decoration: InputDecoration(
      labelText: "Specialization",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}
