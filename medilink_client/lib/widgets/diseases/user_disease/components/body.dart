import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/user.dart';
import '../../get_disease/get_disease_screen.dart';
import '../user_disease_controller.dart';

class Body extends StatelessWidget {
  const Body({super.key, required this.user, this.userId});
  final User user;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final userDiseaseController =
        Get.put(UserDiseaseController(userId: user.id!));
    userDiseaseController.getUserDiseases();

    return Obx(() {
      if (userDiseaseController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (userDiseaseController.diseases.isNotEmpty) {
        final diseases = userDiseaseController.diseases;
        return ListView.builder(
          itemCount: diseases.length,
          itemBuilder: (context, index) {
            final allergy = diseases[index];
            return ListTile(
              title: Text(allergy.speciality!),
              subtitle: Text(allergy.notes.toString()),
              onTap: () {
                Get.off(() => GetDiseaseScreen(
                      diseaseId: allergy.id!,
                    ));
              },
            );
          },
        );
      } else {
        return Center(
            child: userId == user.id
                ? Text('You don\'t have any diseases')
                : Text('this ${user.name} don\'t have any diseases'));
      }
    });
  }
}
