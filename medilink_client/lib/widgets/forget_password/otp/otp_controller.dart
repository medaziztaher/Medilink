import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/api/user.dart';

import '../../../settings/path.dart';
import '../../../utils/constatnts.dart';
import '../reset_password/reset_password.dart';

class OTPController extends GetxController {
  GlobalKey<FormState> formKeyOTP = GlobalKey<FormState>();
  final otpController = TextEditingController();
  late RxBool isLoading = false.obs;
  String email;
  final List<String?> errors = [];
  OTPController({required this.email}) {}

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

  String? onChangedEmail(String? value) {
    if (value!.isNotEmpty) {
      removeError("kEmailNullError".tr);
    } else if (emailValidatorRegExp.hasMatch(value)) {
      removeError("kInvalidEmailError".tr);
    }
    return null;
  }

  void addError(String? error) {
    if (!errors.contains(error)) {
      errors.add(error);
      update();
    }
  }

  void removeError(String? error) {
    if (errors.contains(error)) {
      errors.remove(error);
      update();
    }
  }

  Future<void> resendOTP() async {
    isLoading.value = true;
    Map<String, String> data = {
      'email': email,
    };
    try {
      var response = await networkHandler.post('$auth/forgetPassword', data);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("OTP resent", "Please check your Email");
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submit() async {
    isLoading.value = true;
    Map<String, String> data = {
      'resetCode': otpController.text,
    };
    try {
      var response = await networkHandler.post("$auth/checkCode/$email", data);
      print(response);
      final responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.off(() => ResetPassScreen(email: email));
      } else {
        final message = responseData['error'];
        addError(message);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
