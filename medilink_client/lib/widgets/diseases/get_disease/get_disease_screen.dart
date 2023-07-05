import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/body.dart';
import 'get_disease_controller.dart';

class GetDiseaseScreen extends StatelessWidget {
  const GetDiseaseScreen({super.key, required this.diseaseId});
  final String diseaseId;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetDiseaseController>(
      init: GetDiseaseController(diseaseId: diseaseId),
      builder: (controller) {
        return Scaffold(
          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (controller.disease != null) {
              return Body(disease: controller.disease);
            } else {
              return Center(child: Text('no disease found'));
            }
          }),
        );
      },
    );
  }
}
