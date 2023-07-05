import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';
import '../get_allergy/get_allergy_screen.dart';

class AddAllergyController extends GetxController {
  GlobalKey<FormState> formKeyAddAllergy = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();

  late RxBool isLoading = false.obs;
  late RxBool familyHistory = false.obs;
  late TextEditingController typeController;
  late TextEditingController yearOfDiscoveryController;
  late TextEditingController followupStatusController;
  late TextEditingController notesController;
  final List<String?> errors = [];
  @override
  void onInit() {
    super.onInit();
    typeController = TextEditingController();
    yearOfDiscoveryController = TextEditingController();
    followupStatusController = TextEditingController();
    notesController = TextEditingController();
  }

  @override
  void onClose() {
    typeController.dispose();
    yearOfDiscoveryController.dispose();
    followupStatusController.dispose();
    notesController.dispose();
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

  String? onChangedtype(String? value) {
    if (value!.isNotEmpty) {
      removeError("type field can't be empty");
    } else if (RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      removeError("only text are allowed ");
    }
    return null;
  }

  String? validatetype(String? value) {
    if (value!.isEmpty) {
      addError("type field can't be empty".tr);
      return '';
    } else if (!RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      addError("only text are allowed ");
      return '';
    } else {
      removeError("type field can't be empty".tr);
      removeError("only text are allowed ");
    }
    return null;
  }

  String? validateyearOfDiscovery(String? value) {
    if (value!.isEmpty) {
      addError("Please enter the date");
      return '';
    } else {
      DateTime? date = DateTime.tryParse(value);
      if (date == null) {
        addError("Please enter a valid date");
        return '';
      } else if (date.isAfter(DateTime.now())) {
        addError("Date must be before today's date");
        return '';
      } else {
        removeError("Please enter the date");
      }
    }
    return null;
  }

  String? onChangedfollowupStatus(String? value) {
    if (value!.isNotEmpty) {
      removeError("followup Status field can't be empty");
    } else if (RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      removeError("only text are allowed ");
    }
    return null;
  }

  String? validatefollowupStatus(String? value) {
    if (value!.isEmpty) {
      addError("followup Status field can't be empty".tr);
      return '';
    } else if (!RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      addError("only text are allowed ");
      return '';
    } else {
      removeError("followup Status field can't be empty".tr);
      removeError("only text are allowed ");
    }
    return null;
  }

  String? onChangednotes(String? value) {
    if (value!.isNotEmpty) {
      removeError("notes field can't be empty");
    } else if (RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      removeError("only text are allowed ");
    }
    return null;
  }

  String? validatenotes(String? value) {
    if (value!.isEmpty) {
      addError("notes field can't be empty".tr);
      return '';
    } else if (!RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      addError("only text are allowed ");
      return '';
    } else {
      removeError("notes field can't be empty".tr);
      removeError("only text are allowed ");
    }
    return null;
  }

  void onChangedfamilyHistory(bool value) {
    familyHistory.value = value;
  }

  Future<void> addAllergy() async {
    isLoading.value = true;
    Map<String, dynamic> data = {
      'type': typeController.text,
      'yearOfDiscovery': yearOfDiscoveryController.text,
      'followupStatus': followupStatusController.text,
      'familyHistory': familyHistory.value,
      'notes': notesController.text,
    };
    try {
      if (formKeyAddAllergy.currentState!.validate()) {
        final response = await networkHandler.post(allergiesPath, data);
        print(response.statusCode);
        if (response.statusCode == 201 || response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final id = responseData['_id'];
          Get.snackbar("Allergy", "New Allergy Added");
          Get.off(() => GetAllergyScreen(
                allergyId: id,
              ));
          typeController.clear();
          yearOfDiscoveryController.clear();
          followupStatusController.clear();
          notesController.clear();
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
