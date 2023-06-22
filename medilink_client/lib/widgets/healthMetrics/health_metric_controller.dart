import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/settings/networkhandler.dart';
import 'package:medilink_client/widgets/home/home_screen.dart';

import '../../settings/path.dart';

class MetricController extends GetxController {
  GlobalKey<FormState> formKeyMetric = GlobalKey<FormState>();
  bool isLoading = false;
  final valueController = TextEditingController();
  NetworkHandler networkHandler = NetworkHandler();
  String metric = '';

  @override
  void onClose() {
    valueController.dispose();
    super.onClose();
  }

  void setMetric(String value) {
    metric = value;
    update();
  }

  Future<void> submitForm() async {
    isLoading = true;
    Map<String, String> data = {
      'metricName': metric,
      'value': valueController.text,
    };
    try {
       if (formKeyMetric.currentState!.validate()) {
      final response = await networkHandler.post(healthMetricPath, data);
      print(response);
      if (response.statusCode == 201) {
        Get.snackbar("$metric", "New value added successfully");
        Get.off(() => HomeScreen());
        valueController.clear();
      }
      } else {
        Get.snackbar("$metric", "Failed to add health metric");
      }
    } catch (e) {
      print(e);
      isLoading = false;
    } finally {
      isLoading = false;
    }
  }
}
