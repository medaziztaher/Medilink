import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/user.dart';
import '../../get_analyse/get_analyse_screen.dart';
import '../user_analyse_controller.dart';

class Body extends StatelessWidget {
  const Body({super.key, required this.user, required this.userId});
  final User user;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final userAllergyController =
        Get.put(UserAnalysesController(userId: user.id!));
    userAllergyController.getUserAnalyse();

    return Obx(() {
      if (userAllergyController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (userAllergyController.analyses.isNotEmpty) {
        final analyses = userAllergyController.analyses;
        return ListView.builder(
          itemCount: analyses.length,
          itemBuilder: (context, index) {
            final analyse = analyses[index];
            return ListTile(
              title: Text(analyse.test!),
              subtitle: Text(analyse.date.toString()),
              onTap: () {
                Get.off(() => GetAnalyseScreen(analyseId: analyse.id!));
              },
            );
          },
        );
      } else {
        return Center(
            child: userId == user.id
                ? Text('You don\'t have any analyses')
                : Text('this ${user.name} don\'t have any Analyses'));
      }
    });
  }
}
