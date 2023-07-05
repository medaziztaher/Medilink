import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/models/user.dart';

import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';
import '../get_radio/get_radio_screen.dart';

class AddRadioController extends GetxController {
  GlobalKey<FormState> labformKey = GlobalKey<FormState>();
  late TextEditingController typeController;
  late TextEditingController descriptionController;
  late TextEditingController dateController;
  late TextEditingController reasonController;
  late TextEditingController selectedUsersController;
  User user = User();
  late RxBool isLoading = false.obs;
  NetworkHandler networkHandler = NetworkHandler();
  List<String> selectedUsers = [];
  List<String> filePaths = [];
  final List<String?> errors = [];
  AddRadioController({required this.user}) {}

  @override
  void onClose() {
    typeController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    reasonController.dispose();
    selectedUsersController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    typeController = TextEditingController();
    descriptionController = TextEditingController();
    dateController = TextEditingController();
    reasonController = TextEditingController();
    selectedUsersController = TextEditingController();
    super.onInit();
  }

  void openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      filePaths = result.paths.map((path) => path!).toList();
      update();
    }
  }

  Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      await file.delete();
      filePaths.remove(filePath);
      update();
    } catch (e) {
      print(e);
    }
  }

  void addUserToSharedWith(String user) {
    if (!selectedUsers.contains(user)) {
      selectedUsers.add(user);
      update();
      print(selectedUsers);
    }
  }

  void removeUserFromSharedWith(String user) {
    selectedUsers.remove(user);
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

  String? validatedate(String? value) {
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

  String? onChangeddescription(String? value) {
    if (value!.isNotEmpty) {
      removeError("description field can't be empty");
    } else if (RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      removeError("only text are allowed ");
    }
    return null;
  }

  String? validatedescription(String? value) {
    if (value!.isEmpty) {
      addError("description field can't be empty".tr);
      return '';
    } else if (!RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      addError("only text are allowed ");
      return '';
    } else {
      removeError("description field can't be empty".tr);
      removeError("only text are allowed ");
    }
    return null;
  }

  String? onChangedreason(String? value) {
    if (value!.isNotEmpty) {
      removeError("reason field can't be empty");
    } else if (RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      removeError("only text are allowed ");
    }
    return null;
  }

  String? validatereason(String? value) {
    if (value!.isEmpty) {
      addError("reason field can't be empty".tr);
      return '';
    } else if (!RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      addError("only text are allowed ");
      return '';
    } else {
      removeError("reason field can't be empty".tr);
      removeError("only text are allowed ");
    }
    return null;
  }

  Future<List<String>> fetchHealthcareProviders(String pattern) async {
    isLoading.value = true;
    try {
      final response = await networkHandler.get(careProviderspath);
      print(response);
      if (response['status'] == true) {
        print("data : ${response['data']}");
        final providers = response['data'] as List<dynamic>;
        final providerNames =
            providers.map((provider) => provider['name'] as String).toList();
        return providerNames;
      } else {
        throw Exception('Failed to fetch healthcare providers');
      }
    } catch (e) {
      print(e);
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }

    return [];
  }

  Future<void> addRadio() async {
    isLoading.value = true;
    Map<String, dynamic> data = {
      'type': typeController.text,
      'description': descriptionController.text,
      'date': dateController.text,
      'reason': reasonController.text,
      'sharedwith': selectedUsers
    };

    try {
      if (labformKey.currentState!.validate()) {
        final response = await networkHandler.post(
            "$patientPath/${user.id}/radiographies", data);
        final responseData = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          print(response.body);
          final id = responseData['_id'];
          final messaage = responseData['message'];
          for (int i = 0; i < filePaths.length; i++) {
            String filePath = filePaths[i];
            if (filePath.isNotEmpty) {
              print(filePath);
              final imageResponse = await networkHandler.patchImage(
                '$radiopicPath/$id',
                filePath,
              );
              if (imageResponse.statusCode == 200) {
                Get.off(() => GetRadioScreen(radioId: id));
              }

              print("Image path status code: ${imageResponse.statusCode}");
            }
          }
          Get.off(() => GetRadioScreen(radioId: id));
          Get.snackbar("Analyse", messaage);
        } else if (response.statusCode == 500) {
          final messaage = responseData['error'];
          Get.snackbar("Error", messaage);
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
