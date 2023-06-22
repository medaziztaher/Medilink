import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/widgets/prescriptions/prescirption/prescription.dart';

import '../../settings/networkhandler.dart';
import '../../settings/path.dart';

class PrescriptionsController extends GetxController {
  GlobalKey<FormState> formKeyPrescription = GlobalKey<FormState>();
  late TextEditingController medicamentController = TextEditingController();
  late TextEditingController dateDebutController = TextEditingController();
  late TextEditingController dateFinController = TextEditingController();
  late bool isLoading = false;
  String userId;
  final List<String?> errors = [];
  late String dosage = '1 pill';
  late String frequence = 'daily';
  PrescriptionsController({required this.userId}) {}
  NetworkHandler networkHandler = NetworkHandler();
  @override
  void onClose() {
    medicamentController.dispose();
    dateDebutController.dispose();
    dateFinController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    medicamentController = TextEditingController();
    dateDebutController = TextEditingController();
    dateFinController = TextEditingController();
    super.onInit();
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
    print(userId);
    frequence = value;
    update();
  }

  Future<void> addprescription() async {
    isLoading = true;
    Map<String, String> data = {
      'médicament': medicamentController.text,
      'dosage': dosage,
      'fréquence': frequence,
      'dateDébut': dateDebutController.text,
      'dateFin': dateFinController.text,
    };
    try {
      print(userId);
      if (formKeyPrescription.currentState!.validate()) {
        final response = await networkHandler.post(
            "$patientPath/$userId/prescriptions", data);
        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = json.decode(response.body);
          print(response);
          final id = responseData['_id'];
          Get.snackbar("Prescription", "Prescription added sucessfuly");
          Get.off(() => PrescriptionFile(presId: id));
        }
      }
    } catch (e) {
    } finally {
      isLoading = false;
    }
  }
}
