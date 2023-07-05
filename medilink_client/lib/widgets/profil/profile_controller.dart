import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medilink_client/widgets/profil/profile_screen.dart';

import '../../api/user.dart';
import '../../models/speciality.dart';
import '../../models/user.dart';
import '../../settings/networkhandler.dart';
import '../../settings/path.dart';
import '../../utils/constatnts.dart';
import '../../utils/global.dart';

class EditProfileController extends GetxController {
  GlobalKey<FormState> formKeyEditProfile = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController adressController;
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController nameController;
  late TextEditingController phoneNumberController;
  late TextEditingController descriptionController;
  late TextEditingController dateofbirthController;
  late TextEditingController nembredenfantController;
  late TextEditingController appointmentPrice;
  Rx<String> selectedDate = ''.obs;
  late RxBool isLoading = false.obs;
  final List<String?> errors = [];
  late String gender = 'Male';
  late String etatcivil = 'Single';
  late String specialite = "";
  XFile? imageFile;
  ImagePicker picker = ImagePicker();
  List<Speciality>? specialites;
  List<XFile?> imageFiles = List<XFile?>.filled(4, null);
  NetworkHandler networkHandler = NetworkHandler();
  late String confirmpassword;
  User user;
  EditProfileController({required this.user}) {}

  @override
  void onClose() {
    adressController.dispose();
    phoneNumberController.dispose();
    descriptionController.dispose();
    dateofbirthController.dispose();
    nembredenfantController.dispose();
    appointmentPrice.dispose();
    emailController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    adressController = TextEditingController(text: user.address);
    phoneNumberController = TextEditingController(text: user.phoneNumber);
    descriptionController = TextEditingController(text: user.description);
    dateofbirthController = TextEditingController(text: user.dateofbirth);
    nembredenfantController =
        TextEditingController(text: user.nembredenfant.toString());
    emailController = TextEditingController(text: user.email);
    firstnameController = TextEditingController(text: user.firstname);
    lastnameController = TextEditingController(text: user.lastname);
    nameController = TextEditingController(text: user.name);
    passwordController = TextEditingController();
    appointmentPrice =
        TextEditingController(text: user.appointmentprice.toString());
    getAllSpeciality();
    super.onInit();
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    print(source);
    if (pickedFile != null) {
      imageFile = XFile(pickedFile.path);
      update();
    }
  }

  Future<void> getAllSpeciality() async {
    try {
      final response = await networkHandler.get(specialitePath);
      print(response);
      final data = response['data'] as List<dynamic>;
      final newSpecialities =
          data.map((item) => Speciality.fromJson(item)).toList(growable: false);
      print(newSpecialities);

      specialites = newSpecialities;
      update();
    } catch (e) {
      print(e);
    }
  }

