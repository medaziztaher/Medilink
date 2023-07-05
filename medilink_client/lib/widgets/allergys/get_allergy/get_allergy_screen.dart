import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/widgets/allergys/get_allergy/get_allergy_controller.dart';

import 'components/body.dart';

class GetAllergyScreen extends StatelessWidget {
  const GetAllergyScreen({super.key, required this.allergyId});
  final String allergyId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetAllergyController>(
      init: GetAllergyController(allergyId: allergyId),
      builder: (controller) {
        return Scaffold(
          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (controller.allergy != null) {
              return Body(allergy: controller.allergy);
            } else {
              return Center(child: Text('No allergie found'));
            }
          }),
        );
      },
    );
  }
}
