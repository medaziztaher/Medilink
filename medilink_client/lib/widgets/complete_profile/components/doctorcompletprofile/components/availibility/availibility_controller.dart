import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../settings/networkhandler.dart';
import '../../../../../../settings/path.dart';

class AvailabiltyController extends GetxController {
  GlobalKey<FormState> formKeyAvailibility = GlobalKey<FormState>();
  late TextEditingController dayController;
  late TextEditingController startController;
  late TextEditingController endController;
  late bool isLoading = false;
  final List<String?> errors = [];
  NetworkHandler networkHandler = NetworkHandler();
  XFile? imageFile;
  ImagePicker picker = ImagePicker();
  List<Map<String, dynamic>> availabilities = [];
  List<String> times = [
    '06:00 AM',
    '07:00 AM',
    '08:00 AM',
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];
  List<String> typeValues = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  @override
  void onClose() {
    dayController.dispose();
    startController.dispose();
    endController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    dayController = TextEditingController();
    startController = TextEditingController();
    endController = TextEditingController();
    super.onInit();
  }

  void onChangedDay(String? value) {
    if (value!.isNotEmpty) {
      removeError("kTypeNullError".tr);
    }
    dayController.text = value;
    update();
  }

  void onChangedStart(String? value) {
    if (value!.isNotEmpty) {
      removeError("kTypeNullError".tr);
    }
    startController.text = value;
    update();
  }

  void onChangedEnd(String? value) {
    if (value!.isNotEmpty) {
      removeError("kTypeNullError".tr);
    }
    endController.text = value;
    update();
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

  void addAvailability() {
    if (dayController.text.isNotEmpty &&
        startController.text.isNotEmpty &&
        endController.text.isNotEmpty) {
      Map<String, dynamic> availability = {
        'day': dayController.text,
        'start': startController.text,
        'end': endController.text,
      };

      int existingIndex = _findExistingAvailabilityIndex(availability);
      if (existingIndex != -1) {
        availabilities[existingIndex] = availability;
      } else {
        availabilities.add(availability);
      }

      dayController.clear();
      startController.clear();
      endController.clear();
    }
  }

  int _findExistingAvailabilityIndex(Map<String, dynamic> availability) {
    for (int i = 0; i < availabilities.length; i++) {
      Map<String, dynamic> existingAvailability = availabilities[i];
      if (existingAvailability['day'] == availability['day']) {
        return i;
      }
    }
    return -1;
  }

  Future<void> addavailabilities() async {
    isLoading = true;
    try {
      if (formKeyAvailibility.currentState!.validate()) {
        if (availabilities.isNotEmpty) {
          for (int i = 0; i < availabilities.length; i++) {
            Map<String, dynamic> availability = availabilities[i];
            if (availability != null) {
              final response = await networkHandler.post(
                availabiltyPath,
                availability,
              );
              if (response.statusCode == 201) {
                final responseData = json.decode(response.body);
                final message = responseData['message'];
                Get.snackbar("Availability added", message);
              }
            }
          }
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }
}
