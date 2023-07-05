import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/api/user.dart';

import '../../../settings/path.dart';
import '../../../utils/constatnts.dart';
import '../otp/otp.dart';

class ForgetPassEmail extends GetxController {
  GlobalKey<FormState> formKeySignIn = GlobalKey<FormState>();
  final emailController = TextEditingController();
    late RxBool isLoading = false.obs;
  final List<String?> errors = [];

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

  Future<void> onSubmit() async {
    isLoading.value = true;
    Map<String, String> data = {
      'email': emailController.text,
    };
    try {
      var response = await networkHandler.post('$auth/forgetPassword', data);
      print(response.body);
      var responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.off(() => OTPScreen(email: emailController.text));
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
