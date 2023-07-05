import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/widgets/radiographie/add_radio/add_radio_screen.dart';

import '../../../../models/user.dart';
import '../../get_radio/get_radio_screen.dart';
import '../user_radio_controller.dart';


class Body extends StatelessWidget {
  const Body({super.key, required this.user, required this.userId});
  final User user;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final userAllergyController =
        Get.put(UserRadioController(userId: user.id!));
    userAllergyController.getUserRadiographie();

    return Obx(() {
      if (userAllergyController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (userAllergyController.radiographies.isNotEmpty) {
        final radiographies = userAllergyController.radiographies;
        return ListView.builder(
          itemCount: radiographies.length,
          itemBuilder: (context, index) {
            final radio = radiographies[index];
            return ListTile(
              title: Text(radio.type!),
              subtitle: Text(radio.date.toString()),
              onTap: () {
                Get.off(() => GetRadioScreen(radioId: radio.id!));
              },
            );
          },
        );
      } else {
        return Column(
          children: [
            Center(
                child: userId == user.id
                    ? Text('You don\'t have any radiographie')
                    : Text('this ${user.name} don\'t have any radiographie')),
           ],
        );
      }
    });
  }
}
