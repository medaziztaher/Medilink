import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medilink_client/widgets/home/home_screen.dart';

import '../../models/speciality.dart';
import '../../settings/networkhandler.dart';
import '../../settings/path.dart';
import '../../utils/global.dart';
import '../../utils/prefs.dart';
import '../signin/signin_screen.dart';

class CompleteProfileController extends GetxController {
  GlobalKey<FormState> formKeyCompleteProfile = GlobalKey<FormState>();
  late TextEditingController adressController;
  late TextEditingController phoneNumberController;
  late TextEditingController descriptionController;
  late TextEditingController dateofbirthController;
  late TextEditingController nembredenfantController;
  late TextEditingController veriffiactionControler;

  Rx<String> selectedDate = ''.obs;
  late bool isLoading = false;
  final pref = Pref();
  final List<String?> errors = [];
  late String gender = 'Male';
  late String etatcivil = 'Single';
  late String specialite = "";
  final errorMessage = ''.obs;
  NetworkHandler networkHandler = NetworkHandler();
  XFile? imageFile;
  XFile? verificationFile;
  XFile? educationFile;
  XFile? experienceFiLe;
  ImagePicker picker = ImagePicker();
  List<Speciality>? specialites;
  List<XFile?> imageFiles = List<XFile?>.filled(4, null);

  @override
  void onClose() {
    adressController.dispose();
    phoneNumberController.dispose();
    descriptionController.dispose();
    dateofbirthController.dispose();
    nembredenfantController.dispose();
    veriffiactionControler.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    adressController = TextEditingController();
    phoneNumberController = TextEditingController();
    descriptionController = TextEditingController();
    dateofbirthController = TextEditingController();
    nembredenfantController = TextEditingController();
    veriffiactionControler = TextEditingController();
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

  void takeverification(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    print(source);
    if (pickedFile != null) {
      verificationFile = XFile(pickedFile.path);
      update();
    }
  }

  Future<void> getAllSpeciality() async {
    isLoading = true;
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
    } finally {
      isLoading = false;
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

  Future<void> completeProfile() async {
    isLoading = true;
    removeError("kerror1".tr);
    removeError("kerror2".tr);
    try {
      if (formKeyCompleteProfile.currentState!.validate()) {
        Map<String, String> data = {
          'address': adressController.text,
          'phoneNumber': phoneNumberController.text,
          'gender': gender,
          'dateofbirth': dateofbirthController.text,
          'civilstate': etatcivil,
          'nembredenfant': nembredenfantController.text,
          'description': descriptionController.text,
          'speciality': specialite,
          'verifciation': veriffiactionControler.text,
        };
        final response = await networkHandler.put(profilePath, data);
        if (response.statusCode == 200 || response.statusCode == 201) {
          print("profilepath status code  : ${response.statusCode}");
          if (imageFile != null &&
              imageFile!.path.isNotEmpty &&
              (globalRole == 'Patient' || globalType == 'Doctor')) {
            print("path : ${imageFile!.path}");
            final imageResponse =
                await networkHandler.patchImage(userpicPath, imageFile!.path);
            if (imageResponse.statusCode == 200) {
              if (globalType == 'Doctor') {
                Get.offAll(() => SignInScreen());
                Get.snackbar("Admin Verification",
                    "Please wait until our admin approuve your account");
              }
              Get.offAll(() => HomeScreen());
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
                  Get.offAll(() => SignInScreen());
                  Get.snackbar("Admin Verification",
                      "Please wait until our admin approuve your account");
                }
                print(
                    " image building path status code : ${imageResponse.statusCode}");
              }
            }
          }
        }
      }
    } on SocketException {
      addError("kerror1".tr);
    } catch (e) {
      addError("kerror2".tr);
      print(e);
    } finally {
      isLoading = false;
    }
  }
}
