import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/models/prescription.dart';

import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';
import '../get_presc/get_presc_screen.dart';

class EditPrescriptionController extends GetxController {
  GlobalKey<FormState> formKeyPrescription = GlobalKey<FormState>();
  late TextEditingController medicamentController = TextEditingController();
  late TextEditingController dateDebutController = TextEditingController();
  late TextEditingController dateFinController = TextEditingController();
  late String dosage;
  late String frequence;
  Prescription prescription = Prescription();
  late RxBool isLoading = false.obs;
  NetworkHandler networkHandler = NetworkHandler();

  final List<String?> errors = [];
  EditPrescriptionController({required this.prescription}) {}

  @override
  void onClose() {
    medicamentController.dispose();
    dateDebutController.dispose();
    dateFinController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    medicamentController = TextEditingController(text: prescription.medication);
    dateDebutController = TextEditingController(text: prescription.startDate);
    dateFinController = TextEditingController(text: prescription.endDate);
    dosage = prescription.dosage!;
    frequence = prescription.frequency!;
    super.onInit();
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

  String? onChangedmedicament(String? value) {
    if (value!.isNotEmpty) {
      removeError("medicament field can't be empty");
    } else if (RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      removeError("only text are allowed ");
    }
    return null;
  }

  String? validatemedicament(String? value) {
    if (value!.isEmpty) {
      addError("medicament field can't be empty".tr);
      return '';
    } else if (!RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      addError("only text are allowed ");
      return '';
    } else {
      removeError("medicament field can't be empty".tr);
      removeError("only text are allowed ");
    }
    return null;
  }

  String? validatedateDebut(String? value) {
    DateTime? curedInDate = DateTime.tryParse(value!);
    DateTime? detectedInDate = DateTime.tryParse(dateDebutController.text);
    if (curedInDate == null) {
      addError("Please enter a valid date");
      return '';
    } else if (curedInDate.isBefore(detectedInDate!)) {
      addError("last date  must be after start date");
      return '';
    } else {
      removeError("Please enter the date");
      removeError("Please enter a valid date");
      removeError("last date  must be after start date");
    }

    return null;
  }

  String? validatedateFin(String? value) {
    if (value!.isEmpty) {
      addError("Please enter the dateFin");
      return '';
    } else {
      removeError("Please enter the dateFin");
    }
    return null;
  }

  String? validatedosage(String? value) {
    if (value!.isEmpty) {
      addError("dosage field can't be empty".tr);
      return '';
    } else {
      removeError("dosage field can't be empty".tr);
    }
    return null;
  }

  String? validatefrequence(String? value) {
    if (value!.isEmpty) {
      addError("frequence field can't be empty".tr);
      return '';
    } else {
      removeError("frequence field can't be empty".tr);
    }
    return null;
  }

  void onChangeddosage(String? value) {
    if (value!.isNotEmpty) {
      //removeError("kTypeNullError".tr);
    }
    dosage = value;
    update();
  }

  void onChangedfrequence(String? value) {
    if (value!.isNotEmpty) {
      //removeError("kTypeNullError".tr);
    }
    frequence = value;
    update();
  }

  Future<void> updatePrescription() async {
    isLoading.value = true;
    Map<String, String> data = {
      'médicament': medicamentController.text,
      'dosage': dosage,
      'fréquence': frequence,
      'dateDébut': dateDebutController.text,
      'dateFin': dateFinController.text,
    };
    try {
      if (formKeyPrescription.currentState!.validate()) {
        var response = await networkHandler.put(
            "$prescriptionsPath/${prescription.id}", data);
        print(response.statusCode);
        final responseData = json.decode(response.body);
        if (response.statusCode == 200) {
          final id = responseData['_id'];
          final message = responseData['message'];
          Get.snackbar("Prescription updated", message);
          Get.off(() => GetPrescScreen(prescId: id));
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
