import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../apis/admin.dart';
import '../../../services/networkhandler.dart';
import '../../../services/path.dart';
import '../../../utils/constatnts.dart';
import '../../../utils/global.dart';
import '../../../utils/prefs.dart';
import '../../home/home_screen.dart';

class SignInController extends GetxController {
  GlobalKey<FormState> formKeySignIn = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late RxBool isLoading = false.obs;
  final isRememberMe = false.obs;
  final passToggle = false.obs;
  final List<String?> errors = [];
  final prefs = Pref();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }

  Future<void> submitForm() async {
    isLoading.value = true;
    removeError("kerror1");
    removeError("kerror2");
    Map<String, dynamic> data = {
      'email': emailController.text,
      'password': passwordController.text,
    };
    try {
      final response = await networkHandler.post(login, data);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        final token = responseData['token'];
        setGlobalUserId(responseData['information']['_id']);
        print(responseData['information']);
        if (isRememberMe.value == true) {
          prefs.prefs!.setString(kTokenSave, token);
        } else {
          setGlobalToken(token);
        }
        showSnackBar(responseData['message']);
        print(responseData['message']);
        await pushDeviceToken();
        Get.to(() => const HomeScreen());  
      }
    } on SocketException {
      addError('kerror1');
    } catch (e) {
      addError('kerror2');
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
