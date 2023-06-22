import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../settings/networkhandler.dart';
import '../../settings/path.dart';
import 'components/lab_result/user_lab_result.dart';

class LabResultController extends GetxController {
  GlobalKey<FormState> labformKey = GlobalKey<FormState>();
  late TextEditingController testController;
  late TextEditingController resultController;
  late TextEditingController dateController;
  late TextEditingController reasonController;
  late TextEditingController selectedUsersController;
  String userId;
  bool isLoading = false;
  NetworkHandler networkHandler = NetworkHandler();
  List<String> selectedUsers = [];
  List<String> filePaths = [];
  LabResultController({required this.userId}) {}

  @override
  void onClose() {
    testController.dispose();
    resultController.dispose();
    dateController.dispose();
    reasonController.dispose();
    selectedUsersController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    testController = TextEditingController();
    resultController = TextEditingController();
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

  Future<List<String>> fetchHealthcareProviders(String pattern) async {
    isLoading = true;
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
      isLoading = false;
    } finally {
      isLoading = false;
    }

    return [];
  }

  Future<void> addLabResult() async {
    isLoading = true;
    Map<String, dynamic> data = {
      'test': testController.text,
      'result': resultController.text,
      'date': dateController.text,
      'reason': reasonController.text,
      'sharedwith': selectedUsers
    };

    try {
      if (labformKey.currentState!.validate()) {
        final response =
            await networkHandler.post("$patientPath/$userId/labresult", data);
        if (response.statusCode == 200 || response.statusCode == 201) {
          print(response.body);
          final responseData = json.decode(response.body);
          final id = responseData['_id'];
          for (int i = 0; i < filePaths.length; i++) {
            String filePath = filePaths[i];
            if (filePath.isNotEmpty) {
              print(filePath);
              final imageResponse = await networkHandler.patchImage(
                '$labFilePath/$id',
                filePath,
              );
              if (imageResponse.statusCode == 200) {
                Get.off(() => LabResult(labid: id));
              }
              print("Image path status code: ${imageResponse.statusCode}");
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
