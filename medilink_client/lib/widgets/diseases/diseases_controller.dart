import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/settings/path.dart';

import '../../settings/networkhandler.dart';
import 'disease/disease_file.dart';

class DiseaseController extends GetxController {
  GlobalKey<FormState> diseasesformKey = GlobalKey<FormState>();
  late TextEditingController specialityController;
  late TextEditingController detectedInController;
  late TextEditingController curedInController;
  late TextEditingController notesController;
  late bool isLoading = false;
  NetworkHandler networkHandler = NetworkHandler();
  bool genetic = false;
  bool chronicDisease = false;

  @override
  void onClose() {
    specialityController.dispose();
    detectedInController.dispose();
    curedInController.dispose();
    notesController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    specialityController = TextEditingController();
    detectedInController = TextEditingController();
    curedInController = TextEditingController();
    notesController = TextEditingController();
    super.onInit();
  }

  void onChangedgentic(bool value) {
    genetic = value;
    update();
  }

  void onChangedchronic(bool value) {
    chronicDisease = value;
    update();
  }

  Future<void> addDisease() async {
    isLoading = true;
    Map<String, dynamic> data = {
      'speciality': specialityController.text,
      'genetic': genetic,
      'chronicDisease': chronicDisease,
      'detectedIn': detectedInController.text,
      'notes': notesController.text,
      'curedIn': curedInController.text,
    };
    try {
      if (diseasesformKey.currentState!.validate()) {
        final response = await networkHandler.post(disesesPath, data);
        if (response.statusCode == 201 || response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final id = responseData['_id'];
          Get.snackbar("Disease", "New Disease Added");
          Get.off(() => DiseaseFile(diseasId: id));
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
      isLoading = false;
    }
  }
}
