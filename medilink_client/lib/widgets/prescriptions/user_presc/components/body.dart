import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/models/prescription.dart';

import '../../../../models/user.dart';
import '../../get_presc/get_presc_screen.dart';
import '../user_presc_controller.dart';

class Body extends StatelessWidget {
  const Body({super.key, required this.user, required this.userId});
  final User user;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final userAllergyController =
        Get.put(UserPrescController(userId: user.id!));
    userAllergyController.getUserPrescriptions();

    return Obx(() {
      if (userAllergyController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (userAllergyController.prescriptions.isNotEmpty) {
        final prescriptions = userAllergyController.prescriptions;
        return ListView.builder(
          itemCount: prescriptions.length,
          itemBuilder: (context, index) {
            final prescription = prescriptions[index];
            return ListTile(
              title: Text(prescription.medication!),
              subtitle: Text(prescription.dosage.toString()),
              onTap: () {
                Get.off(() => GetPrescScreen(prescId: prescription.id!));
              },
            );
          },
        );
      } else {
        return Center(
            child: userId == user.id
                ? Text('You don\'t have any presciptions')
                : Text('this ${user.name} don\'t have any prescriptions'));
      }
    });
  }
}
