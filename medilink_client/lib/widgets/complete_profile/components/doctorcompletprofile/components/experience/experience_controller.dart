import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../settings/networkhandler.dart';
import '../../../../../../settings/path.dart';

class ExperienceFormController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<ExperienceFormData> experiences = [ExperienceFormData()].obs;
  final NetworkHandler networkHandler = NetworkHandler();
  final currentExperience = ExperienceFormData().obs;

  void addExperience() {
    experiences.add(ExperienceFormData());
  }

  void submitForm() async {
    if (formKey.currentState!.validate()) {
      final List<Map<String, dynamic>> experienceMaps = [];

      for (final experience in experiences) {
        final Map<String, dynamic> experienceMap = {
          'position': experience.positionController.text,
          'institution': experience.institutionController.text,
          'startYear': experience.startYear?.toIso8601String(),
        };

        if (experience.isCurrentJob) {
          experienceMap['endYear'] = null;
        } else {
          experienceMap['endYear'] = experience.endYear!.toIso8601String();
        }

        experienceMaps.add(experienceMap);
      }

      if (experienceMaps.isNotEmpty) {
        for (int i = 0; i < experienceMaps.length; i++) {
          Map<String, dynamic> experience = experienceMaps[i];
          if (experience != null) {
            final response = await networkHandler.post(
              availabiltyPath,
              experience,
            );
            if (response.statusCode == 201) {
              final responseData = json.decode(response.body);
              final message = responseData['message'];
              Get.snackbar("experience added", message);
            }
          }
        }
      }

      Get.snackbar(
        'Success',
        'Experiences added successfully',
        duration: Duration(seconds: 3),
      );

      formKey.currentState!.reset();
      currentExperience.value = ExperienceFormData();
      experiences.clear();
      experiences.add(ExperienceFormData());
    } else {
     
      Get.snackbar(
        'Error',
        'Failed to add experiences',
        duration: Duration(seconds: 3),
      );
    }
  }
}

class ExperienceFormData {
  TextEditingController positionController = TextEditingController();
  TextEditingController institutionController = TextEditingController();
  DateTime? startYear;
  DateTime? endYear;

  bool get isCurrentJob {
    return endYear == null;
  }
}
