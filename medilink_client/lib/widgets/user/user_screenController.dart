import 'dart:convert';
import 'package:get/get.dart';

import '../../models/user.dart';
import '../../settings/networkhandler.dart';
import '../../settings/path.dart';

class UserData extends GetxController {
  String userId;

  late User user;
  RxBool isLoading = false.obs;
  RxString errorMessage = 'No Error'.obs;

  NetworkHandler networkHandler = NetworkHandler();

  UserData({required this.userId}) {
    getUserData();
  }

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  Future<void> getUserData() async {
    isLoading.value = true;
    try {
      final response = await networkHandler.get("$userData/$userId");
      if (response['status'] == true) {
        user = User.fromJson(response['data']);
      } else {
        final data = json.decode(response['status']);
        errorMessage.value = data;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
