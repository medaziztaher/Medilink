import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/body.dart';
import 'get_presc_controller.dart';

class GetPrescScreen extends StatelessWidget {
  const GetPrescScreen({super.key, required this.prescId});
  final String prescId;

  @override
  Widget build(BuildContext context) {
    print(prescId);
    return GetBuilder<GetPrescController>(
      init: GetPrescController(prescId: prescId),
      builder: (controller) {
        return Scaffold(
          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (controller.prescription != null && controller.userId != null) {
              return Body(
                  prescription: controller.prescription,
                  userId: controller.userId.value,
                  provider: controller.provider.value);
            } else {
              return Center(child: Text('No Prescriptions found'));
            }
          }),
        );
      },
    );
  }
}
