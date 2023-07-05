import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/default_button.dart';
import '../../../../components/form_error.dart';
import '../../../../models/speciality.dart';
import '../../../../models/user.dart';
import '../../../../utils/constatnts.dart';
import '../../../../utils/size_config.dart';
import '../../profile_controller.dart';
import '../profile_pic.dart';

class DoctorProfil extends StatelessWidget {
  const DoctorProfil({super.key, required this.user});
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
                            buildspecializationFormField(controller),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            buildAppointmentPriceFormField(controller),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            builddescriptionFormField(controller),
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

  Row buildAppointmentPriceFormField(EditProfileController controller) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => controller.appointmentPrice.text = newValue!,
            controller: controller.appointmentPrice,
            decoration: InputDecoration(
              labelText: "Appointment Price",
              hintText: "Enter your appointment price",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
        ),
        SizedBox(width: getProportionateScreenWidth(5)),
        Expanded(
          child: Text("TND"),
        ),
      ],
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

  TextFormField builddescriptionFormField(EditProfileController controller) {
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
  EditProfileController controller,
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
