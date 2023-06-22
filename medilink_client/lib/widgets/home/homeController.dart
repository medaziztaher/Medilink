import 'dart:convert';
import 'package:get/get.dart';
import 'package:medilink_client/api/user.dart';
import 'package:medilink_client/utils/global.dart';

import '../../models/user.dart';
import '../../settings/networkhandler.dart';
import '../../settings/path.dart';

class HomeData extends GetxController {
  late User user = User();
  RxBool isLoading = false.obs;
  RxString errorMessage = 'No Error'.obs;

  NetworkHandler networkHandler = NetworkHandler();

  HomeData() {
    getHomeData();
  }

  @override
  void onInit() {
    super.onInit();
    getHomeData();
  }

  Future<void> getHomeData() async {
    isLoading.value = true;
    final String? id = globalUserId;
    String? userId;

    if (id != null) {
      userId = id;
    } else {
      userId = await queryUserID();
    }
    try {
      final response = await networkHandler.get("$userData/$userId");
      if (response['status'] == true) {
        user = User.fromJson(response['data']);
        update();
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
