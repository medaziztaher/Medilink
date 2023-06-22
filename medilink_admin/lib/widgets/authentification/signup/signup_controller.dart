import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../apis/admin.dart';
import '../../../services/networkhandler.dart';
import '../../../services/path.dart';
import '../../../services/realtimelogic.dart';
import '../../../utils/constatnts.dart';
import '../../../utils/global.dart';
import '../../../utils/prefs.dart';
import '../../home/home_screen.dart';

class SignupController extends GetxController {
  GlobalKey<FormState> formKeySignUp = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  final SocketMethods _socket = SocketMethods();
  //final auth = Auth.instance;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late RxBool isLoading = false.obs;
  final pref = Pref();
  final List<String?> errors = [];
  late String confirmpassword;
  final errorMessage = ''.obs;

  @override
  void onClose() {
    emailController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();

    passwordController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    emailController = TextEditingController();
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();

    passwordController = TextEditingController();
    super.onInit();
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
    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
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
    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
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
    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
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
    } else if (RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      removeError("kNamevalidationError".tr);
    }
    return null;
  }

  String? onChangedfirstname(String? value) {
    if (value!.isNotEmpty) {
      removeError("kFirstNamelNullError".tr);
    } else if (RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      removeError("kNamevalidationError".tr);
    }
    return null;
  }

  String? onChangedlastname(String? value) {
    if (value!.isNotEmpty) {
      removeError("kLastNamelNullError".tr);
    } else if (RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
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

  void showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }

  Future<void> submitForm() async {
    isLoading.value = true;
    removeError("kerror1".tr);
    removeError("kerror2".tr);
    Map<String, String> data = {
      'email': emailController.text,
      'password': passwordController.text,
      'firstname': firstnameController.text,
      'lastname': lastnameController.text
    };
    try {
      /* final response = await auth.createUser(
            emailController.text, passwordController.text, data);
        auth.setInitialsignupScreen(auth.firebaseUser.value);*/
      final response = await networkHandler.post(signupAdmin, data);
      if (response.statusCode == 400) {
        final responseData = json.decode(response.body);
        final errors = responseData['message'];
        print(errors);
      }
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        setGlobalToken(token);
        setGlobalUserId(responseData['admin']['id']);
        showSnackBar(responseData['message']);
        _socket.addUser(globalUserId);
        Get.to(() => const HomeScreen());
        await pushDeviceToken();
        //Get.to(() => MailVerfication());
        //Get.to(() => CompleteProfileScreen());
      } else if (response.statusCode == 422) {
        final responseData = json.decode(response.body);
        final errors = responseData['errors'];
        addError(errors.join('\n'));
      } else if (response.statusCode == 401) {
        final responseData = json.decode(response.body);
        final errors = responseData['errors'];
        if (errors != null) {
          addError(errors);
        } else {
          removeError(errors);
        }
      } else if (response.statusCode == 500) {
        final responseData = json.decode(response.body);
        final message = responseData['message'];
        print(message);
        addError(message);
      }
    } on SocketException {
      addError("kerror1".tr);
    } catch (e) {
      addError("kerror2".tr);
    } finally {
      isLoading.value = false;
    }
  }
}
