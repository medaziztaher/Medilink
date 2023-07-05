import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/body.dart';
import 'get_radio_controller.dart';

class GetRadioScreen extends StatelessWidget {
  const GetRadioScreen({super.key, required this.radioId});
  final String radioId;

  @override
  Widget build(BuildContext context) {
    print(radioId);
    return GetBuilder<GetRadioController>(
      init: GetRadioController(radioId: radioId),
      builder: (controller) {
        return Scaffold(
          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (controller.radiographie != null && controller.userId != null) {
              return Body(
                  radiographie: controller.radiographie,
                  userId: controller.userId.value,
                  provider: controller.provider.value);
            } else {
              return Center(child: Text('No Radiographie found'));
            }
          }),
        );
      },
    );
  }
}
