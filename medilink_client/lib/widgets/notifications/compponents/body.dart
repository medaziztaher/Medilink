import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/user.dart';
import '../notification_controller.dart';

class Body extends StatelessWidget {
  const Body({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    final usernotificationController =
        Get.put(NotificationsController(user: user));
    usernotificationController.getUserNotifications();

    return Obx(() {
      if (usernotificationController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (usernotificationController.notifications.isNotEmpty) {
        final notifications = usernotificationController.notifications;
        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return ListTile(
              title: Text(notification.message!),
              subtitle: Text(notification.date.toString()),
            );
          },
        );
      } else {
        return Center(child: Text('You don\'t have any notifications'));
      }
    });
  }
}
