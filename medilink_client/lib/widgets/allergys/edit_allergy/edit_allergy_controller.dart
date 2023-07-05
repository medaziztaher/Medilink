import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/models/allergy.dart';
import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';
import '../get_allergy/get_allergy_screen.dart';

class EditAllergyController extends GetxController {
  Allergy allergy = Allergy();
  GlobalKey<FormState> formKeyEditAllergy = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  late RxBool isLoading = false.obs;
  late RxBool familyHistory = false.obs;
  late TextEditingController typeController;
  late TextEditingController yearOfDiscoveryController;
  late TextEditingController followupStatusController;
  late TextEditingController notesController;
  final List<String?> errors = [];
  EditAllergyController({required this.allergy}) {}

  @override
  void onInit() {
    super.onInit();
    typeController = TextEditingController(text: allergy.type);
    yearOfDiscoveryController =
        TextEditingController(text: allergy.yearOfDiscovery.toString());
    followupStatusController = followupStatusController =
        TextEditingController(text: allergy.followupStatus);
    notesController = TextEditingController(text: allergy.notes);
    familyHistory.value = allergy.familyHistory ?? false;
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
      removeError("Please enter the date");
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

  Future<void> updateAllergy() async {
    isLoading.value = true;
    Map<String, dynamic> data = {
      'type': typeController.text,
      'yearOfDiscovery': yearOfDiscoveryController.text,
      'followupStatus': followupStatusController.text,
      'familyHistory': familyHistory.value,
      'notes': notesController.text,
    };
    print(data);
    try {
      final response =
          await networkHandler.put("$allergysPath/${allergy.id}", data);
      print(response.statusCode);
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final message = responseData['message'];
        Get.snackbar("Allergy updated", message);
        Get.off(() => GetAllergyScreen(allergyId: allergy.id!));
      } else if (response.statusCode == 500) {
        final message = responseData['error'];
        Get.snackbar('Failed', message);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
