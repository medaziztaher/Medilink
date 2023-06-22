import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../settings/networkhandler.dart';
import '../../settings/path.dart';
import 'allergy/allergy_file.dart';

class AllergyController extends GetxController {
  GlobalKey<FormState> allergyformKey = GlobalKey<FormState>();
  late TextEditingController typeController;
  late TextEditingController yearOfDiscoveryController;
  late TextEditingController followupStatusController;
  late TextEditingController notesController;
  late bool isLoading = false;
  NetworkHandler networkHandler = NetworkHandler();
  bool famillyhistory = false;

  @override
  void onClose() {
    typeController.dispose();
    yearOfDiscoveryController.dispose();
    followupStatusController.dispose();
    notesController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    typeController = TextEditingController();
    yearOfDiscoveryController = TextEditingController();
    followupStatusController = TextEditingController();
    notesController = TextEditingController();
    super.onInit();
  }

  void onChangedfamillhistory(bool value) {
    famillyhistory = value;
    update();
  }

  Future<void> addAllergy() async {
    isLoading = true;
    Map<String, dynamic> data = {
      'type': typeController.text,
      'yearOfDiscovery': yearOfDiscoveryController.text,
      'followupStatus': followupStatusController.text,
      'familyHistory': famillyhistory,
      'notes': notesController.text,
    };
    try {
      if (allergyformKey.currentState!.validate()) {
        final response = await networkHandler.post(allergiesPath, data);
        if (response.statusCode == 201 || response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final id= responseData['_id'];
          Get.snackbar("Allergy", "New Allergy Added");
          Get.off(()=>AllergyFile(alergId: id));
          typeController.clear();
          yearOfDiscoveryController.clear();
          followupStatusController.clear();
          notesController.clear();
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }
}
