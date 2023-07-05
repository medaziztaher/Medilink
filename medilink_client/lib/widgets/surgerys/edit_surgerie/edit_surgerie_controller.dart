import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/models/surgery.dart';

import '../../../settings/networkhandler.dart';
import '../../../settings/path.dart';
import '../get_surgerie/get_surgerie_screen.dart';

class EditSurgerieController extends GetxController {
  GlobalKey<FormState> formKeyEditSurgerie = GlobalKey<FormState>();
  late TextEditingController typeController;
  late TextEditingController descriptionController;
  late TextEditingController dateController;
  late TextEditingController complicationsController;
  late TextEditingController selectedUsersController;
  Surgerie surgerie = Surgerie();
  late RxBool isLoading = false.obs;
  NetworkHandler networkHandler = NetworkHandler();
  List<String> selectedUsers = [];
  List<String> filePaths = [];
  final List<String?> errors = [];
  EditSurgerieController({required this.surgerie}) {}

  @override
  void onClose() {
    typeController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    complicationsController.dispose();
    selectedUsersController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    typeController = TextEditingController(text: surgerie.type);
    descriptionController = TextEditingController(text: surgerie.description);
    dateController = TextEditingController(text: surgerie.date);
    complicationsController =
        TextEditingController(text: surgerie.complications);
    selectedUsersController = TextEditingController();
    filePaths = surgerie.files ?? [];

    if (filePaths.isNotEmpty) {
      filePaths = surgerie.files!
          .map((file) => file.replaceAll('$surgeriePath/', ''))
          .toList();
    }
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
      bool exists = await file.exists();
      if (exists) {
        await file.delete();
        filePaths.remove(filePath);
        update();
      } else {
        var response = await networkHandler
            .delete("$surgeriepicPath/${surgerie.id}/$file");
        final responseData = json.decode(response.body);
        if (response.statusCode == 200) {
          final message = responseData['message'];
          Get.snackbar("deleted ", message);
          filePaths.remove(filePath);
          update();
        }
      }
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
        removeError("Date must be before today's date");
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

  String? onChangedcomplications(String? value) {
    if (value!.isNotEmpty) {
      removeError("complications field can't be empty");
    } else if (RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      removeError("only text are allowed ");
    }
    return null;
  }

  String? validatecomplications(String? value) {
    if (value!.isEmpty) {
      addError("complications field can't be empty".tr);
      return '';
    } else if (!RegExp(r'^[a-zA-Z\s.,!?]+$').hasMatch(value)) {
      addError("only text are allowed ");
      return '';
    } else {
      removeError("complications field can't be empty".tr);
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

  Future<void> updateSurgerie() async {
    isLoading.value = true;
    Map<String, dynamic> data = {
      'type': typeController.text,
      'description': descriptionController.text,
      'date': dateController.text,
      'complications': complicationsController.text,
      'sharedwith': selectedUsers
    };
    try {
      if (formKeyEditSurgerie.currentState!.validate()) {
        var response =
            await networkHandler.put("$surgeriesPaths/${surgerie.id}", data);
        final responseData = json.decode(response.body);
        print(responseData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          print(response.body);
          final id = responseData['_id'];
          print("id     $id");
          final messaage = responseData['message'];
          for (int i = 0; i < filePaths.length; i++) {
            String filePath = filePaths[i];
            if (filePath != surgerie.files && File(filePath).existsSync()) {
              print(filePath);
              final imageResponse = await networkHandler.patchImage(
                '$radiographiePath/$id',
                filePath,
              );
              if (imageResponse.statusCode == 200) {
                Get.off(() => GetSurgerieScreen(
                      surgerieId: id,
                    ));
              }
              print("Image path status code: ${imageResponse.statusCode}");
            }
          }
          Get.off(() => GetSurgerieScreen(
                surgerieId: id,
              ));
          Get.snackbar("radiographie", messaage);
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
