import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../settings/networkhandler.dart';
import '../../../../../../settings/path.dart';

class EducationFormController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<EducationFormData> educations = [EducationFormData()].obs;
  final NetworkHandler networkHandler = NetworkHandler();

  void addeducation() {
    educations.add(EducationFormData());
  }

  void submitForm() async {
    if (formKey.currentState!.validate()) {
      final List<Map<String, dynamic>> educationMaps = [];

      for (final education in educations) {
        final Map<String, dynamic> educationMap = {
          'degree': education.degreeController.text,
          'institution': education.institutionController.text,
          'startYear': education.startYear?.toIso8601String(),
          'endYear': education.endYear?.toIso8601String()
        };

        educationMaps.add(educationMap);
      }

      if (educationMaps.isNotEmpty) {
        for (final education in educationMaps) {
          if (education != null) {
            final response = await networkHandler.post(
              educationPath,
              education,
            );
            if (response.statusCode == 201) {
              final responseData = json.decode(response.body);
              final message = responseData['message'];
              Get.snackbar("Education added", message);
            }
          }
        }
      }

      Get.snackbar(
        'Success',
        'Education added successfully',
        duration: Duration(seconds: 3),
      );

      formKey.currentState!.reset();
      educations.clear();
      educations.add(EducationFormData());
    } else {
      Get.snackbar(
        'Error',
        'Failed to add education',
        duration: Duration(seconds: 3),
      );
    }
  }
}

class EducationFormData {
  TextEditingController degreeController = TextEditingController();
  TextEditingController institutionController = TextEditingController();
  DateTime? startYear;
  DateTime? endYear;
}
