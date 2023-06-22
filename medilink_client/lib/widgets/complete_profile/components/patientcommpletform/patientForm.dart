import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../components/default_button.dart';
import '../../../../components/form_error.dart';
import '../../../../utils/constatnts.dart';
import '../../../../utils/size_config.dart';
import '../../complete_profile_controller.dart';
import '../profile_img.dart';


class PatienForm extends StatelessWidget {
  const PatienForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Text("kcomplet".tr, style: headingStyle),
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
                              SizedBox(
                                  height: getProportionateScreenHeight(15)),
                              buildAddressFormField(controller),
                              SizedBox(
                                  height: getProportionateScreenHeight(15)),
                              buildPhoneNumberFormField(controller),
                              SizedBox(
                                  height: getProportionateScreenHeight(15)),
                              buildbirthdateField(controller),
                              SizedBox(
                                  height: getProportionateScreenHeight(15)),
                              buildTypeFormField(controller),
                              SizedBox(
                                  height: getProportionateScreenHeight(10)),
                              Visibility(
                                  visible: controller.etatcivil != 'Single',
                                  child: buildnemberdenfant(controller)),
                              FormError(errors: controller.errors),
                              SizedBox(
                                  height: getProportionateScreenHeight(40)),
                              DefaultButton(
                                text: "Continue",
                                press: () {
                                  controller.completeProfile();
                                },
                              ),
                            ],
                          ));
                    }),
                Text(
                  "kconditions".tr,
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

  TextFormField buildbirthdateField(CompleteProfileController controller) {
    return TextFormField(
      onSaved: (newValue) => controller.dateofbirthController.text = newValue!,
      onChanged: (value) => controller.onChangedbirthdate(value),
      validator: (value) => controller.validatebirthdate(value),
      controller: controller.dateofbirthController,
      readOnly: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: Get.overlayContext!,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (picked != null) {
          final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
          controller.selectedDate.value = formattedDate;
          controller.dateofbirthController.text = formattedDate;
        }
      },
      decoration: InputDecoration(
        labelText: "kbirthdate".tr,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.calendar_month),
      ),
    );
  }

  DropdownButtonFormField<String> buildTypeFormField(
      CompleteProfileController controller) {
    final List<String> typeValues = [
      'Single',
      'Married',
      'Divorced',
      'Widowed',
    ];

    assert(typeValues.toSet().length == typeValues.length);

    String? defaultValue = typeValues.first;

    if (!typeValues.contains(defaultValue)) {
      defaultValue = null;
    }

    return DropdownButtonFormField<String>(
      value: defaultValue,
      onChanged: (value) => controller.onChangedetatcivil(value),
      items: typeValues
          .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              ))
          .toList(),
      decoration: InputDecoration(
        labelText: "Civil State",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildnemberdenfant(CompleteProfileController controller) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) =>
          controller.nembredenfantController.text = newValue!,
      controller: controller.nembredenfantController,
      decoration: InputDecoration(
        labelText: "Nembre d'enfant",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
