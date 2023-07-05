import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/models/diseases.dart';

import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';
import '../../../utils/global.dart';
import '../get_disease/get_disease_screen.dart';

class EditDiseaseController extends GetxController {
  Disease disease = Disease();
  GlobalKey<FormState> formKeyEditDisease = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  late RxBool isLoading = false.obs;

  late RxBool genetic = false.obs;
  late RxBool chronicDisease = false.obs;
  late TextEditingController specialityController;
  late TextEditingController curedInController;
  late TextEditingController detectedInController;
  late TextEditingController notesController;
  final List<String?> errors = [];
  EditDiseaseController({required this.disease}) {}
  @override
  void onInit() {
    super.onInit();
    specialityController = TextEditingController(text: disease.speciality);
    curedInController = TextEditingController(text: disease.curedIn);
    detectedInController = TextEditingController(text: disease.detectedIn);
    notesController = TextEditingController(text: disease.notes);
    genetic.value = disease.genetic ?? false;
    chronicDisease.value = disease.chronicDisease ?? false;
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

  Future<void> editDisease() async {
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
      if (formKeyEditDisease.currentState!.validate()) {
        var response =
            await networkHandler.put("$disesePath/${disease.id!}", data);
        print(response.statusCode);
        final responseData = json.decode(response.body);
        if (response.statusCode == 200) {
          final message = responseData['message'];
          Get.snackbar("Disease updated", message);
          Get.off(() => GetDiseaseScreen(diseaseId: disease.id!));
        } else if (response.statusCode == 500) {
          final message = responseData['error'];
          Get.snackbar('Failed', message);
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
