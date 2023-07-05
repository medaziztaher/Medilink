import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/api/user.dart';
import 'package:medilink_client/widgets/signin/signin_screen.dart';

import '../../../settings/path.dart';

class ResetPassController extends GetxController {
  GlobalKey<FormState> formKeyResetPass = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  late String confirmpassword;
  late RxBool isLoading = false.obs;
  String email;
  final List<String?> errors = [];
  ResetPassController({required this.email}) {}
  String? onChangedPassword(String? value) {
    if (value!.isNotEmpty) {
      removeError("kPassNullError".tr);
    } else if (value.length >= 8) {
      removeError("kShortPassError".tr);
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

  Future<void> submitForm() async {
    isLoading.value = true;
    Map<String, String> data = {
      'password': passwordController.text,
    };
    try {
      var response =
          await networkHandler.post('$auth/resetPassword/$email', data);
      print(response);
      final responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.off(() => SignInScreen());
        Get.snackbar("Password changed", "Password changed successfully ");
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
