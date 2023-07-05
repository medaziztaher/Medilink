import 'package:get/get.dart';


import '../../models/notififcation.dart';
import '../../models/user.dart';

import '../../settings/networkhandler.dart';
import '../../utils/global.dart';

class NotificationsController extends GetxController {
  final RxList<Notification> notifications = <Notification>[].obs;
  User user;
  RxBool isLoading = false.obs;
  NetworkHandler networkHandler = NetworkHandler();

  NotificationsController({required this.user});

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() async {
    await getUserNotifications();
  }

  Future<void> getUserNotifications() async {
    isLoading.value = true;
    try {
      final response = await networkHandler.get("$url/api/notifications");
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        final notificationList = data.map((item) => Notification.fromJson(item)).toList(growable: false);
        notifications.value = notificationList;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}