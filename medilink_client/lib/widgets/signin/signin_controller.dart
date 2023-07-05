import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/user.dart';
import '../../firebase/api/authentififcation.dart';
import '../../settings/path.dart';
import '../../settings/realtimelogic.dart';
import '../../utils/constatnts.dart';
import '../../utils/global.dart';
import '../../utils/prefs.dart';
import '../login_success/login_success_screen.dart';

class SignInController extends GetxController {
  GlobalKey<FormState> formKeySignIn = GlobalKey<FormState>();
  final SocketMethods _socket = SocketMethods();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late RxBool isLoading = false.obs;
  final isRememberMe = false.obs;
  final passToggle = false.obs;
  final List<String?> errors = [];
  final pref = Pref();
  final auth = Auth.instance;

  Future<void> submitForm() async {
    isLoading.value = true;
    removeError("kerror1".tr);
    removeError("kerror2".tr);
    print("password : ${passwordController.text}");
    Map<String, String> data = {
      'email': emailController.text,
      'password': passwordController.text,
    };
    try {
      if (formKeySignIn.currentState!.validate()) {
        final response = await networkHandler.post(login, data);
        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = json.decode(response.body);
          final token = responseData['token'];
          final message = responseData['message'];
          final status = responseData['success'];
          if (status == false) {
            Get.snackbar("Admin Verification", message);
          } else {
            setGlobalUserId(responseData['information']['_id']);
            await _socket.addUser(globalUserId);

            if (isRememberMe.value == true) {
              pref.prefs!.setString(kTokenSave, token);
            } else {
              setGlobalToken(token);
            }
            Get.offAll(() => LoginSuccessScreen());
            await pushDeviceToken();
          }
        } else if (response.statusCode == 404) {
          final responseData = json.decode(response.body);
          final message = responseData['message'];
          addError(message);
          passwordController.clear();
        } else {
          final errorMessageValue = json.decode(response.body)['message'];
          print(errorMessageValue);
          //addError(errorMessageValue);
          passwordController.clear();
        }
      }
    } on SocketException {
      addError('kerror1'.tr);
    } catch (e) {
      addError('kerror2'.tr);
    } finally {
      isLoading.value = false;
    }
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

  void toggleRememberMe() {
    isRememberMe.value = !isRememberMe.value;
    update();
  }

  void togglePasswordVisibility() {
    passToggle.value = !passToggle.value;
    update();
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
}
