import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'components/body.dart';
import 'get_analyse_controller.dart';

class GetAnalyseScreen extends StatelessWidget {
  const GetAnalyseScreen({super.key, required this.analyseId});
  final String analyseId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetAnalyseController>(
      init: GetAnalyseController(analyseId: analyseId),
      builder: (controller) {
        return Scaffold(
          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (controller.analyse != null && controller.userId != null) {
              return Body(
                  analyse: controller.analyse,
                  userId: controller.userId.value,
                  provider: controller.provider.value);
            } else {
              return Center(child: Text('No Analyse found'));
            }
          }),
        );
      },
    );
  }
}