  void selectImage(int imageIndex) async {
    try {
      final picker = ImagePicker();
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageFiles[imageIndex - 1] = pickedFile;
        update();
      }
    } catch (e) {
      print('Error selecting image: $e');
    }
  }

  void takebuildingPhoto(ImageSource source, int imageIndex) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      imageFiles[imageIndex - 1] = XFile(pickedFile.path);
      update();
    }
  }

  void deleteImage(int imageIndex) {
    imageFiles[imageIndex - 1] = null;
    update();
  }

  String? validatebirthdate(String? value) {
    if (!RegExp(r'^\d{2}[/-]\d{2}[/-]\d{4}$').hasMatch(value!)) {
      addError("kbirthdateValidation".tr);
      return '';
    } else {
      removeError("kbirthdateValidation".tr);

      try {
        List<int> dateParts;
        if (value.contains('/')) {
          dateParts = value.split('/').map(int.parse).toList();
        } else {
          dateParts = value.split('-').map(int.parse).toList();
        }

        final day = dateParts[0];
        final month = dateParts[1];
        final year = dateParts[2];

        final birthdate = DateTime(year, month, day);

        final now = DateTime.now();

        if (birthdate.isAfter(now)) {
          addError("kbirthdateValidation".tr);
          return '';
        }
      } catch (e) {
        addError("kbirthdateValidation".tr);
        return '';
      }
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      addError("kEmailNullError".tr);
      return '';
    } else if (!emailValidatorRegExp.hasMatch(value)) {
      addError("kInvalidEmailError".tr);
      return '';
    } else {
      removeError("kEmailNullError".tr);
      removeError("kInvalidEmailError".tr);
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      addError("kPassNullError".tr);
      return '';
    } else if (value.length < 8) {
      addError("kShortPassError".tr);
      return '';
    } else {
      removeError("kPassNullError".tr);
      removeError("kShortPassError".tr);
    }
    return null;
  }

  String? validateName(String? value) {
    if (value!.isEmpty) {
      addError("kNamelNullError".tr);
      return '';
    } else if (!RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      addError("kNamevalidationError".tr);
      return '';
    } else {
      removeError("kNamelNullError".tr);
      removeError("kNamevalidationError".tr);
    }
    return null;
  }

  String? validateFirstName(String? value) {
    if (value!.isEmpty) {
      addError("kFirstNamelNullError".tr);
      return '';
    } else if (!RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      addError("kNamevalidationError".tr);
      return '';
    } else {
      removeError("kFirstNamelNullError".tr);
      removeError("kNamevalidationError".tr);
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value!.isEmpty) {
      addError("kLastNamelNullError".tr);
      return '';
    } else if (!RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      addError("kNamevalidationError".tr);
      return '';
    } else {
      removeError("kLastNamelNullError".tr);
      removeError("kNamevalidationError".tr);
    }
    return null;
  }

  String? validateType(String? value) {
    if (value!.isEmpty) {
      addError("kTypeNullError".tr);
      return '';
    } else {
      removeError("kTypeNullError".tr);
    }
    return null;
  }

  String? validateconfirmPassword(String? value) {
    if (value!.isEmpty) {
      addError("kconfirmPassNullError".tr);
      return '';
    } else if (confirmpassword != passwordController.text) {
      addError("kMatchPassError".tr);
      return '';
    } else {
      removeError("kconfirmPassNullError".tr);
      removeError("kMatchPassError".tr);
    }
    return null;
  }

  String? validateRole(String? value) {
    if (value!.isEmpty) {
      addError("kRoleNullError".tr);
      return '';
    } else {
      removeError("kRoleNullError".tr);
    }
    return null;
  }

  String? onChangedEmail(String? value) {
    if (value!.isNotEmpty) {
      removeError("kEmailNullError".tr);
    } else if (emailValidatorRegExp.hasMatch(value)) {
      removeError("kInvalidEmailError".tr);
    }
    return null;
  }

  String? onChangedPassword(String? value) {
    if (value!.isNotEmpty) {
      removeError("kPassNullError".tr);
    } else if (value.length >= 8) {
      removeError("kShortPassError".tr);
    }
    return null;
  }

  String? onChangedname(String? value) {
    if (value!.isNotEmpty) {
      removeError("kNamelNullError".tr);
    } else if (RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      removeError("kNamevalidationError".tr);
    }
    return null;
  }

  String? onChangedfirstname(String? value) {
    if (value!.isNotEmpty) {
      removeError("kFirstNamelNullError".tr);
    } else if (RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      removeError("kNamevalidationError".tr);
    }
    return null;
  }

  String? onChangedlastname(String? value) {
    if (value!.isNotEmpty) {
      removeError("kLastNamelNullError".tr);
    } else if (RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      removeError("kNamevalidationError".tr);
    }
    return null;
  }

  void onChangedConfirmPassword(String? value) {
    if (value!.isNotEmpty) {
      removeError("kconfirmPassNullError".tr);
    } else if (value.isNotEmpty && confirmpassword == passwordController.text) {
      removeError("kMatchPassError".tr);
    }
    confirmpassword = value;
    update();
  }

  String? validatephoneNumber(String? value) {
    if (!RegExp(r'^\d{8}$').hasMatch(value!)) {
      addError("kPhoneNumberValidation".tr);
      return '';
    } else {
      removeError("kPhoneNumberNullError".tr);
      removeError("kPhoneNumberValidation".tr);
    }
    return null;
  }

  String? validatesInstituation(String? value) {
    if (value!.isEmpty) {
      addError("kNamelNullError".tr);
      return '';
    } else if (!RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      addError("kNamevalidationError".tr);
      return '';
    } else {
      removeError("kNamevalidationError".tr);
    }
    return null;
  }

  String? validatesDegree(String? value) {
    if (!RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value!)) {
      addError("kNamevalidationError".tr);
      return '';
    } else {
      removeError("kNamevalidationError".tr);
    }
    return null;
  }

  String? validatedescription(String? value) {
    if ((value?.split('\n').length)! > 3) {
      addError("kdescriptionvalidation".tr);
      return '';
    } else {
      removeError("kdescriptionvalidation".tr);
    }
    return null;
  }

  String? validateGender(String? value) {
    if (value!.isEmpty) {
      addError("kGenderNullError".tr);
      return '';
    } else {
      removeError("kGenderNullError".tr);
    }
    return null;
  }

  String? onChangedbirthdate(String? value) {
    if (RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$').hasMatch(value!)) {
      removeError("kbirthdateValidation".tr);
    }
    return null;
  }

  void onChangedGender(String? value) {
    if (value!.isNotEmpty) {
      removeError("kGenderNullError".tr);
    }
    gender = value;
    update();
  }

  String? onChangedphonenumber(String? value) {
    if (RegExp(r'^\d{8}$').hasMatch(value!)) {
      removeError("kPhoneNumberValidation".tr);
    }
    return null;
  }

  String? onChangedspecialization(String? value) {
    if (RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value!)) {
      removeError("kNamevalidationError".tr);
    }
    return null;
  }

  String? onChangeddescription(String? value) {
    if (value!.length < 3) {
      removeError("kdescriptionvalidation".tr);
    }
    return null;
  }

  void addError(String? error) {
    if (error != null && !errors.contains(error)) {
      errors.add(error);
      update();
    }
  }

  void removeError(String? error) {
    if (error != null && errors.contains(error)) {
      errors.remove(error);
      update();
    }
  }

  void onChangedetatcivil(String? value) {
    if (value!.isNotEmpty) {
      removeError("kTypeNullError".tr);
    }
    etatcivil = value;
    update();
  }

  void onChangeSpecialite(String? value) {
    if (value!.isNotEmpty) {
      removeError("kTypeNullError".tr);
    }
    specialite = value;
    update();
  }

  String? validatespecialization(String? value) {
    if (value!.isEmpty) {
      addError("kNamelNullError".tr);
      return '';
    } else if (!RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      addError("kNamevalidationError".tr);
      return '';
    } else {
      removeError("kNamevalidationError".tr);
    }
    return null;
  }

  Map<String, String> data = {};

  Future<void> updateProfil() async {
    isLoading.value = true;
    Map<String, String> data = {
      'email': emailController.text,
      'password': passwordController.text,
      'address': adressController.text,
      'phoneNumber': phoneNumberController.text,
    };
    if (user.role == 'Patient') {
      data['firstname'] = firstnameController.text;
      data['lastname'] = lastnameController.text;
      data['gender'] = gender;
      data['dateofbirth'] = dateofbirthController.text;
      data['civilstate'] = etatcivil;
      data['nembredenfant'] = nembredenfantController.text;
    } else if (user.role == 'HealthcareProvider') {
      if (user.type == 'Doctor') {
        data['firstname'] = firstnameController.text;
        data['lastname'] = lastnameController.text;
        data['gender'] = gender;
        data['description'] = descriptionController.text;
        data['speciality'] = specialite;
        data['appointmentprice'] = appointmentPrice.text;
      } else {
        data['name'] = nameController.text;
        data['description'] = descriptionController.text;
      }
    }
    try {
      if (formKeyEditProfile.currentState!.validate()) {
        var response = await networkHandler.put("$profilePath", data);
        if (response.statusCode == 200 || response.statusCode == 201) {
          print("profilepath status code  : ${response.statusCode}");
          if (imageFile != null &&
              imageFile!.path.isNotEmpty &&
              (globalRole == 'Patient' || globalType == 'Doctor')) {
            print("path : ${imageFile!.path}");
            final imageResponse =
                await networkHandler.patchImage(userpicPath, imageFile!.path);
            if (imageResponse.statusCode == 200) {
              String? type;
              type = await queryHealthcareProvdierType();
              if (type == 'Doctor') {
                Get.off(() => ProfileScreen(
                      user: user,
                    ));
                Get.snackbar("Admin Verification",
                    "Please wait until our admin approuve your account");
              } else {
                Get.off(() => ProfileScreen(
                      user: user,
                    ));
              }
            } else {
              print(" image path status code : ${imageResponse.statusCode}");
            }
          } else if (globalRole == 'HealthcareProvider' &&
              globalType != 'Doctor') {
            for (int i = 0; i < imageFiles.length; i++) {
              print(imageFiles);
              XFile? imageFile = imageFiles[i];
              if (imageFile != null && imageFile.path.isNotEmpty) {
                print("${imageFile.path}");
                final imageResponse = await networkHandler.patchImage(
                    buildpicPath, imageFile.path);
                if (imageResponse.statusCode == 200) {
                  Get.off(() => ProfileScreen(user: user));
                  Get.snackbar("Admin Verification",
                      "Please wait until our admin approuve your account");
                }
                print(
                    " image building path status code : ${imageResponse.statusCode}");
              }
            }
          }
        } else if (response.statusCode == 500) {
          final responseData = json.decode(response.body);
          final errors = responseData['message'];
          addError(errors);
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
