import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/body.dart';
import 'get_surgerie_controller.dart';

class GetSurgerieScreen extends StatelessWidget {
  const GetSurgerieScreen({super.key, required this.surgerieId});
  final String surgerieId;

  @override
  Widget build(BuildContext context) {
    print(surgerieId);
    return GetBuilder<GetSurgerieController>(
      init: GetSurgerieController(surgerieId: surgerieId),
      builder: (controller) {
        return Scaffold(
          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (controller.surgerie != null && controller.userId != null) {
              return Body(
                  surgerie: controller.surgerie,
                  userId: controller.userId.value,
                  provider: controller.provider.value);
            } else {
              return Center(child: Text('No surgerie found'));
            }
          }),
        );
      },
    );
  }
}
