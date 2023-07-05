import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';
import '../get_disease/get_disease_screen.dart';

class AddDiseaseController extends GetxController {
  GlobalKey<FormState> formKeyAddDisease = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();

  late RxBool isLoading = false.obs;
  late RxBool genetic = false.obs;
  late RxBool chronicDisease = false.obs;
  late TextEditingController specialityController;
  late TextEditingController curedInController;
  late TextEditingController detectedInController;
  late TextEditingController notesController;
  final List<String?> errors = [];
  @override
  void onInit() {
    super.onInit();
    specialityController = TextEditingController();
    curedInController = TextEditingController();
    detectedInController = TextEditingController();
    notesController = TextEditingController();
  }

  @override
  void onClose() {
    specialityController.dispose();
    curedInController.dispose();
    detectedInController.dispose();
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

  String? onChangedspeciality(String? value) {
    if (value!.isNotEmpty) {
      removeError("speciality field can't be empty");
    } else if (RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      removeError("only text are allowed ");
    }
    return null;
  }

  String? validatespeciality(String? value) {
    if (value!.isEmpty) {
      addError("speciality field can't be empty".tr);
      return '';
    } else if (!RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      addError("only text are allowed ");
      return '';
    } else {
      removeError("speciality field can't be empty".tr);
      removeError("only text are allowed ");
    }
    return null;
  }

  String? validatecuredIn(String? value) {
    DateTime? curedInDate = DateTime.tryParse(value!);
    DateTime? detectedInDate = DateTime.tryParse(detectedInController.text);
    if (curedInDate == null) {
      addError("Please enter a valid date");
      return '';
    } else if (curedInDate.isBefore(detectedInDate!)) {
      addError("Cured in date must be after detected in date");
      return '';
    } else {
      removeError("Please enter the date");
      removeError("Please enter a valid date");
      removeError("Cured in date must be after detected in date");
    }

    return null;
  }

  String? validatedetectedIn(String? value) {
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

  void onChangedgenetic(bool value) {
    genetic.value = value;
  }

  void onChangedchronicDisease(bool value) {
    chronicDisease.value = value;
  }

  Future<void> addDisease() async {
    isLoading.value = true;
    Map<String, dynamic> data = {
      'speciality': specialityController.text,
      'genetic': genetic.value,
      'chronicDisease': chronicDisease.value,
      'detectedIn': detectedInController.text,
      'notes': notesController.text,
      'curedIn': curedInController.text,
    };
    try {
      if (formKeyAddDisease.currentState!.validate()) {
        final response = await networkHandler.post(disesesPath, data);
        if (response.statusCode == 201 || response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final id = responseData['_id'];
          Get.snackbar("Disease", "New Disease Added");
          Get.off(() => GetDiseaseScreen(
                diseaseId: id,
              ));
          print(responseData);
          specialityController.clear();
          detectedInController.clear();
          curedInController.clear();
        }
        notesController.clear();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
