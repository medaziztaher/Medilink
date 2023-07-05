import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../components/default_button.dart';
import '../../../../components/form_error.dart';
import '../../../../models/user.dart';
import '../../../../utils/constatnts.dart';
import '../../../../utils/size_config.dart';
import '../../profile_controller.dart';
import '../profile_pic.dart';

class PatientProfil extends StatelessWidget {
  const PatientProfil({Key? key, required this.user}) : super(key: key);
  final User user;

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
                ProfileImage(user: user),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                GetBuilder<EditProfileController>(
                    init: EditProfileController(user: user),
                    builder: (controller) {
                      return Form(
                        key: controller.formKeyEditProfile,
                        child: Column(
                          children: [
                            buildGenderFormField(controller),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            buildEmailFormField(controller),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            buildFirstNameFormField(controller),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            buildLastNameFormField(controller),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            buildPasswordFormField(controller),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            if (controller.passwordController.text != null) ...[
                              buildConfirmPassword(controller),
                              SizedBox(
                                  height: getProportionateScreenHeight(15)),
                            ],
                            buildAddressFormField(controller),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            buildPhoneNumberFormField(controller),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            buildbirthdateField(context, controller),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            buildTypeFormField(controller),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            Visibility(
                                visible: controller.etatcivil != 'Single',
                                child: buildnemberdenfant(controller)),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            FormError(errors: controller.errors),
                            SizedBox(height: getProportionateScreenHeight(40)),
                            Obx(() {
                              if (controller.isLoading.value == false) {
                                return DefaultButton(
                                  text: "kbutton1".tr,
                                  press: () async {
                                    controller.updateProfil();
                                  },
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                            SizedBox(height: getProportionateScreenHeight(20)),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField(EditProfileController controller) {
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

  Row buildGenderFormField(EditProfileController controller) {
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

  TextFormField buildAddressFormField(EditProfileController controller) {
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

  DropdownButtonFormField<String> buildTypeFormField(
      EditProfileController controller) {
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

  TextFormField buildnemberdenfant(EditProfileController controller) {
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

  TextFormField buildbirthdateField(
      BuildContext context, EditProfileController controller) {
    return TextFormField(
      controller: controller.dateofbirthController,
      readOnly: true,
      onTap: () async {
        final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );

        if (selectedDate != null) {
          final DateFormat formatter = DateFormat('yyyy-MM-dd');
          final String formattedDate = formatter.format(selectedDate);
          controller.dateofbirthController.text = formattedDate;
        }
      },
      decoration: InputDecoration(
        labelText: "kbirthdate".tr,
        hintText: "kbirthdatehint".tr,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the date';
        }
        return null;
      },
    );
  }
}

TextFormField buildEmailFormField(EditProfileController controller) {
  return TextFormField(
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

TextFormField buildPasswordFormField(EditProfileController controller) {
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

TextFormField buildFirstNameFormField(EditProfileController controller) {
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

TextFormField buildLastNameFormField(EditProfileController controller) {
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

TextFormField buildConfirmPassword(EditProfileController controller) {
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
